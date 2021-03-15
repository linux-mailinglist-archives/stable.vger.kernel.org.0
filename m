Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64ED33B55C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhCONyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhCONxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53BE964F09;
        Mon, 15 Mar 2021 13:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816420;
        bh=T8deVsoflrBrjDVkIa3NOKgs6WFSLpGXqZYchHTwFmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkmREle+itj3JeoG78cqZmUcaQHVLYqNIFkrz2G+eWq5n+rZY5aMKu2MNDN1tKbQy
         /92ZVdKza/8QZwBHROo2YldFk80sIelaooXiUG3ksJb8VoeBw0B8Uf9FJ25qK9jZ/k
         YEE801a2kUdqPsxnLOARM7q6ka/quoxzqsDC4E7Q=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Bjoern Walk <bwalk@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 28/78] s390/dasd: fix hanging DASD driver unbind
Date:   Mon, 15 Mar 2021 14:51:51 +0100
Message-Id: <20210315135212.991503020@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Stefan Haberland <sth@linux.ibm.com>

commit 7d365bd0bff3c0310c39ebaffc9a8458e036d666 upstream.

In case of an unbind of the DASD device driver the function
dasd_generic_remove() is called which shuts down the device.
Among others this functions removes the int_handler from the cdev.
During shutdown the device cancels all outstanding IO requests and waits
for completion of the clear request.
Unfortunately the clear interrupt will never be received when there is no
interrupt handler connected.

Fix by moving the int_handler removal after the call to the state machine
where no request or interrupt is outstanding.

Cc: stable@vger.kernel.org
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Tested-by: Bjoern Walk <bwalk@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -3399,8 +3399,6 @@ void dasd_generic_remove(struct ccw_devi
 	struct dasd_device *device;
 	struct dasd_block *block;
 
-	cdev->handler = NULL;
-
 	device = dasd_device_from_cdev(cdev);
 	if (IS_ERR(device)) {
 		dasd_remove_sysfs_files(cdev);
@@ -3419,6 +3417,7 @@ void dasd_generic_remove(struct ccw_devi
 	 * no quite down yet.
 	 */
 	dasd_set_target_state(device, DASD_STATE_NEW);
+	cdev->handler = NULL;
 	/* dasd_delete_device destroys the device reference. */
 	block = device->block;
 	dasd_delete_device(device);



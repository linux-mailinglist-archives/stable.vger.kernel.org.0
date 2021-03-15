Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CE733B7DE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhCOOBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232471AbhCON7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC38464EF9;
        Mon, 15 Mar 2021 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816771;
        bh=wmSJzdMwCOzPUjx8SWQUQRJX27s79VJqdKjOsW4Yauo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFWl8XWXDgLEcp8ku3QJUmOGkmzTGeVGMe3jn/bkubzjn1GPkqcEQTXiQp+vo7Gfo
         Em5r3i96nzH9yfGUteFiQvWkq3DmfV9X8racc6NxHRlS65jZ7+noZ1TeweVtU4ApW7
         gW5z82GGnn5AcDZ8trhekwaS83JnSIBb0+nm44kM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Bjoern Walk <bwalk@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 098/168] s390/dasd: fix hanging DASD driver unbind
Date:   Mon, 15 Mar 2021 14:55:30 +0100
Message-Id: <20210315135553.591815804@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
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
@@ -3522,8 +3522,6 @@ void dasd_generic_remove(struct ccw_devi
 	struct dasd_device *device;
 	struct dasd_block *block;
 
-	cdev->handler = NULL;
-
 	device = dasd_device_from_cdev(cdev);
 	if (IS_ERR(device)) {
 		dasd_remove_sysfs_files(cdev);
@@ -3542,6 +3540,7 @@ void dasd_generic_remove(struct ccw_devi
 	 * no quite down yet.
 	 */
 	dasd_set_target_state(device, DASD_STATE_NEW);
+	cdev->handler = NULL;
 	/* dasd_delete_device destroys the device reference. */
 	block = device->block;
 	dasd_delete_device(device);



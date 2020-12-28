Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E524A2E436D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406039AbgL1Pdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407386AbgL1NyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:54:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E572F20731;
        Mon, 28 Dec 2020 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163625;
        bh=hZO3f+sU8DLpmWcx9RIoRxYScZUiG1znp4VtXoefxS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPhMGu6KQyKeOPFkcpcpV41fkvHJcK5pY2UttKTQyCmmxFTpQFvFwVNohGu2MTI/v
         WNQVoKMto6AbEvaHfPFZdAe22wVH+7dZwyMiSveDv+fQfhf1R3AgCRYnohYl16s/Wd
         L9EtdlyVQlQ30U8Er//dmJKxLEwcJwx3ShoNaVxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 352/453] s390/dasd: fix list corruption of lcu list
Date:   Mon, 28 Dec 2020 13:49:48 +0100
Message-Id: <20201228124954.144537956@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit 53a7f655834c7c335bf683f248208d4fbe4b47bc upstream.

In dasd_alias_disconnect_device_from_lcu the device is removed from any
list on the LCU. Afterwards the LCU is removed from the lcu list if it
does not contain devices any longer.

The lcu->lock protects the lcu from parallel updates. But to cancel all
workers and wait for completion the lcu->lock has to be unlocked.

If two devices are removed in parallel and both are removed from the LCU
the first device that takes the lcu->lock again will delete the LCU because
it is already empty but the second device also tries to free the LCU which
leads to a list corruption of the lcu list.

Fix by removing the device right before the lcu is checked without
unlocking the lcu->lock in between.

Fixes: 8e09f21574ea ("[S390] dasd: add hyper PAV support to DASD device driver, part 1")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd_alias.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -256,7 +256,6 @@ void dasd_alias_disconnect_device_from_l
 		return;
 	device->discipline->get_uid(device, &uid);
 	spin_lock_irqsave(&lcu->lock, flags);
-	list_del_init(&device->alias_list);
 	/* make sure that the workers don't use this device */
 	if (device == lcu->suc_data.device) {
 		spin_unlock_irqrestore(&lcu->lock, flags);
@@ -283,6 +282,7 @@ void dasd_alias_disconnect_device_from_l
 
 	spin_lock_irqsave(&aliastree.lock, flags);
 	spin_lock(&lcu->lock);
+	list_del_init(&device->alias_list);
 	if (list_empty(&lcu->grouplist) &&
 	    list_empty(&lcu->active_devices) &&
 	    list_empty(&lcu->inactive_devices)) {



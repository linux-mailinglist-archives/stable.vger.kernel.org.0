Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30252E6559
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393388AbgL1P7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:59:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390330AbgL1NdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:33:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B07D206ED;
        Mon, 28 Dec 2020 13:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162372;
        bh=68WcUA4SCIq5euYBlkcE9hSO8wqkCfcl9VXdHARhno0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM6qC3TjjwydAqkxrOmIxgpHkugCizcoHu00j0+uvqcAJXp9t4QjmTuI1ap4HiW12
         VdWerCTQOYpJx7iQEd461cHxm4McueSqmY+huB/Anf2yl4xrr1y/l9nr66Ew9cZAmh
         Ze0MDaQx6cu9IBGfqqiFv4AZT5AVFp1Xuc1UAUD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 282/346] s390/dasd: prevent inconsistent LCU device data
Date:   Mon, 28 Dec 2020 13:50:01 +0100
Message-Id: <20201228124933.414210607@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit a29ea01653493b94ea12bb2b89d1564a265081b6 upstream.

Prevent _lcu_update from adding a device to a pavgroup if the LCU still
requires an update. The data is not reliable any longer and in parallel
devices might have been moved on the lists already.
This might lead to list corruptions or invalid PAV grouping.
Only add devices to a pavgroup if the LCU is up to date. Additional steps
are taken by the scheduled lcu update.

Fixes: 8e09f21574ea ("[S390] dasd: add hyper PAV support to DASD device driver, part 1")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd_alias.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -511,6 +511,14 @@ static int _lcu_update(struct dasd_devic
 		return rc;
 
 	spin_lock_irqsave(&lcu->lock, flags);
+	/*
+	 * there is another update needed skip the remaining handling
+	 * the data might already be outdated
+	 * but especially do not add the device to an LCU with pending
+	 * update
+	 */
+	if (lcu->flags & NEED_UAC_UPDATE)
+		goto out;
 	lcu->pav = NO_PAV;
 	for (i = 0; i < MAX_DEVICES_PER_LCU; ++i) {
 		switch (lcu->uac->unit[i].ua_type) {
@@ -529,6 +537,7 @@ static int _lcu_update(struct dasd_devic
 				 alias_list) {
 		_add_device_to_lcu(lcu, device, refdev);
 	}
+out:
 	spin_unlock_irqrestore(&lcu->lock, flags);
 	return 0;
 }



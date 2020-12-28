Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E512E681C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbgL1NFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:05:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730569AbgL1NFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:05:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C27CD22A84;
        Mon, 28 Dec 2020 13:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160696;
        bh=M7feVJb4J5+v0RDefL6gJZZ685A7+llWtYvbk39kb8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqXTPzQu3J1fdYhPgr8vQgy/vHr+lp3zJUZP40ahe54G/XGBnRRkS6t+MCQ6Peg6l
         FuyZ/YB2Q9/1OrN/Wx3PrajiCxmdfUHd2mFhZrsHaykABKjyXzs+e4yxjQxdPg5Sk7
         FhqnhW32JQc3uN0rMYjnGylrz+SqSJDbblqS9et8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 139/175] s390/dasd: prevent inconsistent LCU device data
Date:   Mon, 28 Dec 2020 13:49:52 +0100
Message-Id: <20201228124859.981154467@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
@@ -502,6 +502,14 @@ static int _lcu_update(struct dasd_devic
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
@@ -520,6 +528,7 @@ static int _lcu_update(struct dasd_devic
 				 alias_list) {
 		_add_device_to_lcu(lcu, device, refdev);
 	}
+out:
 	spin_unlock_irqrestore(&lcu->lock, flags);
 	return 0;
 }



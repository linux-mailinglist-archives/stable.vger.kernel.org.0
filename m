Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB0A1B41BB
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgDVKzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbgDVKHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:07:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9246B20575;
        Wed, 22 Apr 2020 10:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550028;
        bh=PnmVhv6j1lYMEXCgXSgukmmBE05wXIWdHaYvJgdOp+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YT344tvQCSBSwUHkhTvGlVQwL/tWqM9qUWMS7TN4b7Lba4KWO3sSxNZ3lU0JNj3qH
         y3cE1gWACbYT7yEfj5txLd4+3j4ag5aM2jlNk9MEK1vRKqxVd3FJ5hh3alvekg3WMy
         Dd0GzXFXyCiwk7dXquiA93mLauZ8+wSF43eRqIrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lior David <qca_liord@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 098/125] wil6210: fix length check in __wmi_send
Date:   Wed, 22 Apr 2020 11:56:55 +0200
Message-Id: <20200422095048.942033072@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lior David <qca_liord@qca.qualcomm.com>

[ Upstream commit 26a6d5274865532502c682ff378ac8ebe2886238 ]

The current length check:
sizeof(cmd) + len > r->entry_size
will allow very large values of len (> U16_MAX - sizeof(cmd))
and can cause a buffer overflow. Fix the check to cover this case.
In addition, ensure the mailbox entry_size is not too small,
since this can also bypass the above check.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c |   22 +++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.c       |    2 +-
 2 files changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -356,6 +356,25 @@ static void wil_cache_mbox_regs(struct w
 	wil_mbox_ring_le2cpus(&wil->mbox_ctl.tx);
 }
 
+static bool wil_validate_mbox_regs(struct wil6210_priv *wil)
+{
+	size_t min_size = sizeof(struct wil6210_mbox_hdr) +
+		sizeof(struct wmi_cmd_hdr);
+
+	if (wil->mbox_ctl.rx.entry_size < min_size) {
+		wil_err(wil, "rx mbox entry too small (%d)\n",
+			wil->mbox_ctl.rx.entry_size);
+		return false;
+	}
+	if (wil->mbox_ctl.tx.entry_size < min_size) {
+		wil_err(wil, "tx mbox entry too small (%d)\n",
+			wil->mbox_ctl.tx.entry_size);
+		return false;
+	}
+
+	return true;
+}
+
 static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
@@ -391,7 +410,8 @@ static irqreturn_t wil6210_irq_misc(int
 	if (isr & ISR_MISC_FW_READY) {
 		wil_dbg_irq(wil, "IRQ: FW ready\n");
 		wil_cache_mbox_regs(wil);
-		set_bit(wil_status_mbox_ready, wil->status);
+		if (wil_validate_mbox_regs(wil))
+			set_bit(wil_status_mbox_ready, wil->status);
 		/**
 		 * Actual FW ready indicated by the
 		 * WMI_FW_READY_EVENTID
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -209,7 +209,7 @@ static int __wmi_send(struct wil6210_pri
 	uint retry;
 	int rc = 0;
 
-	if (sizeof(cmd) + len > r->entry_size) {
+	if (len > r->entry_size - sizeof(cmd)) {
 		wil_err(wil, "WMI size too large: %d bytes, max is %d\n",
 			(int)(sizeof(cmd) + len), r->entry_size);
 		return -ERANGE;



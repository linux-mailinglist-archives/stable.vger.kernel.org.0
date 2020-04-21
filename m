Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A0B1B267A
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgDUMl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728934AbgDUMlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:12 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB89C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:12 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u16so3491249wmc.5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y2qCj2VEWLETSdDzdg9wby0Dp4VMBOBRFzvR2ZFa7wU=;
        b=gxdfRnvbMkmyuVPAMawnyxVUxNMmFvuexXJKU1WRh33ZWZgtcX6PZdtXiCg4lZRBIH
         XJAFyhaNqdsX98wdGhl7eB7Gn/Adv4tbtqWHa2Oof6cw8HXuzg+k98smiLjVwoHHJBhn
         KPejye8XGj+h8doOcHXx/sHWHA3ywOuZoHImvflnUV/Ax1T4TQDXhbqeM07pbCmeID5v
         /hm9TJ6F3bfmMt7cf+6ldOsy9HeqJ/EX8laocxi520SOZRd8YWnZH/cVBkH8uM8wxP1y
         ygpDpiaLaMFwZKAPD7MsV1CnXp7Ztg7mgdyTmGnXENKR5OQ2OlFzDnDW0FblE6A7RVQA
         w0lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y2qCj2VEWLETSdDzdg9wby0Dp4VMBOBRFzvR2ZFa7wU=;
        b=QBvZf80XE2/R1d/cPFTw3XbPljqN76ZqSohqM1fNty4kUOb5oFthNSIdFOmBMFHvUL
         kxh66H9zEwA7MA4H81JueDHyKgYXdxxxZCF2ku8BgVpmL85cXk4dSeLZW6QRnEyI037h
         dMkfS4My6u7DbsvdWSqweY5AuCJZCPX+JPd8WNXjky2zm+WEKq4dw6LH7KIQIqACNJtZ
         h4hX/lmM7qStGvXxamJbaOQXEqGdSQrs2SqEjNB4jtYDjdHjEdvgdHeSHBQbRLyATPPZ
         X/O3VRyvtKm1wpUg3WH8KnJULatXYxiOzEo32qkr+p+5Lq7ach6MycOWyGNZpEbtOPll
         2AIw==
X-Gm-Message-State: AGi0PuYeeudLmQF8QPEWtq5x/1JxCmrdpNVwwlMhIugMNIqkQWUqC/yG
        TOsdKhYwOl4wTKtdLeagOg4D2j51Hc4=
X-Google-Smtp-Source: APiQypLyACVUnJpzIQswVVw/FLoDeZFabr/mLK8ufw4xJcVpTESApldSVgKFm5Yvf6ADcyTRdcfUhg==
X-Received: by 2002:a1c:48c:: with SMTP id 134mr4436861wme.47.1587472870366;
        Tue, 21 Apr 2020 05:41:10 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lior David <qca_liord@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 20/24] wil6210: fix length check in __wmi_send
Date:   Tue, 21 Apr 2020 13:40:13 +0100
Message-Id: <20200421124017.272694-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
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
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 22 +++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.c       |  2 +-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 59def4f3fcf3d..5cf341702dc11 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -358,6 +358,25 @@ static void wil_cache_mbox_regs(struct wil6210_priv *wil)
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
@@ -393,7 +412,8 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	if (isr & ISR_MISC_FW_READY) {
 		wil_dbg_irq(wil, "IRQ: FW ready\n");
 		wil_cache_mbox_regs(wil);
-		set_bit(wil_status_mbox_ready, wil->status);
+		if (wil_validate_mbox_regs(wil))
+			set_bit(wil_status_mbox_ready, wil->status);
 		/**
 		 * Actual FW ready indicated by the
 		 * WMI_FW_READY_EVENTID
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 6cfb820caa3ee..22bfa10ea8276 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -231,7 +231,7 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	uint retry;
 	int rc = 0;
 
-	if (sizeof(cmd) + len > r->entry_size) {
+	if (len > r->entry_size - sizeof(cmd)) {
 		wil_err(wil, "WMI size too large: %d bytes, max is %d\n",
 			(int)(sizeof(cmd) + len), r->entry_size);
 		return -ERANGE;
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB791B4316
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgDVLU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726823AbgDVLU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:27 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCDCC03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:26 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z6so1906346wml.2
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s6FBZN4nRWiUrKVfoyflfqov+eXkWkgr9+0BkVt9Xfw=;
        b=SNCDgQQSWnhbVmxsp2SUWQDXfWmKAKUCqYlH37OSG2GjCddZbx6pjZHJoR/zKwiXl3
         VXD1trZnXN5R6s/GBw2utMT16tz4hDBo42RkeoSlmKOLaURzkZDhrDkyE1KrDGZE61TE
         boV7LNASYDMOc9qzEeqpeZqKS2gNpTVkZu9avEGRaNBYfirFGMKPwguetTebXGFtz6oq
         CCFnaIFipBnJR4y6VjciTo6wi83Hx1g5OgZ+w8fMiQ/ObvVTohcrq7KL4aQhZtGDX4xU
         ONHYe2+JwGObuRXLea4Qx+IhGNjBPqzTN2YWYHW14qPpgnH+31Czse2oy3aF9EzSufbI
         jvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s6FBZN4nRWiUrKVfoyflfqov+eXkWkgr9+0BkVt9Xfw=;
        b=DCFNbovNbpz9MTdc0kolvUp1pNtZ2WDsuM+H4o3zL4bwnKyULgaSVyoLZthYSkxJBL
         pwkbtVpuMbb2qe6N/LaUnkrTpLQpZLDq/RXF6B9ftngzBcaBwYG3rxy441R8NMxQlOXA
         Q1jUfryqd4b/1rp7pYe4Npgu8lW6OEAJk5936qstiphPcR7oDF5M1JMpI2kGolu9RYm1
         XwpFWLI7bD4ZPcagoB5hVMuhLQCdN328HhvOCFkP5+WG8mobF/cCnq8U5Kl53OtO4BnC
         Fh9FFheIhErB/eRnF+knmFPCVEAXFmmYLt3QFqVKyXfnbobrgEgMNNIqFnKGrg8GDgeQ
         Q1dg==
X-Gm-Message-State: AGi0PuYUuGz8zuQqH70a0pDzrZEbmCpfnMqjLU+4HCNkjk2/n9hJelYZ
        2SsWrhEZqzKFxzUOtk2uaD2aF6NzQI4=
X-Google-Smtp-Source: APiQypJiSNueVF1MFbf9oF7n6fiH7FXvVDeBnyk0r3WiMSTOjnA198jAg/NPHqXAwKi26uiQgCHqUQ==
X-Received: by 2002:a1c:c2d4:: with SMTP id s203mr10752049wmf.128.1587554424942;
        Wed, 22 Apr 2020 04:20:24 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:23 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lior David <qca_liord@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 17/21] wil6210: fix length check in __wmi_send
Date:   Wed, 22 Apr 2020 12:19:53 +0100
Message-Id: <20200422111957.569589-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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
index 64046e0bd0a22..a37533cffc7ca 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -356,6 +356,25 @@ static void wil_cache_mbox_regs(struct wil6210_priv *wil)
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
@@ -391,7 +410,8 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
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
index 61419d1b45435..3f6ac1ca0e575 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -209,7 +209,7 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	uint retry;
 	int rc = 0;
 
-	if (sizeof(cmd) + len > r->entry_size) {
+	if (len > r->entry_size - sizeof(cmd)) {
 		wil_err(wil, "WMI size too large: %d bytes, max is %d\n",
 			(int)(sizeof(cmd) + len), r->entry_size);
 		return -ERANGE;
-- 
2.25.1


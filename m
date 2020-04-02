Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5E919C9A2
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388755AbgDBTN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35661 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388989AbgDBTN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id i19so4966954wmb.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Y2qCj2VEWLETSdDzdg9wby0Dp4VMBOBRFzvR2ZFa7wU=;
        b=dD3OE0esu/95ovhOagcBwUvDSUGgoSBMXKkWo6htsYmA3QuO3MJC/Ps0qQZJdo1mtu
         E/9eRZ+260YNvcqTfBd1uswl6eiV5hjDvWcxqrwfdQFw7RCTY7GUYLH1Ho8U8egR2K/G
         hg7AqEM5/6xvCcfyG65aEYQTa18bFD+FIhEFKmrIfOgqNF5drD4y9sDkIKTp6k2+8AkC
         t8fiUcG8Bwf1EQJixSHXvltwuFbQwNI2zZ3VNi+UxCklM2WJKtKW+tF0etoUmaW39gQJ
         mqx5ORra8J0La67cDQ79bjDILLrxu7evBx4aaGNWDRRZMyenGUYW1OwFME8MsDjh7R4L
         kWHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y2qCj2VEWLETSdDzdg9wby0Dp4VMBOBRFzvR2ZFa7wU=;
        b=p5mfQ0e7pE1fWKAAG5VW2nXAfeECCsUFy/5rJRqLHE/i4e5kcv0hK0xKoYrLoZRZLe
         MAQpZPGtjnqLGpW65O1eOGgayQYEN7BoZ5ZKaIgPaZWYbIe44AyyJew7qn08EMkv+eSZ
         z6W/qb0pKv09pyfjiIq9csKnu+aPYkKV6bmq7cJDw36JWHBLe0BW2M0VR7tcYYsyL+9R
         Cegh4Y9VBRY4zU8cg6UAwzfMJ0LJ04TVjZGbSy0kc21qdwZBA/mvh+cQpv53ecrMm9gi
         EugeVzJM127KvQNidcb77VP72av/YOxKtrHc2wbJVig5td5CeAK84t7ufNEhUdaEWWYj
         +E+w==
X-Gm-Message-State: AGi0PuZ2f5jqTYfnZJprCxACfqeDCQ1AqcuPju/Mh2MlA3ehE+fBEBUn
        9zjWBuJcbv9QLXJcnPQ8FZzWxDU7B6Ndnw==
X-Google-Smtp-Source: APiQypLUn7kfPaneJCpsv70ZRjgNZmx/mgCFaH0kVew5fkS1fn0d8AHNe9KNly2h3OIrJDCFGY0IEA==
X-Received: by 2002:a7b:c8cd:: with SMTP id f13mr4884104wml.138.1585854805277;
        Thu, 02 Apr 2020 12:13:25 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:24 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 26/33] wil6210: fix length check in __wmi_send
Date:   Thu,  2 Apr 2020 20:13:46 +0100
Message-Id: <20200402191353.787836-26-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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


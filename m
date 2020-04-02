Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286DD19C9C3
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388921AbgDBTRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33602 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389006AbgDBTRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id a25so5654145wrd.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=s6FBZN4nRWiUrKVfoyflfqov+eXkWkgr9+0BkVt9Xfw=;
        b=YsgSmnBqLLCxi/nTyjiE2C4dYnXY4JmecfKAUg7aQGQ+hxgr82mbLs+fbbLybgTPxb
         uVCvbcQvBhMiiLjTcHCr6kn1ENUK/6VYa0GqP1DYeyOQ6mJO7locAJ2wrd997OwiFn9C
         9fFHzZt+WhW5Js2Cf+6k/KSE24ots3GljPaXSrNVMmLXi2caEcyXe78ws7l22ioAbWoA
         lEBSY/EqcTNt312JYb0rXnqCEEYTbZDDpToEqQksTTyU98IdhuZ1GL6+O4Kzk4Z+ntlQ
         5yFIMB2ANNu9KB+X786nlpLt5D79KVn24dGKRalPbLrNac6yeu31jfQpV2cWLX7ctRl5
         34nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s6FBZN4nRWiUrKVfoyflfqov+eXkWkgr9+0BkVt9Xfw=;
        b=tSkzBUN7tN0NyQsAKX1bjB/t8H0rdtNc6I+vNMfMxMH3vOM8Osc3Pf5sM+YG7S/j99
         3Cv9CxvMnhO/N7+dexvg+J31i1FEw9gZDmcI1dk+TOsGTBYHSHdGKLiqJWYwZq1zaadJ
         KJ4Ugqy+PEAqcYzzOsi2y4fXylcd5bIdyt/3NNrzHmqM7xWxBNecuGbyaUf96fA3HK+T
         YVuh5jn4wFLvi2NDEJScOVlmzPiHWJzTgbLnurTfqXKMzkJ30HjDR3Q0cXnmOB9X2lZ1
         9bjaUt6pbyafxOuUpd/oKzeGW4fZ/WjgWCiQd4m8dPxNp04N8YjBYTIV57MODL6skcoa
         N9Cg==
X-Gm-Message-State: AGi0PuaHdODr/kbAtCLs6Lh0WjuT5uyDp2BUUjQ4s3Mpov5188QlIjSn
        Q7tHquN/wo5bLfB+Ji0OTm8wyRPWgiuvhg==
X-Google-Smtp-Source: APiQypJgd75wT7eQO6kk3CykXOJOCT33FRlFAXWrO5amIQ8ZBeOjxvbpUTd6z1D+/sOB5xurUV9KeA==
X-Received: by 2002:a5d:630b:: with SMTP id i11mr4732881wru.94.1585855032082;
        Thu, 02 Apr 2020 12:17:12 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 18/24] wil6210: fix length check in __wmi_send
Date:   Thu,  2 Apr 2020 20:17:41 +0100
Message-Id: <20200402191747.789097-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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


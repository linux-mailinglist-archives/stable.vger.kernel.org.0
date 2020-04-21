Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723321B2665
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgDUMlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728899AbgDUMk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:40:58 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ADAC061A41
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:58 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v4so2437496wme.1
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D1qqE7A+oH64Ry/wyerr3JPc4eLEauhFijFSbfrVnb0=;
        b=GbpiXnfKz53JBMmUyc/D5ljAXLmX/B8de60yB5shRISEC1j6T1ASKoWZVz13gkMMVb
         QSBaNEebqFl5b5/lIo+N7CIwCoEL3a5ygT4FBZ+kpvxijE7/x1Bq2BERbK+SqTW0fMvJ
         XWwiq82zh3uyGHUYzYCcMSfxsIT3s2jfkgBu3Yc5HqcelzxvAZ0lvPwZg0o9dASFnhds
         uUmsojNL0hVtFRUJLsAPjGiN/qq96BmVEJSM2KxhfmxZINfn4uW88WV7oMH8wecgaS5C
         YpNUQkFZeWUaNM1ynXxoG6oKiX0ia4EzXg/lYAOjTzPbQBjwaI7yGsZ9EkL+1z2FiZQD
         5I5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D1qqE7A+oH64Ry/wyerr3JPc4eLEauhFijFSbfrVnb0=;
        b=fOr1WnNJhpTpQEKpsrBIblcT8GxzRgGs6rnYvRFnHj+2p1ORE5L3lQ61aEQcKYHTbt
         5n0WbMa9W090A2+m/UzXUijEzobzUbLr4sno51/TgYBCUn0XaT+4QFE5wfHwFlS+73+5
         i3SNz3CvTEYtl6qThcxNTNtdVR3fmT0jKdX8/i3qLrO8RLXmiBZ/q5xnTscQAr+xv1pt
         Wqb3+v2y0s0MC4+Y/65uS4R2QMTZMPOV6DnHaSePKZ0rmk2FursYiqetP/lDdrY43PrO
         VojpR+MNfDnL5DI/ZEyPlWrBfpwtIkugKDIDMZiFYQ34WpBwMiD8m2oj3TwrQ2S6k5cl
         wuzg==
X-Gm-Message-State: AGi0PuZ4X1wRWZYoR1Kgm+wzlZE7pg23SQVJLm0Eoasl3W9AASMiI+eu
        zSpW1GnLYBa9GxLObUPRUkZQlmNFdnc=
X-Google-Smtp-Source: APiQypJk9DcplRKoo7qnbk98r/waMpYrW72ZcbleNr/EEw7oInnfybIkOGpDFtiK4Jcy4tWpLbOjXg==
X-Received: by 2002:a7b:cf2b:: with SMTP id m11mr4432860wmg.147.1587472857141;
        Tue, 21 Apr 2020 05:40:57 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:56 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 09/24] wil6210: fix temperature debugfs
Date:   Tue, 21 Apr 2020 13:40:02 +0100
Message-Id: <20200421124017.272694-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit 6d9eb7ebae3d7e951bc0999235ae7028eb4cae4f ]

For negative temperatures, "temp" debugfs is showing wrong values.
Use signed types so proper calculations is done for sub zero
temperatures.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 6db00c167d2e1..3a98f75c5d7e5 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1093,7 +1093,7 @@ static const struct file_operations fops_ssid = {
 };
 
 /*---------temp------------*/
-static void print_temp(struct seq_file *s, const char *prefix, u32 t)
+static void print_temp(struct seq_file *s, const char *prefix, s32 t)
 {
 	switch (t) {
 	case 0:
@@ -1101,7 +1101,8 @@ static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 		seq_printf(s, "%s N/A\n", prefix);
 	break;
 	default:
-		seq_printf(s, "%s %d.%03d\n", prefix, t / 1000, t % 1000);
+		seq_printf(s, "%s %s%d.%03d\n", prefix, (t < 0 ? "-" : ""),
+			   abs(t / 1000), abs(t % 1000));
 		break;
 	}
 }
@@ -1109,7 +1110,7 @@ static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 static int wil_temp_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
-	u32 t_m, t_r;
+	s32 t_m, t_r;
 	int rc = wmi_get_temperature(wil, &t_m, &t_r);
 
 	if (rc) {
-- 
2.25.1


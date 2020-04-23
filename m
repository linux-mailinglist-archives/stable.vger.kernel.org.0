Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A291B659F
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgDWUkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:32 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86FEC09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:31 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g13so8229951wrb.8
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=delpOehTXvAM9GwDPbw2EyVrij8m0ovO9xyQACi08O8=;
        b=aLmDxN/hXIV7G6SvHXKQCDrGwfTuKVxvNoH1VMxkQNTS8pcjkaCbCvL6FImSJcaoeF
         t2Hyw2boNoyBwEurpoZbAn+zeawcooaUZulbBxAiXtr4a0GnZZWE1iIAZpK0eehjma1+
         vnwttLuB+Te+Tyjh4SzBL6KbrSI53H315KzD1/3q+jzbmy8gWNeP3C8LilyoV9dPS232
         E47Ue0Dw/mq5Agg13ABZoXSbrihB2EmYduuAUtugCBtjd3WJE01eftpJP3elLjaejPtK
         gXIv63hl66zYf8E5gMtqCfAyB/GJ14qjtqUH+K8Mrkxq96zuxoRs7HdPzZuZFcxhg7I5
         Lfuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=delpOehTXvAM9GwDPbw2EyVrij8m0ovO9xyQACi08O8=;
        b=DLUhIOAZny595lRTiUI3OMOjzuc44GddABMH0yDHmB8JrBBuDNVlOEaz+rPJiL4Czd
         VtPONMDtSs9s4gpSXEkVAhQLCXdR59+KOB+qkS8feSAnrVT4SPjpz7TVPhrVvG9WPpKy
         SP2mnQkcVPU1BTq1ILS9+L7g+UnPIBlKlujYsaLTg+fB8M1jDmvcn6EPZscyzXBi4U8V
         2gFHeiq+pUhhGzByeq3DQUhb7S7ECBzHYoK2VWN/+p9tDt81k1XDcMUcE3jBrnLrscsl
         ICf6ajvwj7WhRXNP51qizZALzoITuxWm0BHEODResofXmgilfuuQ3k6zBkK7LQrvsfXM
         sLUQ==
X-Gm-Message-State: AGi0PuYxPG3nR1Vd8XlMlCs+80084pX/PDitrGD7Sl48v3ETfIKGECST
        Whcd+zZV1S5gEOWJwfbxeba0JDkekX8=
X-Google-Smtp-Source: APiQypJBhErUReI2kdjqh9f0wR+CgEI+6t9O043HdAN2FTwzPHcwz30dEWYMeAybIbZAAtb3ktsVxA==
X-Received: by 2002:adf:fecd:: with SMTP id q13mr7376811wrs.12.1587674430156;
        Thu, 23 Apr 2020 13:40:30 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:29 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 10/16] wil6210: fix temperature debugfs
Date:   Thu, 23 Apr 2020 21:40:08 +0100
Message-Id: <20200423204014.784944-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
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
index 97bc186f97282..2da03d69ed42e 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1088,7 +1088,7 @@ static const struct file_operations fops_ssid = {
 };
 
 /*---------temp------------*/
-static void print_temp(struct seq_file *s, const char *prefix, u32 t)
+static void print_temp(struct seq_file *s, const char *prefix, s32 t)
 {
 	switch (t) {
 	case 0:
@@ -1096,7 +1096,8 @@ static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 		seq_printf(s, "%s N/A\n", prefix);
 	break;
 	default:
-		seq_printf(s, "%s %d.%03d\n", prefix, t / 1000, t % 1000);
+		seq_printf(s, "%s %s%d.%03d\n", prefix, (t < 0 ? "-" : ""),
+			   abs(t / 1000), abs(t % 1000));
 		break;
 	}
 }
@@ -1104,7 +1105,7 @@ static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 static int wil_temp_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
-	u32 t_m, t_r;
+	s32 t_m, t_r;
 	int rc = wmi_get_temperature(wil, &t_m, &t_r);
 
 	if (rc) {
-- 
2.25.1


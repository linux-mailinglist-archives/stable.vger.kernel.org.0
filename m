Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D35219C9BD
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388888AbgDBTRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40273 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388761AbgDBTRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id a81so4925643wmf.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oWWMrX1if+NURhdB8TkNNjFtRd1Em0TKkYZf+SndQ1w=;
        b=bqgbNdESxnuadHy6kJlQhm3UQnQ5KuF7J/hjdu4VxYxM403j6Rf5v3cxo7i6k3tLFW
         UmOG2tma7GfibGj0z4tbRNvt2TYIhgChh6XgCtB8DKBUPZxSXVUXo6hWD/RkDZ7u5Z29
         zhnHqepFxd0chBUFIXKxoR4pl2Jdl8CoXmc4tBYsYJfRNotbZuDtpjCOkXNJpMPPijF3
         9ut9kKQMZOv6S6GLjhdz6EEEHVtEurzNHrQwG0fwAOp6elDnKGka42WGtzZdrkxkJoNm
         u77g2Rd4QfKmK1PITgmc9t63TM2FffcgDZivJ5UX4JPjWT8SaFMmxkbidwOaIt1b5w/J
         4SbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oWWMrX1if+NURhdB8TkNNjFtRd1Em0TKkYZf+SndQ1w=;
        b=i6aGqlIiUwfoFMqmUOWcFyzyird/tahx21D0DOUXtgJgbZJ8GIAfBhsx9PFKw1pYL+
         CfJ4cRM5yRut5yvo0eDsLmv8N62jZ87lue4ObUD004zM7HLFv1cvd7DXBzIZXZ9AT9YT
         Nw6s4g5cdif7J/LZOfla0Y8dnPvBJEvWuFUVTx0tGzmH9WpE2XBf2Q7Wi23KEWBOmTTG
         1XJsA7iHvWEUVgHgJrO7ctHbjflYfblRk5DYUBjp28jqcOKkSKYD/VeemO8BpQuexYCw
         ng29YNmtfIGgNMLukLzDaZ0QA6h6gxmM9FEy05cDmI34LCMj1kHtkZy8EfHQyQFsSLCN
         qmpg==
X-Gm-Message-State: AGi0Pubwk+0Li7SsnF4S+WqWSzWGm+JFI4aVpFX2rP2PTh1h8/8XCtQx
        K9kyyEDzQc79VnsUpJ4tqdVyLwW1I8LDdA==
X-Google-Smtp-Source: APiQypLB4CG8AXMGDRdNztZ5yFt5bfI01cvpasIkny2eGlO3pmBUpJp+YUjZWKIQ188yrOiZKwkZxQ==
X-Received: by 2002:a1c:1d93:: with SMTP id d141mr5051102wmd.134.1585855027180;
        Thu, 02 Apr 2020 12:17:07 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 13/24] wil6210: fix temperature debugfs
Date:   Thu,  2 Apr 2020 20:17:36 +0100
Message-Id: <20200402191747.789097-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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
index 8c9c06fb6d655..53e8f0be3df10 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1065,7 +1065,7 @@ static const struct file_operations fops_ssid = {
 };
 
 /*---------temp------------*/
-static void print_temp(struct seq_file *s, const char *prefix, u32 t)
+static void print_temp(struct seq_file *s, const char *prefix, s32 t)
 {
 	switch (t) {
 	case 0:
@@ -1073,7 +1073,8 @@ static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 		seq_printf(s, "%s N/A\n", prefix);
 	break;
 	default:
-		seq_printf(s, "%s %d.%03d\n", prefix, t / 1000, t % 1000);
+		seq_printf(s, "%s %s%d.%03d\n", prefix, (t < 0 ? "-" : ""),
+			   abs(t / 1000), abs(t % 1000));
 		break;
 	}
 }
@@ -1081,7 +1082,7 @@ static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 static int wil_temp_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
-	u32 t_m, t_r;
+	s32 t_m, t_r;
 	int rc = wmi_get_temperature(wil, &t_m, &t_r);
 
 	if (rc) {
-- 
2.25.1


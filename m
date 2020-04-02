Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF25519C9DE
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389476AbgDBTST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53560 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389486AbgDBTST (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id d77so4652320wmd.3
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=delpOehTXvAM9GwDPbw2EyVrij8m0ovO9xyQACi08O8=;
        b=S1vnch1qnoOCQTNJLV7KkzNn6KqhjurNHpFMZ/ljGB8TlCVDnDaNMi/8rkPhhf2n8i
         7eQhZzauahlvEJ3HAzsSRTcakQw6tvpT1pMWREXhj/E32XaJJky28ncV1uZ1c44sOQkR
         A3P+7JXoaIIpTb8g5sYja9G9F+MZtRjF5BEdANXQbZKLAZzcXBPzWV2VaaUsWUcnd92i
         u0VxYX4U3cCOVOyMMYXS1+lg2aVrfnThNwckDDtlnpuPmYEQHlvtKr28i3Dls6+ToaEN
         jcfBCm7baIvLd8pveWgq12bv0woRAEpY/4clhWGODDSRWZotJgxGjxAZXzwJN+cqoIlN
         PFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=delpOehTXvAM9GwDPbw2EyVrij8m0ovO9xyQACi08O8=;
        b=BxtK1Rntkg9cXfI/13Bs5iyp+stE5EaDNreKjwaOvsKVdj4bbideuyH5111EYBQQIq
         xLRbdDQUTHkPknXa0ClWyb95hzfm/JlBD97Rjf29/KGFBurrtNudIN9W+oOip5WTm0xs
         QZKO6wTaGV2JiSSublAMxQiUan4Yr9/+t7d2+guLFzKGsZWWHAgloaz7RqvRDQuBS1oE
         jVB9hEP4CIOXwgwPyqAEUmfUJgHIRZT09VIuaLaAmZRdEK2rPAoFFdbeKhyRNsG4myQN
         Kl6A7BxhwBoEIzCWrK5HHmTwG50ClcJVS+8B5QjdUI+BcRx5tWRMclbZsr93jz1DsMxU
         cW6g==
X-Gm-Message-State: AGi0PuYbRnMsdV4f9aPIwsNHJWSUGJdCQs9POxtCm2Z7ugoWgpYS+f+3
        vB1gfjGU7UaUQaWaq1Q2fpAuHSbVCzdsjA==
X-Google-Smtp-Source: APiQypKrU8seav4wDe1fHeSkl8epicNNtN64zhBb4LJDY0M0+fVrVIWHzUYmZuxwoNB1Y/yloAoHsw==
X-Received: by 2002:a7b:c145:: with SMTP id z5mr4838930wmi.55.1585855094593;
        Thu, 02 Apr 2020 12:18:14 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 12/20] wil6210: fix temperature debugfs
Date:   Thu,  2 Apr 2020 20:18:48 +0100
Message-Id: <20200402191856.789622-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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


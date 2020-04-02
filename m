Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522AE19C995
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389221AbgDBTNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36567 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388766AbgDBTNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id 31so5589270wrs.3
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EneAjLqhF4TNYKrJoTKfNAQVJz06xC3w0ySPcAKaU6Y=;
        b=sMZZg7BXMwGQQxYRCa4ES1mC7Bqv3BLzsOuQJ8lY9n2nAsBwhOdn18ZiXfe+CQq0/5
         Od7KBdOAFionfMM1ceCzkNNb2ZDVApqnn/VyyZPMNKi/2VDGoMzyus1lzuiWj1gSaQuX
         /NTRs5b0Ao5/1bItdO6OhCM4ExCXhNZuDdSERcE81cRd0RQrje0SijujASJvi8WJo/Bo
         4aJIamz22xGF3r6QjBr2kPF0Eyxn9hMfe3Gvug1G3t9AnOw8om0271rUPi5n240DU2QK
         w2P95tPcftkZaDUmoMJjKbJWvrGwjQnz0f5IdNa2q/jPZfz1FU9UsFAkZ1A8WB2fGW3o
         NPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EneAjLqhF4TNYKrJoTKfNAQVJz06xC3w0ySPcAKaU6Y=;
        b=uS+dxdo7ffsCPcGStdA62X09TT2DiWvHaPBazU7R9ltXeNrXhq3aTNlgmCxyirBQGx
         nX2rRbE6wFmOizmEtuE03jrL56AkVEQ0w6y4IyCZoDBkVUTeG1bkUGHxBnnaD0fqU57k
         Al0ySE7YTIS9ofn8lIF6GxcA0zbsyihdqFOSWLv6Emna3WdOeTgdu30XUf/zWC677PHQ
         mA0naIBhZ34Lqot417+pmuW08qpkWGBxZCrnu49m3HqO/ixqSYvv+GH1Pmp0NGXbUdHc
         MaECytQMAqTAs3/haat25eNdWp9+k/KOh3E/rA/6HXKtgKIlwulfr/0g49wyhCpxqzlt
         DI0w==
X-Gm-Message-State: AGi0PuZkF7RGC4IsTDHR3aiaSuGQfQafGhKBJv3GO4EPhdtv0+Dn7fMd
        eHT0k3rXA2Rfpy9BOQjfB42xeqNwnEy+pw==
X-Google-Smtp-Source: APiQypLtEqYvnjMx3uurnHTYL+6Eg+FQibNJWg73CDOtIfbbulx0y1zU77xRvMRusEZ1IFv/lDbFKg==
X-Received: by 2002:a5d:6a10:: with SMTP id m16mr5295222wru.371.1585854794168;
        Thu, 02 Apr 2020 12:13:14 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 15/33] wil6210: fix temperature debugfs
Date:   Thu,  2 Apr 2020 20:13:35 +0100
Message-Id: <20200402191353.787836-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index b17ecf796ed83..feb2701280139 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1067,7 +1067,7 @@ static const struct file_operations fops_ssid = {
 };
 
 /*---------temp------------*/
-static void print_temp(struct seq_file *s, const char *prefix, u32 t)
+static void print_temp(struct seq_file *s, const char *prefix, s32 t)
 {
 	switch (t) {
 	case 0:
@@ -1075,7 +1075,8 @@ static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 		seq_printf(s, "%s N/A\n", prefix);
 	break;
 	default:
-		seq_printf(s, "%s %d.%03d\n", prefix, t / 1000, t % 1000);
+		seq_printf(s, "%s %s%d.%03d\n", prefix, (t < 0 ? "-" : ""),
+			   abs(t / 1000), abs(t % 1000));
 		break;
 	}
 }
@@ -1083,7 +1084,7 @@ static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 static int wil_temp_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
-	u32 t_m, t_r;
+	s32 t_m, t_r;
 	int rc = wmi_get_temperature(wil, &t_m, &t_r);
 
 	if (rc) {
-- 
2.25.1


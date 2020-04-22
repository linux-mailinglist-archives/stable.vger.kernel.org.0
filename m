Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D721B4311
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgDVLUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726809AbgDVLUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:20 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F757C03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:19 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v8so4686834wma.0
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PpcmeGdWNI4ornrMuCKudszDHgNS2rU7D1DMSdTzSgE=;
        b=kr++/O2LOici1tpmKljgDMq/oP+7AXJnxQ5bXu50oJzI1LYFh8iHPdw+kPQXJjvRSv
         dYCXcK5lkLbU+sDb2dftRweUdyE6ywa6twj0DNzKuYm34G78H1izQNYjrAa7oWhen6PK
         Rw2tve10jkX5q8L8JVmBm13l/oPUXovP4E/5HQioMC9GZuqbfrjAz5PnJ4BEH76Yfaan
         2O60D6+mZoM9el/YNbYS/+gC0oC6I/3kzWv83DjUc6TbXZt1zWabsCSXaqIM/6932vAK
         bdXfDOU/+DCUWdUdz4HEzIefIYEyGXCVnFZpDOUcn5nsJW7fGggz3LV6Y7b15I36RaMH
         geFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PpcmeGdWNI4ornrMuCKudszDHgNS2rU7D1DMSdTzSgE=;
        b=dDUPMFTh7vJ86kPhjf1Gv89RwjkMZrdwja9q+9ZY3RmNSj0gshMBzZ9SAxxRFyyC4Z
         y76TYEwpi1cX89xOydTojZXhj107IFGudCwuBZuTMMxhr2mRKN7mW1W1MfOHfpk6BJu/
         9QqVJ7gKxElePL6gqcfVkr6LlSQKrswwDsDUODuoAeHEMeawfVoE4LEj65Xcms6P5D92
         /VQSerIQAl0/u3bVASM6SAkluEfm5DWb+qMvrLfjVIpGkXJ7rvqyBiWJ+IhSDV2fJ9nk
         xieSBTODFExWaSI99qtAfRmoqw4U5jsOW/rZpwNPdRGwJXBqQhTRcl7ZSi5AV4VnvTO7
         Bmfw==
X-Gm-Message-State: AGi0PubBq9ejiFyqQ8TLBzHJSzvRLm8vug2e82y+x+HxlI/XOz4WdWBc
        QX/M4bpbv9M9cktGhnGURNb6PK31JfI=
X-Google-Smtp-Source: APiQypJ5aNVAm2XCh0AJ2MurIfW92s2wLTTqV2lZULbdl4WRARRG6rrLWhr78zqORrGNmjbNn+Il+w==
X-Received: by 2002:a7b:cf1a:: with SMTP id l26mr10635681wmg.114.1587554417694;
        Wed, 22 Apr 2020 04:20:17 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:17 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 12/21] wil6210: fix temperature debugfs
Date:   Wed, 22 Apr 2020 12:19:48 +0100
Message-Id: <20200422111957.569589-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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
index 5e4058a4037b4..cbf3958d788a5 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1091,7 +1091,7 @@ static const struct file_operations fops_ssid = {
 };
 
 /*---------temp------------*/
-static void print_temp(struct seq_file *s, const char *prefix, u32 t)
+static void print_temp(struct seq_file *s, const char *prefix, s32 t)
 {
 	switch (t) {
 	case 0:
@@ -1099,7 +1099,8 @@ static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 		seq_printf(s, "%s N/A\n", prefix);
 	break;
 	default:
-		seq_printf(s, "%s %d.%03d\n", prefix, t / 1000, t % 1000);
+		seq_printf(s, "%s %s%d.%03d\n", prefix, (t < 0 ? "-" : ""),
+			   abs(t / 1000), abs(t % 1000));
 		break;
 	}
 }
@@ -1107,7 +1108,7 @@ static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 static int wil_temp_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
-	u32 t_m, t_r;
+	s32 t_m, t_r;
 	int rc = wmi_get_temperature(wil, &t_m, &t_r);
 
 	if (rc) {
-- 
2.25.1


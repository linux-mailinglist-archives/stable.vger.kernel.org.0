Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417E01B430C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgDVLUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726800AbgDVLUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:11 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C15CC03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:10 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b11so1927475wrs.6
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8n9PuhMajM7WvWxCjQiwhBj7Uis5bjcy3z0jj02FBf0=;
        b=T4TLDFutcKcIWxoI/pe9XCT6RI9eNVXxzjof0u6YOv64fwFhpg5B2mkOTmVQEwR1Dl
         qB8Kg08/GhG9Ba/HlkmejLbm2Rgb1BWfRvBwV5pVP6DCAH9wll6Bl2tv5JWniZBJeB2o
         vMe83Rd6Gk0qUR+mFgxLKCJR7fcOom9mF/nRwRH6hecTSHDfHOpEe4sXwoFg8rxiHopt
         u82hnhHf4ZqBL31OvYn76AnAhv1DGIfjJpRtKx8kM0s7Oi81WdFOEmqYiCIJBBAHO8mB
         jzgBt4tycUjTtG2lZZoG3kjBdNalJ5VgDZnC7xYOCPr9vf7OCCJDrbDfcZSqa5hQZQ0b
         IhDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8n9PuhMajM7WvWxCjQiwhBj7Uis5bjcy3z0jj02FBf0=;
        b=BwAb0hw6g+9nxccJPt91Brv3qrgksHUOkjSZCaKzofq6J9OJmGdxPm+bNNSUgguCKy
         +9zbi3GBDggaP/qrxNKLN9xE1Tvc+/JQzqbJCevFAE5qphrlKuv+tNZbG6OsZLwZ0ORq
         0kWMAY4tENxdzl1D7ItAvoJgtWoZO2C+811+XKoCmUVMgvZRXkFxkZR7TPpQrwNHBI4m
         tem6ABiLRuLnPvBsccOQo9CNk+UPrIWMDhdV3L7sYx361AZJNazezI/k6XYDB6tKo/kN
         2ezWM3Uz+om3Tr17zORrHrEplkbUX6iwy3x3P/F7Wbxgjzu3Xw9AIJlu8XPFA/Mj+7hi
         yT+g==
X-Gm-Message-State: AGi0PuZnyVjtykEws85kZdHh4X4QXRhpeNU/GdvbPJZZ0cQVJsJvj263
        /7wdk51KNbly6lNQlh1mNum6QqPm4ng=
X-Google-Smtp-Source: APiQypIgmtw7cb+RCVR30gnMgjPn31vaEiWhOMVck5/x6U5NWZB3IjrE612fCiSHXWlFXZ6wJv/G0w==
X-Received: by 2002:adf:a309:: with SMTP id c9mr27331084wrb.97.1587554408694;
        Wed, 22 Apr 2020 04:20:08 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 07/21] clk: Fix debugfs_create_*() usage
Date:   Wed, 22 Apr 2020 12:19:43 +0100
Message-Id: <20200422111957.569589-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 4c8326d5ebb0de3191e98980c80ab644026728d0 ]

When exposing data access through debugfs, the correct
debugfs_create_*() functions must be used, matching the data
types.

Remove all casts from data pointers passed to debugfs_create_*()
functions, as such casts prevent the compiler from flagging bugs.

clk_core.rate and .accuracy are "unsigned long", hence casting
their addresses to "u32 *" exposed the wrong halves on big-endian
64-bit systems. Fix this by using debugfs_create_ulong() instead.

Octal permissions are preferred, as they are easier to read than
symbolic permissions. Hence replace "S_IRUGO" by "0444"
throughout.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
[sboyd@codeaurora.org: Squash the octal change in too]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/clk.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index af4f2ffc4fc50..b901bea814b6d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2145,18 +2145,16 @@ static int clk_debug_create_one(struct clk_core *core, struct dentry *pdentry)
 
 	core->dentry = d;
 
-	d = debugfs_create_u32("clk_rate", S_IRUGO, core->dentry,
-			(u32 *)&core->rate);
+	d = debugfs_create_ulong("clk_rate", 0444, core->dentry, &core->rate);
 	if (!d)
 		goto err_out;
 
-	d = debugfs_create_u32("clk_accuracy", S_IRUGO, core->dentry,
-			(u32 *)&core->accuracy);
+	d = debugfs_create_ulong("clk_accuracy", 0444, core->dentry,
+				 &core->accuracy);
 	if (!d)
 		goto err_out;
 
-	d = debugfs_create_u32("clk_phase", S_IRUGO, core->dentry,
-			(u32 *)&core->phase);
+	d = debugfs_create_u32("clk_phase", 0444, core->dentry, &core->phase);
 	if (!d)
 		goto err_out;
 
@@ -2165,18 +2163,18 @@ static int clk_debug_create_one(struct clk_core *core, struct dentry *pdentry)
 	if (!d)
 		goto err_out;
 
-	d = debugfs_create_u32("clk_prepare_count", S_IRUGO, core->dentry,
-			(u32 *)&core->prepare_count);
+	d = debugfs_create_u32("clk_prepare_count", 0444, core->dentry,
+			       &core->prepare_count);
 	if (!d)
 		goto err_out;
 
-	d = debugfs_create_u32("clk_enable_count", S_IRUGO, core->dentry,
-			(u32 *)&core->enable_count);
+	d = debugfs_create_u32("clk_enable_count", 0444, core->dentry,
+			       &core->enable_count);
 	if (!d)
 		goto err_out;
 
-	d = debugfs_create_u32("clk_notifier_count", S_IRUGO, core->dentry,
-			(u32 *)&core->notifier_count);
+	d = debugfs_create_u32("clk_notifier_count", 0444, core->dentry,
+			       &core->notifier_count);
 	if (!d)
 		goto err_out;
 
@@ -2270,22 +2268,22 @@ static int __init clk_debug_init(void)
 	if (!rootdir)
 		return -ENOMEM;
 
-	d = debugfs_create_file("clk_summary", S_IRUGO, rootdir, &all_lists,
+	d = debugfs_create_file("clk_summary", 0444, rootdir, &all_lists,
 				&clk_summary_fops);
 	if (!d)
 		return -ENOMEM;
 
-	d = debugfs_create_file("clk_dump", S_IRUGO, rootdir, &all_lists,
+	d = debugfs_create_file("clk_dump", 0444, rootdir, &all_lists,
 				&clk_dump_fops);
 	if (!d)
 		return -ENOMEM;
 
-	d = debugfs_create_file("clk_orphan_summary", S_IRUGO, rootdir,
+	d = debugfs_create_file("clk_orphan_summary", 0444, rootdir,
 				&orphan_list, &clk_summary_fops);
 	if (!d)
 		return -ENOMEM;
 
-	d = debugfs_create_file("clk_orphan_dump", S_IRUGO, rootdir,
+	d = debugfs_create_file("clk_orphan_dump", 0444, rootdir,
 				&orphan_list, &clk_dump_fops);
 	if (!d)
 		return -ENOMEM;
-- 
2.25.1


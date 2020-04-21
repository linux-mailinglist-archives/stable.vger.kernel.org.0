Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8DC1B2654
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgDUMku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728873AbgDUMks (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:40:48 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DAEC061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:48 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j2so16275685wrs.9
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MfNuHxEjbU0bCTmDk+zE6vZTzkddZEYuAf50sMJGKgg=;
        b=KnHJ0YQYMNBZFko1rb/NrMNY3vNw1ReG2jzEkGiVwQ+cOoP0/8zasnEnCqiIm4lVj5
         JMupVup4Q8d6d49tgw1t+QxZ+hpiMlgiqa8t5+WgcIX0JPRx3qU6tVg796Cla4/KnGA5
         fuE202SlRULVKyFtusyN3657+Ck5WZi3O0KV82PMKXyJgpqxvoogNgvtL4GQW/QMo2l+
         ppK3hyfhcVPWfhYNN8RnT6ZMXBWSqIC2m+xVZJXNd7cCbIn5gSrzWJU0nBU7VklOfbt5
         O/1EcY3M99vqg2Z9Xcsyxstc75S/kxJ+yv1eIZBSHCjq6BEeH1JPYEz+SkbDtXAIfIOI
         nPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MfNuHxEjbU0bCTmDk+zE6vZTzkddZEYuAf50sMJGKgg=;
        b=G6wu2shxkZKgS+kOKLuveZZARBObtxaE0VPw0PuJWoS5UxCGr6fKDn+vJ6JkH+cLMb
         RCyt0GMCOwOGInVO7MeOwXRkIztvtQvEvoKCPjvF3aHtIxtlPd5Zp1B6zaivHqxZ1gc6
         LS8e16AbdxKtG/ZpqCY0MDY14OI0i/ONAKd1RzfvmYHbsbCQGRSIc/ZasKMvRKt7xl6z
         /0XkxhDU9vQSrWnnc0r4xKZO35noxFOFnxEJTjEPYrJLVsHUGzqrnp/fz+9uVbNLD0Ob
         ZCPeHxrl2BscsjjJzk97Nmq6rP29f/wjgTKcPpcz7qK8F6mdux6p/K+YuBqVxA9uWY4B
         MG5Q==
X-Gm-Message-State: AGi0PuZRnIkc9jw8/0dz5QGm4RbsrNryzqsBPpeHDj2YLfBhZ6XhzkNE
        qyTuJKvhcrIMaYV9SgTfrByPas9L/x0=
X-Google-Smtp-Source: APiQypIDRKVsAQTQyFKAhqpbU0C302ofCvuJAl3k+iOWY8JAehMX/V279+yxQ8ErJsnR+ybkwrUqEA==
X-Received: by 2002:a5d:49cb:: with SMTP id t11mr23879759wrs.91.1587472846686;
        Tue, 21 Apr 2020 05:40:46 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:45 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 02/24] clk: Fix debugfs_create_*() usage
Date:   Tue, 21 Apr 2020 13:39:55 +0100
Message-Id: <20200421124017.272694-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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
 drivers/clk/clk.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8341a128dab1d..44b6f23cc851d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2172,18 +2172,16 @@ static int clk_debug_create_one(struct clk_core *core, struct dentry *pdentry)
 
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
 
@@ -2192,23 +2190,23 @@ static int clk_debug_create_one(struct clk_core *core, struct dentry *pdentry)
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
 
 	if (core->num_parents > 1) {
-		d = debugfs_create_file("clk_possible_parents", S_IRUGO,
+		d = debugfs_create_file("clk_possible_parents", 0444,
 				core->dentry, core, &possible_parents_fops);
 		if (!d)
 			goto err_out;
@@ -2304,22 +2302,22 @@ static int __init clk_debug_init(void)
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


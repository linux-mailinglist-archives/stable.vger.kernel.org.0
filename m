Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124FB19C98D
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389176AbgDBTNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40596 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388499AbgDBTNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id s8so3446298wrt.7
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MfNuHxEjbU0bCTmDk+zE6vZTzkddZEYuAf50sMJGKgg=;
        b=hcewtn1dA6E9+AD3SaVD4EmMKP2XBXb2KK5aJeDjGTOS6BpOd6hVdieWxUEXVLVc7r
         /Xz6ib9tztwyKfUu23zPamFqA1GNNXiMDFxwFGVqqUY/pzsEI20qeRJkc00q+ZhlzkM8
         hjlN5/jppNkM6DULq3ivFYQzNL6xvv/C7K9fMm4RUOfp+DMlxF8se1AmAoZwht3Q4ZBN
         64uWuVIh8hUjdcWhoHLXy58iSfDV2xF277lYxGLBlPCpertuoYGjMmJWtWPua4IVE1u5
         C2qutIF8malxX7KmyAZHCxLlkR+LZStQabUWsDnhQKJdSqTvKhkFTHsXWWc73nbOCh7S
         4Ldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MfNuHxEjbU0bCTmDk+zE6vZTzkddZEYuAf50sMJGKgg=;
        b=pJTic1thcHf5rUufQkJmr8n7VWWpmVPprxbm4/cPgNBO1XKvUjHB89aW2KMggzvRhg
         jnth4e4Epk5Yk0hYAMuKl72uHmt1986m/RG7xHK9jktMDpedY4xt+xmi0J0m6wCkSVaO
         IBk7tzBNNvTHMUQGaTNSLpAm3vLVMv6HDzuRtW8FKm8EEQQqV+WnfQu3SyQFTgMSrlOo
         XVp1yLBAS06mSZac5VQ6UNfIlrVweqVBbYkozWVIIEi+gCkywRGDFrx0kDK5NTu67j09
         tNaA4t4kPZBH1Lrdi8lxTOoWEDhfVf/zy3gREkVW2rSjeIgjRU67U4oDS1+j2nrZ7Nqw
         33CQ==
X-Gm-Message-State: AGi0PubvNhxaNdGHDNt1IwyND7B1UOPNKngC4+K/EcEM2/s7deZFtImt
        Sez9fE/XhO1z/bAuJFwEl3VptRqQ5EMKKQ==
X-Google-Smtp-Source: APiQypJesy2YQ5crxKa+I7EbrsHQj29e1OpEU8kbHsYvhdqMS/l9jrQsUrDHCrgFTonnZYvLffgkSA==
X-Received: by 2002:adf:dfce:: with SMTP id q14mr5182942wrn.326.1585854785272;
        Thu, 02 Apr 2020 12:13:05 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 06/33] clk: Fix debugfs_create_*() usage
Date:   Thu,  2 Apr 2020 20:13:26 +0100
Message-Id: <20200402191353.787836-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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


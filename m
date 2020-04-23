Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129B11B659B
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgDWUk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgDWUk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:28 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8E4C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:27 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b11so8233248wrs.6
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L9D1J6uad5GUOPochmF5JS8/Db5h8NdbEGVPtZHCPyg=;
        b=x9XWLc0sb2pCTqjHskCpxWf7PctBX11RXvaasPaoMHipG9H0sZWM4SGskE6WElu8EZ
         sYBzTs6MJKlQxhI7PxAjA3biGgj2nFNdV830FDj9vGhYDFLUpWKYTlyrnU4LTtnROEVN
         IZkHEJqX1R98yS5RSRn1/MJNtn55XAwKqMBPUYWJinCK5qEx+csYYdGK3lYypiVO+B18
         ei6KVgZLy+D1Ls6NRVcwQQUP2ftNQXQvuJQb9wXpZNXSsLmDCh7pf9wsYryIjQeoQmT/
         gcxVMKNgZF+eManJO4Wm0ipBiDd1gxCzY4ktzOF/9Wityj6KxCDXxVpDlrSQHE6KsLGj
         9DbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L9D1J6uad5GUOPochmF5JS8/Db5h8NdbEGVPtZHCPyg=;
        b=Jo3/OSDBczkxJVk/XJVCWtv0QCvVODxufAAq3DCPmaNHnbAbRBY08W7BSEWx5Rnq5q
         K6AEYedQwmhmweOK1oEsFKTihV4E8Fa6oLrk/SYNkMYulUg6I3izzqHIFtnALIwOMkem
         g5U3F2Frp7R3yB6JhZwGxp7n5DjtBM1hi35t+Bovful/qbSTZdRjqG9S5Z1NqrXpOJWm
         jxIDmHgIOgDH+9l1wPzOntdaFxmUbKGQOi5maXPIkJYLqJos8KCZtUdeOoq7St/Ik2DW
         XO1ISFya1HCXDVTRmQzWmOvGNCWDQNcBHYxMwz47I+5YYP7mxu2uINfTUmDNaARcpoh2
         /6cw==
X-Gm-Message-State: AGi0Puaa2NiWZhbp7CSdL+LTi5zZPAYxVXrux8J5ShDGLFdEGCeJbC1l
        RDKGazehHzdOw7uASG0xFh3fxfnnXH0=
X-Google-Smtp-Source: APiQypLLp0C0bclpN2kV2RZEhSHLGgweXING2RAJMnWUaBIANfMO8Oe/QjjV9cg9RurwuQSoJ0jOLQ==
X-Received: by 2002:a5d:670c:: with SMTP id o12mr6663803wru.286.1587674425031;
        Thu, 23 Apr 2020 13:40:25 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:24 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 06/16] clk: Fix debugfs_create_*() usage
Date:   Thu, 23 Apr 2020 21:40:04 +0100
Message-Id: <20200423204014.784944-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
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
index 53c068f90b376..0654dbf86364f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2121,18 +2121,16 @@ static int clk_debug_create_one(struct clk_core *core, struct dentry *pdentry)
 
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
 
@@ -2141,18 +2139,18 @@ static int clk_debug_create_one(struct clk_core *core, struct dentry *pdentry)
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
 
@@ -2246,22 +2244,22 @@ static int __init clk_debug_init(void)
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


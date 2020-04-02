Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6548619C9D7
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389484AbgDBTSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54464 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389476AbgDBTSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id c81so4634593wmd.4
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=L9D1J6uad5GUOPochmF5JS8/Db5h8NdbEGVPtZHCPyg=;
        b=E2XSm1MrCmU6o3YBz4g+ZJXV4H67a7ohe6d0lvJCB8um20RiqzirI/SSxyBLgwaVGM
         Orka3BwLzos7je53NLHp7AMCWjviRJWpUhdCKwswSvkbTnocKI0vBhAoERDIFv15XILw
         8iixc/bT1UqQgHLGBQQ1DWgk7PvoWmMAXDTl+of/8/vcWk1DLhoum3GBS+N/nzDZWy2f
         ig4eiT6frGRqOGGwIvC1mmCHXCachvqQwbFZyTZ+2S77wgRRkVtHfqsGH4n0PFe98PHO
         1y4pR1gz8a8RwHYuMzfWg3bD9A33+nwpLBTMIFjg4Ixl+ODmLhPDg6ythukeZWMylfK9
         2WDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L9D1J6uad5GUOPochmF5JS8/Db5h8NdbEGVPtZHCPyg=;
        b=NQ1D0QEuuFm3iYpMyPW4JmIo4knhrkJ4auSjKEz8fXqnR2FjQWC5UPIPYFesHri4DD
         gtk4MWBQZOLpNdnjB4OOw9Wl4Fww51yiIpKcT478gCqZKIKEG+Zc7p2lKJipIl7ycSwU
         +RsME15o/GmsF/IqhlDenP+TZ3vbAJotMg5YyaBOaNSWt/oNXNzW+c399i7nXvl1BC0r
         88R/ysG+mfXzxN7GryCQI0DMmRb11CQyFnQrra0ihTVHpfhMFJPCsGkMel3VXwquaqUF
         DfgGiU6qkcAp/TnQ6Sxc+77+Nm9w4TPAJnzz1nbfXk4wlUv5lgUaeG1sWNqIRp5pr3H1
         xxkA==
X-Gm-Message-State: AGi0PuZCyrEN/n8BxDmY9mRm+JOAQs7jsfXmq0DDUwhVIzY7WC14ejYj
        xR4BJ1M8tL5nv5vMO+TXSncZhDh/8HoQDg==
X-Google-Smtp-Source: APiQypKT08cJzG32y9Vrb6+lF5H4UAFY1xi87wMIX8/OPTU5TcDSusqU8e1tYSFYVbGTN2fonXvM3g==
X-Received: by 2002:a1c:b789:: with SMTP id h131mr4577320wmf.141.1585855090005;
        Thu, 02 Apr 2020 12:18:10 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 08/20] clk: Fix debugfs_create_*() usage
Date:   Thu,  2 Apr 2020 20:18:44 +0100
Message-Id: <20200402191856.789622-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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


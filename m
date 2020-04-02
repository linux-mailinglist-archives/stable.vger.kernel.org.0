Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1E019C9B6
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388726AbgDBTRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54343 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388668AbgDBTRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id c81so4631409wmd.4
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8n9PuhMajM7WvWxCjQiwhBj7Uis5bjcy3z0jj02FBf0=;
        b=vo6W9dlRhe5Qz+GhdZL+EGPCE3kcfywClHKyQslkjPIZiiYFzFnuOYuZGbF/dhs+cF
         03g2oN2xQ/5odkS40v417g7j4ocCzQaPr8Hf1zTVLco4QjMu4GNRgcvGeX5YwwurFf85
         aO1wrFKyuIyLisMbEB+uWUUdzVBx0XR/HOFL/+3Wf5VKpyF52ZjI4mj7nimA89tcxVyv
         qTLLgLyz5UcC/sofS1Uafr7Q3JEylcmCyXbhhT8k1Fr/QzOodUU70mQZWKMPjEuXmdwE
         oplP8TUoNeugTbGCyGT4fW0wt8FEKuZ++vH5ihwIG0kjfeC5/1EolqQ4L3ApW7qACQTB
         j3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8n9PuhMajM7WvWxCjQiwhBj7Uis5bjcy3z0jj02FBf0=;
        b=gSLhjL5NsjqhUVznF0TdIFyiW6gaFreouASsVcFaQKzO5fKIpyWwkP6vkdEZDMgS3K
         nQZpzu0MCKLG0qYYRfHH6L434q4N+BQxxRt3lWSv07ybLQKofSnrChvMP/Kkj5d4YstC
         6mshMb98c7aA0a/RVwpuEKSuXwr/JPyXIkXuLBOgIRMJ/EnOryYrXMKiitSbO95AInpW
         8/0wlpUAYSPSqxwTKjQ+70jYzcTBs8vFL0IWRn+Og+KxB45r/ea9wnINEXto2EH3iaPW
         p3jsMm91Wi/5IjPEc3C20JhUenGihG1G4y96+K0ChJtmVja9xOc0pfa4aWITzMOTehGM
         YisQ==
X-Gm-Message-State: AGi0PuYnyjLgnI2P9RIaFzCto5wUdXp7WLr8VaYdtjyzrr77akV5Ibfr
        1WXSHFUyAivy6PVuF/tQA1W4ndcOnGrxsw==
X-Google-Smtp-Source: APiQypK4qBca4/OdOy0sz2KYJDMpL3MvAVx/PfXDzQBKdbIKEk8fqVXYmtze9vY0PYjsy/B9kqfMNg==
X-Received: by 2002:a1c:3105:: with SMTP id x5mr5031191wmx.51.1585855021078;
        Thu, 02 Apr 2020 12:17:01 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 07/24] clk: Fix debugfs_create_*() usage
Date:   Thu,  2 Apr 2020 20:17:30 +0100
Message-Id: <20200402191747.789097-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490B46AA46C
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbjCCWcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbjCCWcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:32:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128086BC25;
        Fri,  3 Mar 2023 14:27:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61F98CE2293;
        Fri,  3 Mar 2023 21:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B138C433A0;
        Fri,  3 Mar 2023 21:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879976;
        bh=5pTpqzmPf7Uhv2rZkssKMsxFAkAyMhw+dRFRyeHeA9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Of9n28tOqdKI41diM3gugLg59bsGvJFsQ66QRXlBd6RN1e5HX099TTNZS+G7N1lp6
         BxhQK4bPU0beBega8ufy1Lm8g+wwH0VZDJmWGMctsk7Kla5AohPjXepmZKyWBawAch
         LN6yzoI46KlogwHK6hGTz/l5DItBnembVf4L/fwBrVF8KuFBbgx1MlWk9x6NSu4C+B
         BFPJve7Pe+xXIjEa6NeWdadkaS/1HgW1fxiA3HMhXqbb/xQ6AoU0kCFQRf2Vh7A3T3
         HQueMrdhtCHPVEfpOV3HrWaZjcmeNYTOFuXPCyuzx0o+md7nQAa0ZLT+opJgDg1Ls6
         QRDbxWilSQfjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bruce Chen <bruce.chen@unisoc.com>,
        Cixi Geng <cixi.geng1@unisoc.com>,
        Cixi Geng <gengcixi@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 21/50] USB: dwc3: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:02 -0500
Message-Id: <20230303214531.1450154-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit be308d68785b205e483b3a0c61ba3a82da468f2c ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Note, the root dentry for the debugfs directory for the device needs to
be saved so we don't have to keep looking it up, which required a bit
more refactoring to properly create and remove it when needed.

Reported-by: Bruce Chen <bruce.chen@unisoc.com>
Reported-by: Cixi Geng <cixi.geng1@unisoc.com>
Tested-by: Cixi Geng <gengcixi@gmail.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20230202152820.2409908-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.h    |  2 ++
 drivers/usb/dwc3/debug.h   |  3 +++
 drivers/usb/dwc3/debugfs.c | 19 ++++++++-----------
 drivers/usb/dwc3/gadget.c  |  4 +---
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index e82e4cbe4ec70..725653711411d 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1092,6 +1092,7 @@ struct dwc3_scratchpad_array {
  *		     address.
  * @num_ep_resized: carries the current number endpoints which have had its tx
  *		    fifo resized.
+ * @debug_root: root debugfs directory for this device to put its files in.
  */
 struct dwc3 {
 	struct work_struct	drd_work;
@@ -1303,6 +1304,7 @@ struct dwc3 {
 	int			max_cfg_eps;
 	int			last_fifo_depth;
 	int			num_ep_resized;
+	struct dentry		*debug_root;
 };
 
 #define INCRX_BURST_MODE 0
diff --git a/drivers/usb/dwc3/debug.h b/drivers/usb/dwc3/debug.h
index d223c54115f4a..01d0366bf93ae 100644
--- a/drivers/usb/dwc3/debug.h
+++ b/drivers/usb/dwc3/debug.h
@@ -414,11 +414,14 @@ static inline const char *dwc3_gadget_generic_cmd_status_string(int status)
 
 #ifdef CONFIG_DEBUG_FS
 extern void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep);
+extern void dwc3_debugfs_remove_endpoint_dir(struct dwc3_ep *dep);
 extern void dwc3_debugfs_init(struct dwc3 *d);
 extern void dwc3_debugfs_exit(struct dwc3 *d);
 #else
 static inline void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
 {  }
+static inline void dwc3_debugfs_remove_endpoint_dir(struct dwc3_ep *dep)
+{  }
 static inline void dwc3_debugfs_init(struct dwc3 *d)
 {  }
 static inline void dwc3_debugfs_exit(struct dwc3 *d)
diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index f2b7675c7f621..850df0e6bcabf 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -873,27 +873,23 @@ static const struct dwc3_ep_file_map dwc3_ep_file_map[] = {
 	{ "GDBGEPINFO", &dwc3_ep_info_register_fops, },
 };
 
-static void dwc3_debugfs_create_endpoint_files(struct dwc3_ep *dep,
-		struct dentry *parent)
+void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
 {
+	struct dentry		*dir;
 	int			i;
 
+	dir = debugfs_create_dir(dep->name, dep->dwc->debug_root);
 	for (i = 0; i < ARRAY_SIZE(dwc3_ep_file_map); i++) {
 		const struct file_operations *fops = dwc3_ep_file_map[i].fops;
 		const char *name = dwc3_ep_file_map[i].name;
 
-		debugfs_create_file(name, 0444, parent, dep, fops);
+		debugfs_create_file(name, 0444, dir, dep, fops);
 	}
 }
 
-void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
+void dwc3_debugfs_remove_endpoint_dir(struct dwc3_ep *dep)
 {
-	struct dentry		*dir;
-	struct dentry		*root;
-
-	root = debugfs_lookup(dev_name(dep->dwc->dev), usb_debug_root);
-	dir = debugfs_create_dir(dep->name, root);
-	dwc3_debugfs_create_endpoint_files(dep, dir);
+	debugfs_lookup_and_remove(dep->name, dep->dwc->debug_root);
 }
 
 void dwc3_debugfs_init(struct dwc3 *dwc)
@@ -911,6 +907,7 @@ void dwc3_debugfs_init(struct dwc3 *dwc)
 	dwc->regset->base = dwc->regs - DWC3_GLOBALS_REGS_START;
 
 	root = debugfs_create_dir(dev_name(dwc->dev), usb_debug_root);
+	dwc->debug_root = root;
 	debugfs_create_regset32("regdump", 0444, root, dwc->regset);
 	debugfs_create_file("lsp_dump", 0644, root, dwc, &dwc3_lsp_fops);
 
@@ -929,6 +926,6 @@ void dwc3_debugfs_init(struct dwc3 *dwc)
 
 void dwc3_debugfs_exit(struct dwc3 *dwc)
 {
-	debugfs_remove(debugfs_lookup(dev_name(dwc->dev), usb_debug_root));
+	debugfs_lookup_and_remove(dev_name(dwc->dev), usb_debug_root);
 	kfree(dwc->regset);
 }
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 4812ba4bbedd7..a0100d26de8e1 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3081,9 +3081,7 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 			list_del(&dep->endpoint.ep_list);
 		}
 
-		debugfs_remove_recursive(debugfs_lookup(dep->name,
-				debugfs_lookup(dev_name(dep->dwc->dev),
-					       usb_debug_root)));
+		dwc3_debugfs_remove_endpoint_dir(dep);
 		kfree(dep);
 	}
 }
-- 
2.39.2


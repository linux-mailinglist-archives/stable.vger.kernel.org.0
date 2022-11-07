Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D64261FA2E
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiKGQnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiKGQnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:43:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B1060CC
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:43:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25896B81151
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7988CC433D6;
        Mon,  7 Nov 2022 16:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839414;
        bh=1XbiB8rBb7io64jMbW7+7C5II2TJlXX3Vbh4wKalYs8=;
        h=Subject:To:Cc:From:Date:From;
        b=WQK00O4XJk+n9g+LFW/h6bJZrE64h1qst/dyOeq/3RFrGCbFtvyPUF/WT3P2p0hW2
         sCtBA9PyivPOiwm14NtCH7f3UCBeetb/Tsk9DR8oF4J5zTzG7b2uQ0J2HduVvZ1XbW
         iOjoVb68Tv919L+wChVGS+2Betl5e0sJWngn34Gk=
Subject: FAILED: patch "[PATCH] parisc: Avoid printing the hardware path twice" failed to apply to 4.9-stable tree
To:     deller@gmx.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 17:43:23 +0100
Message-ID: <166783940341190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2b6ae0962b42 ("parisc: Avoid printing the hardware path twice")
4f80b70e1953 ("parisc: Use proper printk format for resource_size_t")
5e791d2e4785 ("parisc: Convert printk(KERN_LEVEL) to pr_lvl()")
0ae60d0c4f19 ("parisc: Show unhashed hardware inventory")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2b6ae0962b421103feb41a80406732944b0665b3 Mon Sep 17 00:00:00 2001
From: Helge Deller <deller@gmx.de>
Date: Fri, 28 Oct 2022 18:12:49 +0200
Subject: [PATCH] parisc: Avoid printing the hardware path twice

Avoid that the hardware path is shown twice in the kernel log, and clean
up the output of the version numbers to show up in the same order as
they are listed in the hardware database in the hardware.c file.
Additionally, optimize the memory footprint of the hardware database
and mark some code as init code.

Fixes: cab56b51ec0e ("parisc: Fix device names in /proc/iomem")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v4.9+

diff --git a/arch/parisc/include/asm/hardware.h b/arch/parisc/include/asm/hardware.h
index 9d3d7737c58b..a005ebc54779 100644
--- a/arch/parisc/include/asm/hardware.h
+++ b/arch/parisc/include/asm/hardware.h
@@ -10,12 +10,12 @@
 #define SVERSION_ANY_ID		PA_SVERSION_ANY_ID
 
 struct hp_hardware {
-	unsigned short	hw_type:5;	/* HPHW_xxx */
-	unsigned short	hversion;
-	unsigned long	sversion:28;
-	unsigned short	opt;
-	const char	name[80];	/* The hardware description */
-};
+	unsigned int	hw_type:8;	/* HPHW_xxx */
+	unsigned int	hversion:12;
+	unsigned int	sversion:12;
+	unsigned char	opt;
+	unsigned char	name[59];	/* The hardware description */
+} __packed;
 
 struct parisc_device;
 
diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index d126e78e101a..e7ee0c0c91d3 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -882,15 +882,13 @@ void __init walk_central_bus(void)
 			&root);
 }
 
-static void print_parisc_device(struct parisc_device *dev)
+static __init void print_parisc_device(struct parisc_device *dev)
 {
-	char hw_path[64];
-	static int count;
+	static int count __initdata;
 
-	print_pa_hwpath(dev, hw_path);
-	pr_info("%d. %s at %pap [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
-		++count, dev->name, &(dev->hpa.start), hw_path, dev->id.hw_type,
-		dev->id.hversion_rev, dev->id.hversion, dev->id.sversion);
+	pr_info("%d. %s at %pap { type:%d, hv:%#x, sv:%#x, rev:%#x }",
+		++count, dev->name, &(dev->hpa.start), dev->id.hw_type,
+		dev->id.hversion, dev->id.sversion, dev->id.hversion_rev);
 
 	if (dev->num_addrs) {
 		int k;
@@ -1079,7 +1077,7 @@ static __init int qemu_print_iodc_data(struct device *lin_dev, void *data)
 
 
 
-static int print_one_device(struct device * dev, void * data)
+static __init int print_one_device(struct device * dev, void * data)
 {
 	struct parisc_device * pdev = to_parisc_device(dev);
 


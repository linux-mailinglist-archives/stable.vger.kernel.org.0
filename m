Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A3857FC7F
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 11:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiGYJfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 05:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiGYJfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 05:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723B0BE7
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 02:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26F06B80E25
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 09:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DFBC341CF;
        Mon, 25 Jul 2022 09:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658741708;
        bh=80VMy1f9W5I0ZkKT42J10ilybsCFk4PPDD05txpaxKk=;
        h=Subject:To:Cc:From:Date:From;
        b=Cyz3B/QSMWOISbqlYj/vfM9cZc8wjCBO0kS9+VtBluP7BrKJrHmsJNQ2tWv4F4T+n
         9YWoEAbf359oFGVyaslwW9pNlrt8BwluSJBCqUziuMViRRemebOXhNbeyeYq2omxMk
         8sAliPPoP794zR9j4yMOAs2Li2iNSD11rBGrFPrk=
Subject: FAILED: patch "[PATCH] x86/speculation: Make all RETbleed mitigations 64-bit only" failed to apply to 5.18-stable tree
To:     ben@decadent.org.uk, bp@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jul 2022 11:34:56 +0200
Message-ID: <165874169647228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b648ab487f31bc4c38941bc770ea97fe394304bb Mon Sep 17 00:00:00 2001
From: Ben Hutchings <ben@decadent.org.uk>
Date: Sat, 23 Jul 2022 17:22:47 +0200
Subject: [PATCH] x86/speculation: Make all RETbleed mitigations 64-bit only

The mitigations for RETBleed are currently ineffective on x86_32 since
entry_32.S does not use the required macros.  However, for an x86_32
target, the kconfig symbols for them are still enabled by default and
/sys/devices/system/cpu/vulnerabilities/retbleed will wrongly report
that mitigations are in place.

Make all of these symbols depend on X86_64, and only enable RETHUNK by
default on X86_64.

Fixes: f43b9876e857 ("x86/retbleed: Add fine grained Kconfig knobs")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YtwSR3NNsWp1ohfV@decadent.org.uk

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e58798f636d4..1670a3fed263 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2473,7 +2473,7 @@ config RETHUNK
 	bool "Enable return-thunks"
 	depends on RETPOLINE && CC_HAS_RETURN_THUNK
 	select OBJTOOL if HAVE_OBJTOOL
-	default y
+	default y if X86_64
 	help
 	  Compile the kernel with the return-thunks compiler option to guard
 	  against kernel-to-user data leaks by avoiding return speculation.
@@ -2482,21 +2482,21 @@ config RETHUNK
 
 config CPU_UNRET_ENTRY
 	bool "Enable UNRET on kernel entry"
-	depends on CPU_SUP_AMD && RETHUNK
+	depends on CPU_SUP_AMD && RETHUNK && X86_64
 	default y
 	help
 	  Compile the kernel with support for the retbleed=unret mitigation.
 
 config CPU_IBPB_ENTRY
 	bool "Enable IBPB on kernel entry"
-	depends on CPU_SUP_AMD
+	depends on CPU_SUP_AMD && X86_64
 	default y
 	help
 	  Compile the kernel with support for the retbleed=ibpb mitigation.
 
 config CPU_IBRS_ENTRY
 	bool "Enable IBRS on kernel entry"
-	depends on CPU_SUP_INTEL
+	depends on CPU_SUP_INTEL && X86_64
 	default y
 	help
 	  Compile the kernel with support for the spectre_v2=ibrs mitigation.


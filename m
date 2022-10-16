Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9608F5FFEB8
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 12:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJPKsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 06:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJPKsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 06:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983223CBF0
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 03:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3545760A56
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 10:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C73C433D7;
        Sun, 16 Oct 2022 10:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665917323;
        bh=TjUnu22GJAkqIGnvFyV2YxA7hv2UR4423FdvuMvhgDI=;
        h=Subject:To:Cc:From:Date:From;
        b=dt4XuWUqGlxyAq09xM2aYsWu7+8bZilCZJpyQnd8GsTsYhLqtuna5+XZx44uqdLoc
         qhTxZ7pwbr5yeoMEg7wiwMMvZE1dJj5UrB9Jnh2bXOkLJZ6I4ehFFZNV1KxW2Fb6qn
         bdlVKiVB/rSRFNw2+ccP69OyG32nfLuW+mpvHzxY=
Subject: FAILED: patch "[PATCH] arm64: errata: Add Cortex-A55 to the repeat tlbi list" failed to apply to 4.19-stable tree
To:     james.morse@arm.com, catalin.marinas@arm.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 12:49:24 +0200
Message-ID: <166591736425044@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

171df58028bf ("arm64: errata: Add Cortex-A55 to the repeat tlbi list")
39fdb65f52e9 ("arm64: errata: Add Cortex-A510 to the repeat tlbi list")
1dd498e5e26a ("KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata")
297ae1eb23b0 ("arm64: cpufeature: List early Cortex-A510 parts as having broken dbm")
708e8af4924e ("arm64: errata: Add detection for TRBE trace data corruption")
3bd94a8759de ("arm64: errata: Add detection for TRBE invalid prohibited states")
607a9afaae09 ("arm64: errata: Add detection for TRBE ignored system register writes")
83bb2c1a01d7 ("KVM: arm64: Save PSTATE early on exit")
d7e0a795bf37 ("Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 171df58028bf4649460fb146a56a58dcb0c8f75a Mon Sep 17 00:00:00 2001
From: James Morse <james.morse@arm.com>
Date: Fri, 30 Sep 2022 14:19:59 +0100
Subject: [PATCH] arm64: errata: Add Cortex-A55 to the repeat tlbi list

Cortex-A55 is affected by an erratum where in rare circumstances the
CPUs may not handle a race between a break-before-make sequence on one
CPU, and another CPU accessing the same page. This could allow a store
to a page that has been unmapped.

Work around this by adding the affected CPUs to the list that needs
TLB sequences to be done twice.

Signed-off-by: James Morse <james.morse@arm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220930131959.3082594-1-james.morse@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 17d9fc5d14fb..808ade4cc008 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -76,6 +76,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A55      | #1530923        | ARM64_ERRATUM_1530923       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A55      | #2441007        | ARM64_ERRATUM_2441007       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075        |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #852523         | N/A                         |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1675310f1791..20d082d54bd8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -634,6 +634,23 @@ config ARM64_ERRATUM_1530923
 config ARM64_WORKAROUND_REPEAT_TLBI
 	bool
 
+config ARM64_ERRATUM_2441007
+	bool "Cortex-A55: Completion of affected memory accesses might not be guaranteed by completion of a TLBI"
+	default y
+	select ARM64_WORKAROUND_REPEAT_TLBI
+	help
+	  This option adds a workaround for ARM Cortex-A55 erratum #2441007.
+
+	  Under very rare circumstances, affected Cortex-A55 CPUs
+	  may not handle a race between a break-before-make sequence on one
+	  CPU, and another CPU accessing the same page. This could allow a
+	  store to a page that has been unmapped.
+
+	  Work around this by adding the affected CPUs to the list that needs
+	  TLB sequences to be done twice.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_1286807
 	bool "Cortex-A76: Modification of the translation table for a virtual address might lead to read-after-read ordering violation"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 58ca4f6b25d6..89ac00084f38 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -230,6 +230,11 @@ static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 		ERRATA_MIDR_RANGE(MIDR_QCOM_KRYO_4XX_GOLD, 0xc, 0xe, 0xf, 0xe),
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_2441007
+	{
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
+	},
+#endif
 #ifdef CONFIG_ARM64_ERRATUM_2441009
 	{
 		/* Cortex-A510 r0p0 -> r1p1. Fixed in r1p2 */


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D14F1A9C19
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896914AbgDOLYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:24:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45045 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896917AbgDOLX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:23:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 2DD495C01C1;
        Wed, 15 Apr 2020 07:23:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:23:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iNZsEt
        p4oliTE8vBdN5s8bZujU3JIVzVqgM5lCOjOt0=; b=d+wAZEz/WLHPbt4j9uN7UC
        2cJFb9Agqv3Js41H1hjnJzm9cnh0RGox/o+FSZJKhHNyN7w1YVWqOvbvzU+iiSfP
        y5NK+CPdBz63T0we3IiHzv52eP2spu6EvA7Z/jU7fD5u/FmmQw05i8Sxbj37Mb6s
        tkOrjNiIZJQ6TOHMlKLxWQlTC4uo3TzJ8fE1oEH5G2dPDGErLgTpiv86nh0lemUI
        EE+EHYZ4SSHznGJA8mfmKjBp2BUNPsxBwAYpc7/4akoNRlgHlyb+0HYc83+yjOPH
        LlocOlowHHDWEL95VE0Zvgwb5JNRiidMhLYwXczCKTHujm45OWYOFqkysevN9zjg
        ==
X-ME-Sender: <xms:t-6WXg4IYAwiSYKV_JRxDtrPDGcJJTPu1c5Hrv0HrRbkaz7mnGHRvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:t-6WXp-nkow_bXAiGu2Minf1NqMnwFYz4V64yb0B-XI-nIqH4A3GyA>
    <xmx:t-6WXknu_EqaqE9aGIODXb1i80ZtFWItqQgzo0k7YvwOPVit6zuNdg>
    <xmx:t-6WXgudOc4R910xsOsnlKuTBkJ_VOJaTy2-dxxTIU3g-IDcUADQig>
    <xmx:t-6WXgAasq4yt_4VdlxMfO3fsZWRUlwrRJPyY04_V6MZ89J8Qd64YQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C0A0F3060062;
        Wed, 15 Apr 2020 07:23:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Always force a branch protection mode when the" failed to apply to 5.5-stable tree
To:     broonie@kernel.org, catalin.marinas@arm.com, szabolcs.nagy@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:23:25 +0200
Message-ID: <158694980523780@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b8fdef311a0bd9223f10754f94fdcf1a594a3457 Mon Sep 17 00:00:00 2001
From: Mark Brown <broonie@kernel.org>
Date: Tue, 31 Mar 2020 20:44:59 +0100
Subject: [PATCH] arm64: Always force a branch protection mode when the
 compiler has one

Compilers with branch protection support can be configured to enable it by
default, it is likely that distributions will do this as part of deploying
branch protection system wide. As well as the slight overhead from having
some extra NOPs for unused branch protection features this can cause more
serious problems when the kernel is providing pointer authentication to
userspace but not built for pointer authentication itself. In that case our
switching of keys for userspace can affect the kernel unexpectedly, causing
pointer authentication instructions in the kernel to corrupt addresses.

To ensure that we get consistent and reliable behaviour always explicitly
initialise the branch protection mode, ensuring that the kernel is built
the same way regardless of the compiler defaults.

Fixes: 7503197562567 (arm64: add basic pointer authentication support)
Reported-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
[catalin.marinas@arm.com: remove Kconfig option in favour of Makefile check]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index f15f92ba53e6..85e4149cc5d5 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -65,6 +65,10 @@ stack_protector_prepare: prepare0
 					include/generated/asm-offsets.h))
 endif
 
+# Ensure that if the compiler supports branch protection we default it
+# off, this will be overridden if we are using branch protection.
+branch-prot-flags-y += $(call cc-option,-mbranch-protection=none)
+
 ifeq ($(CONFIG_ARM64_PTR_AUTH),y)
 branch-prot-flags-$(CONFIG_CC_HAS_SIGN_RETURN_ADDRESS) := -msign-return-address=all
 branch-prot-flags-$(CONFIG_CC_HAS_BRANCH_PROT_PAC_RET) := -mbranch-protection=pac-ret+leaf
@@ -73,9 +77,10 @@ branch-prot-flags-$(CONFIG_CC_HAS_BRANCH_PROT_PAC_RET) := -mbranch-protection=pa
 # we pass it only to the assembler. This option is utilized only in case of non
 # integrated assemblers.
 branch-prot-flags-$(CONFIG_AS_HAS_PAC) += -Wa,-march=armv8.3-a
-KBUILD_CFLAGS += $(branch-prot-flags-y)
 endif
 
+KBUILD_CFLAGS += $(branch-prot-flags-y)
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__


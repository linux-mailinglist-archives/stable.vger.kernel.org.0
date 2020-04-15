Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC491A9C18
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896919AbgDOLYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:24:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53291 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896914AbgDOLX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:23:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 921485C0143;
        Wed, 15 Apr 2020 07:23:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eGCD6J
        jDTDnAY4EVOTGkyLtOrgqe87ly9ZzfygF9L8E=; b=l/Xp8o27JF1FADMWWPfcUK
        d14UMq4/wlKyZwv9RVHHL2QKrmhLZDQXkhtQSt9R0FamAoTrEHIysGRtD6ep2po1
        hgzzeaoWfd+hh/RnejTn7dhpMQibKiwtJV67NRE1xeMCVs5KWflOhB7i+eK8ZJ7Y
        x7mYbx42An+SOE/YnbKtJoV6ba4VPon2/FvWowQ0W9wwlA/YuhehHz6eQw045IEL
        bxTurcn0omA0Mx5OUm+JDY7t8nmBHRHrkWq7zdocuo5oP8UyQ6OVbj9jrIxmomE2
        JyO9Hblt18eGUKyZxlnRHFw06XLBiMlkNwhKH9z7XGJL7k7BQTM63Wmtl21dNsbw
        ==
X-ME-Sender: <xms:uO6WXif2G5eb-ufIZxS7a_BWnJLNyjWQ1fDQYmXz3smho1JUhybKZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:uO6WXuqSS2isMqBI6ZeO775WezhYA2S0glhi-uTHI4KCULItUNh02Q>
    <xmx:uO6WXjuPiMmpN2jUACR_NswlvjDAQxr2wFv_4JDqg1ewJ46vSr83_A>
    <xmx:uO6WXnevbkPh2ABTgVtQNPo6glzuAFXtyG1Bo40NpNpeU15k0BfcCA>
    <xmx:uO6WXvwLyyB2AMUchQ14F6Z6qS9uFZif2oZxKNn0zuEALOE8OW0Ufw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3009D3060060;
        Wed, 15 Apr 2020 07:23:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Always force a branch protection mode when the" failed to apply to 5.4-stable tree
To:     broonie@kernel.org, catalin.marinas@arm.com, szabolcs.nagy@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:23:26 +0200
Message-ID: <158694980621760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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


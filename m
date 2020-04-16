Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE981AC677
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393404AbgDPOkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409523AbgDPOBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:01:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D073F217D8;
        Thu, 16 Apr 2020 14:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045709;
        bh=Yub1giOwKwtQXE+o4mjF7bdVyPZa5e+U7KaX8DLZl8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3pN5tjInuyJnY7dUr32otTdTqkf091VUlwMTmiwUVdA4wh7dmmAhQI6go1YExMFv
         fIMlt5DmhsIdk6Tl/Fdzv0TelmbbwtkaryhHUC2GKAEZikMhSG3b2yCoPJZcCLOESp
         XEHfWufATsxoma91FrdlDaRJ2VUrQT7Nmoy0c/L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.6 245/254] arm64: Always force a branch protection mode when the compiler has one
Date:   Thu, 16 Apr 2020 15:25:34 +0200
Message-Id: <20200416131356.384825424@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit b8fdef311a0bd9223f10754f94fdcf1a594a3457 upstream.

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

[This is a reworked version of b8fdef311a0bd9223f1075 ("arm64: Always
force a branch protection mode when the compiler has one") for backport.
Kernels prior to 74afda4016a7 ("arm64: compile the kernel with ptrauth
return address signing") don't have any Makefile machinery for forcing
on pointer auth but still have issues if the compiler defaults it on so
need this reworked version. -- broonie]

Fixes: 7503197562567 (arm64: add basic pointer authentication support)
Reported-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
[catalin.marinas@arm.com: remove Kconfig option in favour of Makefile check]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -65,6 +65,10 @@ stack_protector_prepare: prepare0
 					include/generated/asm-offsets.h))
 endif
 
+# Ensure that if the compiler supports branch protection we default it
+# off.
+KBUILD_CFLAGS += $(call cc-option,-mbranch-protection=none)
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__



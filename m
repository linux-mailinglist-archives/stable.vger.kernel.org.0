Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABF118B656
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgCSNZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730701AbgCSNZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:25:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 095912080C;
        Thu, 19 Mar 2020 13:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624353;
        bh=qeSR8s+xjYKgRtoXDhAo+RN2PMmTP5CX+CKt41Yu3xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVVEtO/oWhL0+3XAd7G8LjHxZPicOF1Q5smcJGMq1tlf6WFmq4CnBj0tq+W1cTpB+
         g6vE1egu07fCd8/EFmIDu0bQ6ikc4BURaaQ8Xe1DfRuNR1fJP1eNSd9RbO+4MNiQT9
         fMiZwnXpfBFJaALTen1H46U98MV84bBtMxA/a2L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 14/65] MIPS: Disable VDSO time functionality on microMIPS
Date:   Thu, 19 Mar 2020 14:03:56 +0100
Message-Id: <20200319123930.951581514@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paulburton@kernel.org>

[ Upstream commit 07015d7a103c4420b69a287b8ef4d2535c0f4106 ]

A check we're about to add to pick up on function calls that depend on
bogus use of the GOT in the VDSO picked up on instances of such function
calls in microMIPS builds. Since the code appears genuinely problematic,
and given the relatively small amount of use & testing that microMIPS
sees, go ahead & disable the VDSO for microMIPS builds.

Signed-off-by: Paul Burton <paulburton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/vdso/Makefile | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index 96afd73c94e8a..e8585a22b925c 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -48,6 +48,8 @@ endif
 
 CFLAGS_REMOVE_vgettimeofday.o = -pg
 
+DISABLE_VDSO := n
+
 #
 # For the pre-R6 code in arch/mips/vdso/vdso.h for locating
 # the base address of VDSO, the linker will emit a R_MIPS_PC32
@@ -61,11 +63,24 @@ CFLAGS_REMOVE_vgettimeofday.o = -pg
 ifndef CONFIG_CPU_MIPSR6
   ifeq ($(call ld-ifversion, -lt, 225000000, y),y)
     $(warning MIPS VDSO requires binutils >= 2.25)
-    obj-vdso-y := $(filter-out vgettimeofday.o, $(obj-vdso-y))
-    ccflags-vdso += -DDISABLE_MIPS_VDSO
+    DISABLE_VDSO := y
   endif
 endif
 
+#
+# GCC (at least up to version 9.2) appears to emit function calls that make use
+# of the GOT when targeting microMIPS, which we can't use in the VDSO due to
+# the lack of relocations. As such, we disable the VDSO for microMIPS builds.
+#
+ifdef CONFIG_CPU_MICROMIPS
+  DISABLE_VDSO := y
+endif
+
+ifeq ($(DISABLE_VDSO),y)
+  obj-vdso-y := $(filter-out vgettimeofday.o, $(obj-vdso-y))
+  ccflags-vdso += -DDISABLE_MIPS_VDSO
+endif
+
 # VDSO linker flags.
 VDSO_LDFLAGS := \
 	-Wl,-Bsymbolic -Wl,--no-undefined -Wl,-soname=linux-vdso.so.1 \
-- 
2.20.1




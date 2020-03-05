Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD6817AC95
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgCERV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:21:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbgCEROe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A99DB24654;
        Thu,  5 Mar 2020 17:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428474;
        bh=57I+7quQKDQmsEDDJITB3L2NMIr5sFzOXq0CxdhIvnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUuRd9GKlAEfk5asN8JlZUM3GguoNJftarQsTI4MFpO7cAq4g9P2BtR8vajHzx+wN
         YHvz6hsvtgldgyXJM8XGNhpfihVVw4vJcAWsZDoCpBdJAXtQBZ53yvLon9t+FLNQhi
         B0vnifldyGDEpJaIEr8rhFC8tV9lMHvu9nBSgYmY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Burton <paulburton@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/58] MIPS: Disable VDSO time functionality on microMIPS
Date:   Thu,  5 Mar 2020 12:13:32 -0500
Message-Id: <20200305171420.29595-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3fa4bbe1bae53..b6b1eb638fb14 100644
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


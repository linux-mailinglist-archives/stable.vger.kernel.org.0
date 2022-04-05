Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BCC4F2B0C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbiDEJDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237141AbiDEIRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B68FB0D08;
        Tue,  5 Apr 2022 01:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E544C61725;
        Tue,  5 Apr 2022 08:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4214C385A1;
        Tue,  5 Apr 2022 08:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145925;
        bh=JHETf6kArsf/97BPwP8PKkdh+DPkqOvTkbRkJV+dBFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDX9oglZ6e+1IdTn0mEIkRyYuoQeWfvydebxKqdqIGvTj3UlyIAruwM4EF3BM8DSd
         kb4h9As0tFfTS6HQdpkhRP7ANWgWh0SdeyMEB0aQfjQsnJrj2VwU9lxC+hMeGbRB0E
         OpJ157Sj1WP0gLN0t40PJf4B3NF3MhEFgpuIHTTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nemanja Rakovic <nemanja.rakovic@syrmia.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0578/1126] mips: Enable KCSAN
Date:   Tue,  5 Apr 2022 09:22:05 +0200
Message-Id: <20220405070424.598071434@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nemanja Rakovic <nemanja.rakovic@syrmia.com>

[ Upstream commit e0a8b93efa2382d370be44bf289157de7e5dacb4 ]

This patch enables KCSAN for the 64-bit version. Updated rules
for the incompatible compilation units (vdso, boot/compressed).

Signed-off-by: Nemanja Rakovic <nemanja.rakovic@syrmia.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig                  | 1 +
 arch/mips/boot/compressed/Makefile | 1 +
 arch/mips/vdso/Makefile            | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 058446f01487..651d4fe355da 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -101,6 +101,7 @@ config MIPS
 	select TRACE_IRQFLAGS_SUPPORT
 	select VIRT_TO_BUS
 	select ARCH_HAS_ELFCORE_COMPAT
+	select HAVE_ARCH_KCSAN if 64BIT
 
 config MIPS_FIXUP_BIGPHYS_ADDR
 	bool
diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index 5a15d51e8884..a35f78212ea9 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -38,6 +38,7 @@ KBUILD_AFLAGS := $(KBUILD_AFLAGS) -D__ASSEMBLY__ \
 KCOV_INSTRUMENT		:= n
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
+KASAN_SANITIZE			:= n
 
 # decompressor objects (linked with vmlinuz)
 vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o $(obj)/bswapsi.o
diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index d65f55f67e19..f72658b3a53f 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -1,6 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 # Objects to go into the VDSO.
 
+# Sanitizer runtimes are unavailable and cannot be linked here.
+ KCSAN_SANITIZE			:= n
+
 # Absolute relocation type $(ARCH_REL_TYPE_ABS) needs to be defined before
 # the inclusion of generic Makefile.
 ARCH_REL_TYPE_ABS := R_MIPS_JUMP_SLOT|R_MIPS_GLOB_DAT
-- 
2.34.1




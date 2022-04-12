Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4474FD560
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiDLHaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353137AbiDLHZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF964DF50;
        Tue, 12 Apr 2022 00:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6565160B2E;
        Tue, 12 Apr 2022 07:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7CEC385A1;
        Tue, 12 Apr 2022 07:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746809;
        bh=q3Kyt35+RyOWN4PHSNq70tj32/ShD76s9auqfXCFT48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toV0fQMqD3oylNtclKwS8nXtN46fceAKPVCCFA+cdq9JS4tEN0QYwB04aWDwChmSk
         RPnv1g8uy62SOQd5jgnAey1wQt4CpgyyR49onJ1ML4kRn/WYLbaNMEw7MQAHr7Lhsy
         L91RQL8nsKuxAjEash2sz8SGZCPDQXlORjUwUbK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 138/285] x86/Kconfig: Do not allow CONFIG_X86_X32_ABI=y with llvm-objcopy
Date:   Tue, 12 Apr 2022 08:29:55 +0200
Message-Id: <20220412062947.650788370@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit aaeed6ecc1253ce1463fa1aca0b70a4ccbc9fa75 ]

There are two outstanding issues with CONFIG_X86_X32_ABI and
llvm-objcopy, with similar root causes:

1. llvm-objcopy does not properly convert .note.gnu.property when going
   from x86_64 to x86_x32, resulting in a corrupted section when
   linking:

   https://github.com/ClangBuiltLinux/linux/issues/1141

2. llvm-objcopy produces corrupted compressed debug sections when going
   from x86_64 to x86_x32, also resulting in an error when linking:

   https://github.com/ClangBuiltLinux/linux/issues/514

After commit 41c5ef31ad71 ("x86/ibt: Base IBT bits"), the
.note.gnu.property section is always generated when
CONFIG_X86_KERNEL_IBT is enabled, which causes the first issue to become
visible with an allmodconfig build:

  ld.lld: error: arch/x86/entry/vdso/vclock_gettime-x32.o:(.note.gnu.property+0x1c): program property is too short

To avoid this error, do not allow CONFIG_X86_X32_ABI to be selected when
using llvm-objcopy. If the two issues ever get fixed in llvm-objcopy,
this can be turned into a feature check.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220314194842.3452-3-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5c2ccb85f2ef..d377d8af5a9f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2827,6 +2827,11 @@ config IA32_AOUT
 config X86_X32
 	bool "x32 ABI for 64-bit mode"
 	depends on X86_64
+	# llvm-objcopy does not convert x86_64 .note.gnu.property or
+	# compressed debug sections to x86_x32 properly:
+	# https://github.com/ClangBuiltLinux/linux/issues/514
+	# https://github.com/ClangBuiltLinux/linux/issues/1141
+	depends on $(success,$(OBJCOPY) --version | head -n1 | grep -qv llvm)
 	help
 	  Include code to run binaries for the x32 native 32-bit ABI
 	  for 64-bit processors.  An x32 process gets access to the
-- 
2.35.1




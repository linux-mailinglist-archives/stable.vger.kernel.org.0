Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63B36356DC
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbiKWJe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237910AbiKWJeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:34:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CB1112C7C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:32:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F89EB81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7934C433C1;
        Wed, 23 Nov 2022 09:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195943;
        bh=s+LaA2Wi8EUCX3BFfeokk0V07Q8RVJTayEln1EXQPvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZ2BckttNCPs/3PaM4DtyIVuRZJqVa0GwjZIN7wAic2Ew+uRQEtpLezrxbUS3zvQ3
         luqtvNh/waZyDplqvZmaRh/2aE1K1QFb2x5p+11DBmd4/BcZAcV3qnScQkFIxzvP5y
         dkY2WRoifgRlol8kZHPaPKsomjlBgp1i0YrTHnWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rongwei Zhang <pudh4418@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/181] MIPS: fix duplicate definitions for exported symbols
Date:   Wed, 23 Nov 2022 09:50:39 +0100
Message-Id: <20221123084605.641939929@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rongwei Zhang <pudh4418@gmail.com>

[ Upstream commit 612d80784fdc0c2e2ee2e2d901a55ef2f72ebf4b ]

Building with clang-14 fails with:

AS      arch/mips/kernel/relocate_kernel.o
<unknown>:0: error: symbol 'kexec_args' is already defined
<unknown>:0: error: symbol 'secondary_kexec_args' is already defined
<unknown>:0: error: symbol 'kexec_start_address' is already defined
<unknown>:0: error: symbol 'kexec_indirection_page' is already defined
<unknown>:0: error: symbol 'relocate_new_kernel_size' is already defined

It turns out EXPORT defined in asm/asm.h expands to a symbol definition,
so there is no need to define these symbols again. Remove duplicated
symbol definitions.

Fixes: 7aa1c8f47e7e ("MIPS: kdump: Add support")
Signed-off-by: Rongwei Zhang <pudh4418@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/relocate_kernel.S | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/mips/kernel/relocate_kernel.S b/arch/mips/kernel/relocate_kernel.S
index cfde14b48fd8..f5b2ef979b43 100644
--- a/arch/mips/kernel/relocate_kernel.S
+++ b/arch/mips/kernel/relocate_kernel.S
@@ -145,8 +145,7 @@ LEAF(kexec_smp_wait)
  * kexec_args[0..3] are used to prepare register values.
  */
 
-kexec_args:
-	EXPORT(kexec_args)
+EXPORT(kexec_args)
 arg0:	PTR_WD		0x0
 arg1:	PTR_WD		0x0
 arg2:	PTR_WD		0x0
@@ -159,8 +158,7 @@ arg3:	PTR_WD		0x0
  * their registers a0-a3. secondary_kexec_args[0..3] are used
  * to prepare register values.
  */
-secondary_kexec_args:
-	EXPORT(secondary_kexec_args)
+EXPORT(secondary_kexec_args)
 s_arg0: PTR_WD		0x0
 s_arg1: PTR_WD		0x0
 s_arg2: PTR_WD		0x0
@@ -171,19 +169,16 @@ kexec_flag:
 
 #endif
 
-kexec_start_address:
-	EXPORT(kexec_start_address)
+EXPORT(kexec_start_address)
 	PTR_WD		0x0
 	.size		kexec_start_address, PTRSIZE
 
-kexec_indirection_page:
-	EXPORT(kexec_indirection_page)
+EXPORT(kexec_indirection_page)
 	PTR_WD		0
 	.size		kexec_indirection_page, PTRSIZE
 
 relocate_new_kernel_end:
 
-relocate_new_kernel_size:
-	EXPORT(relocate_new_kernel_size)
+EXPORT(relocate_new_kernel_size)
 	PTR_WD		relocate_new_kernel_end - relocate_new_kernel
 	.size		relocate_new_kernel_size, PTRSIZE
-- 
2.35.1




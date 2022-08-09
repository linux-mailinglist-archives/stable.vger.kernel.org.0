Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B4A58DE3B
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345392AbiHISMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345987AbiHISMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:12:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA51A32C;
        Tue,  9 Aug 2022 11:05:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B87461139;
        Tue,  9 Aug 2022 18:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DCBC433B5;
        Tue,  9 Aug 2022 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068308;
        bh=Du+LfgidnyUZQYmLnNKvCIdplUELRrxtwIDyhwydf1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKqV7p74prUtXw2hybko4cx71BtsKc84SGD+8/EGR7ko4zmivNIt4lw6g0Tvi4ao3
         WVUpJhjtAA+PhVHHvCq0O2R8pzeT5kZPSnzMvPBocIm+Wnf6G5MjohD7fqy5gmdM1Q
         inptmYEcEmAPvEL+E+uHX/ycDoueEs9mbw5bmIJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 16/30] arm64: set UXN on swapper page tables
Date:   Tue,  9 Aug 2022 20:00:41 +0200
Message-Id: <20220809175514.891266119@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
References: <20220809175514.276643253@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

[ This issue was fixed upstream by accident in c3cee924bd85 ("arm64:
  head: cover entire kernel image in initial ID map") as part of a
  large refactoring of the arm64 boot flow. This simple fix is therefore
  preferred for -stable backporting ]

On a system that implements FEAT_EPAN, read/write access to the idmap
is denied because UXN is not set on the swapper PTEs. As a result,
idmap_kpti_install_ng_mappings panics the kernel when accessing
__idmap_kpti_flag. Fix it by setting UXN on these PTEs.

Fixes: 18107f8a2df6 ("arm64: Support execute-only permissions with Enhanced PAN")
Cc: <stable@vger.kernel.org> # 5.15
Link: https://linux-review.googlesource.com/id/Ic452fa4b4f74753e54f71e61027e7222a0fae1b1
Signed-off-by: Peter Collingbourne <pcc@google.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220719234909.1398992-1-pcc@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kernel-pgtable.h |    4 ++--
 arch/arm64/kernel/head.S                |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -103,8 +103,8 @@
 /*
  * Initial memory map attributes.
  */
-#define SWAPPER_PTE_FLAGS	(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED)
-#define SWAPPER_PMD_FLAGS	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S)
+#define SWAPPER_PTE_FLAGS	(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED | PTE_UXN)
+#define SWAPPER_PMD_FLAGS	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S | PMD_SECT_UXN)
 
 #if ARM64_KERNEL_USES_PMD_MAPS
 #define SWAPPER_MM_MMUFLAGS	(PMD_ATTRINDX(MT_NORMAL) | SWAPPER_PMD_FLAGS)
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -285,7 +285,7 @@ SYM_FUNC_START_LOCAL(__create_page_table
 	subs	x1, x1, #64
 	b.ne	1b
 
-	mov	x7, SWAPPER_MM_MMUFLAGS
+	mov_q	x7, SWAPPER_MM_MMUFLAGS
 
 	/*
 	 * Create the identity mapping.



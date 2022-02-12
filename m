Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6E54B3408
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 10:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbiBLJ1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 04:27:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiBLJ1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 04:27:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5815A2655A
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 01:27:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7E8F60B43
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 09:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F1CC340EB;
        Sat, 12 Feb 2022 09:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644658064;
        bh=VwCmHRxdIcYFbHO8SAUvHJVwfxwN7gGmUzfnSeIM53o=;
        h=Subject:To:Cc:From:Date:From;
        b=USR0MEltWU86cywbaC3EiWI8SqXdfmxB9zz8I7MiXhslbRAxZ9pkS0TYAOUjMMziW
         1YQLdyVwtlDyfzkZX4E3wLUXnnCHL9dwpLUY6DWHIB/NgcyZIKjZoCFajrMw6GvlqJ
         qTHTDTq1av4NMpEPOS91f2nBi6zaHDiZeGFTrFPI=
Subject: FAILED: patch "[PATCH] riscv/mm: Add XIP_FIXUP for riscv_pfn_base" failed to apply to 5.16-stable tree
To:     palmer@rivosinc.com, gatecat@ds0.me
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Feb 2022 10:27:41 +0100
Message-ID: <1644658061145163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca0cb9a60f6d86d4b2139c6f393a78f39edcd7cb Mon Sep 17 00:00:00 2001
From: Palmer Dabbelt <palmer@rivosinc.com>
Date: Fri, 4 Feb 2022 13:14:08 -0800
Subject: [PATCH] riscv/mm: Add XIP_FIXUP for riscv_pfn_base

This manifests as a crash early in boot on VexRiscv.

Signed-off-by: Myrtle Shah <gatecat@ds0.me>
[Palmer: split commit]
Fixes: 44c922572952 ("RISC-V: enable XIP")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index eecfacac2cc5..c27294128e18 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -232,6 +232,7 @@ static pmd_t __maybe_unused early_dtb_pmd[PTRS_PER_PMD] __initdata __aligned(PAG
 
 #ifdef CONFIG_XIP_KERNEL
 #define pt_ops			(*(struct pt_alloc_ops *)XIP_FIXUP(&pt_ops))
+#define riscv_pfn_base         (*(unsigned long  *)XIP_FIXUP(&riscv_pfn_base))
 #define trampoline_pg_dir      ((pgd_t *)XIP_FIXUP(trampoline_pg_dir))
 #define fixmap_pte             ((pte_t *)XIP_FIXUP(fixmap_pte))
 #define early_pg_dir           ((pgd_t *)XIP_FIXUP(early_pg_dir))


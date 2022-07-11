Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5664356FD46
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiGKJx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbiGKJxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:53:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F52ADD58;
        Mon, 11 Jul 2022 02:25:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53C35B80E89;
        Mon, 11 Jul 2022 09:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA916C34115;
        Mon, 11 Jul 2022 09:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531524;
        bh=WMMimb6oH2aQKjY001SDEoyVxYdl3PN4VWbitUA/0lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FT0DUt0Yv7LmDfgA3IsstQqQJBOUeeNsGm/q7Nay9zxUNILv0nbDc/4mpHMYmMZ64
         0kX5tcd70dVw9WbDcAEfQAnRTOuCw9znNg8ovzc3d3HSB1GLU+0JRdRIAb5fDwDILP
         fjNOVombmeQHgO6swYST0lzZqEsmjOOf9ci3dNOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Myrtle Shah <gatecat@ds0.me>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/230] riscv/mm: Add XIP_FIXUP for riscv_pfn_base
Date:   Mon, 11 Jul 2022 11:05:52 +0200
Message-Id: <20220711090606.793876247@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit ca0cb9a60f6d86d4b2139c6f393a78f39edcd7cb ]

This manifests as a crash early in boot on VexRiscv.

Signed-off-by: Myrtle Shah <gatecat@ds0.me>
[Palmer: split commit]
Fixes: 44c922572952 ("RISC-V: enable XIP")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 7f130ac3b9f9..c58a7c77989b 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -265,6 +265,7 @@ pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
 static pmd_t __maybe_unused early_dtb_pmd[PTRS_PER_PMD] __initdata __aligned(PAGE_SIZE);
 
 #ifdef CONFIG_XIP_KERNEL
+#define riscv_pfn_base         (*(unsigned long  *)XIP_FIXUP(&riscv_pfn_base))
 #define trampoline_pg_dir      ((pgd_t *)XIP_FIXUP(trampoline_pg_dir))
 #define fixmap_pte             ((pte_t *)XIP_FIXUP(fixmap_pte))
 #define early_pg_dir           ((pgd_t *)XIP_FIXUP(early_pg_dir))
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E396158B6
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiKBC5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiKBC5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:57:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827FB2251C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:57:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2014D617D0
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB09C433C1;
        Wed,  2 Nov 2022 02:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357830;
        bh=u80g+fW4XlpYj3oS7L/JqPYcpuAhjIGvzeXfRrCxzD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oI23VgXwXmZ7kHy/EVZc50UEi8KkZiVskOHEGWS/KCRQgR17LbN+gcQ8M3ktt4Swn
         2qdK6IdZ2JxdPwPWokMvWj7w+0/9d6fluZzaF0ZKvIY7v2fIJp2b57uBtnj58AS38i
         TH+5EdQ+I/8o6ZDzTW0zZYUFPaUPVSS5WjbZs6oU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qinglin Pan <panqinglin2020@iscas.ac.cn>,
        Atish Patra <atishp@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 236/240] riscv: mm: add missing memcpy in kasan_init
Date:   Wed,  2 Nov 2022 03:33:31 +0100
Message-Id: <20221102022116.741944321@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglin Pan <panqinglin2020@iscas.ac.cn>

[ Upstream commit 9f2ac64d6ca60db99132e08628ac2899f956a0ec ]

Hi Atish,

It seems that the panic is due to the missing memcpy during kasan_init.
Could you please check whether this patch is helpful?

When doing kasan_populate, the new allocated base_pud/base_p4d should
contain kasan_early_shadow_{pud, p4d}'s content. Add the missing memcpy
to avoid page fault when read/write kasan shadow region.

Tested on:
 - qemu with sv57 and CONFIG_KASAN on.
 - qemu with sv48 and CONFIG_KASAN on.

Signed-off-by: Qinglin Pan <panqinglin2020@iscas.ac.cn>
Tested-by: Atish Patra <atishp@rivosinc.com>
Fixes: 8fbdccd2b173 ("riscv: mm: Support kasan for sv57")
Link: https://lore.kernel.org/r/20221009083050.3814850-1-panqinglin2020@iscas.ac.cn
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/kasan_init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index a22e418dbd82..e1226709490f 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -113,6 +113,8 @@ static void __init kasan_populate_pud(pgd_t *pgd,
 		base_pud = pt_ops.get_pud_virt(pfn_to_phys(_pgd_pfn(*pgd)));
 	} else if (pgd_none(*pgd)) {
 		base_pud = memblock_alloc(PTRS_PER_PUD * sizeof(pud_t), PAGE_SIZE);
+		memcpy(base_pud, (void *)kasan_early_shadow_pud,
+			sizeof(pud_t) * PTRS_PER_PUD);
 	} else {
 		base_pud = (pud_t *)pgd_page_vaddr(*pgd);
 		if (base_pud == lm_alias(kasan_early_shadow_pud)) {
@@ -173,8 +175,11 @@ static void __init kasan_populate_p4d(pgd_t *pgd,
 		base_p4d = pt_ops.get_p4d_virt(pfn_to_phys(_pgd_pfn(*pgd)));
 	} else {
 		base_p4d = (p4d_t *)pgd_page_vaddr(*pgd);
-		if (base_p4d == lm_alias(kasan_early_shadow_p4d))
+		if (base_p4d == lm_alias(kasan_early_shadow_p4d)) {
 			base_p4d = memblock_alloc(PTRS_PER_PUD * sizeof(p4d_t), PAGE_SIZE);
+			memcpy(base_p4d, (void *)kasan_early_shadow_p4d,
+				sizeof(p4d_t) * PTRS_PER_P4D);
+		}
 	}
 
 	p4dp = base_p4d + p4d_index(vaddr);
-- 
2.35.1




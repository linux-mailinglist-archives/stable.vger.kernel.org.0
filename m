Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828AC60ACD1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiJXOQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbiJXOP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:15:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCD35073D;
        Mon, 24 Oct 2022 05:55:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D21E1B818E2;
        Mon, 24 Oct 2022 12:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C4FC433C1;
        Mon, 24 Oct 2022 12:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615156;
        bh=00HXMAn+/r8CSZi6lXNpibBGKfp4GOr5lj0UEYdGDG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q78RqW1UY05WfjkPV1NsbWQnV5ujfCsTxOm7K7QHJaDu+Um8Z0Z1nna03lWgT9F8p
         HX2qbJqZX57lnSTEN4k3i9WJQkdPkJVC+5W1iuasD7GnReyHDEOfXb2hyppEHDtIaZ
         h2dH4b/yxRVaARyEF9tc0uDoJerYdiR9n4jWenl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/530] ARM: 9247/1: mm: set readonly for MT_MEMORY_RO with ARM_LPAE
Date:   Mon, 24 Oct 2022 13:28:08 +0200
Message-Id: <20221024113051.591241125@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Kefeng <wangkefeng.wang@huawei.com>

[ Upstream commit 14ca1a4690750bb54e1049e49f3140ef48958a6e ]

MT_MEMORY_RO is introduced by commit 598f0a99fa8a ("ARM: 9210/1:
Mark the FDT_FIXED sections as shareable"), which is a readonly
memory type for FDT area, but there are some different between
ARM_LPAE and non-ARM_LPAE, we need to setup PMD_SECT_AP2 and
L_PMD_SECT_RDONLY for MT_MEMORY_RO when ARM_LAPE enabled.

non-ARM_LPAE	0xff800000-0xffa00000           2M PGD KERNEL      ro NX SHD
ARM_LPAE	0xff800000-0xffc00000           4M PMD RW NX SHD
ARM_LPAE+fix	0xff800000-0xffc00000           4M PMD ro NX SHD

Fixes: 598f0a99fa8a ("ARM: 9210/1: Mark the FDT_FIXED sections as shareable")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index cd17e324aa51..83a91e0ab848 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -300,7 +300,11 @@ static struct mem_type mem_types[] __ro_after_init = {
 		.prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY |
 			     L_PTE_XN | L_PTE_RDONLY,
 		.prot_l1   = PMD_TYPE_TABLE,
+#ifdef CONFIG_ARM_LPAE
+		.prot_sect = PMD_TYPE_SECT | L_PMD_SECT_RDONLY | PMD_SECT_AP2,
+#else
 		.prot_sect = PMD_TYPE_SECT,
+#endif
 		.domain    = DOMAIN_KERNEL,
 	},
 	[MT_ROM] = {
-- 
2.35.1




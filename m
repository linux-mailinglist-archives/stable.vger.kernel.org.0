Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BA3603CD0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiJSIwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiJSIv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:51:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDDB6472;
        Wed, 19 Oct 2022 01:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66854617E9;
        Wed, 19 Oct 2022 08:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E989C433D6;
        Wed, 19 Oct 2022 08:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169271;
        bh=mPyvoOxtu2z1TDELo2nST18RRq1LpFrHYrqoyOU5/Cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PixV2v6e7kg4xrQ4lxktqT0nWjfn6WT+hCtqFXDbl1rKE+Gkah9UmYMn3d7eb9QfP
         E/udk5lxUWRMxXpZjjU1QzFN0abEnsZtW+/nOwKRUDrK0Gk2yyRwUugBiULI3/v/CT
         BS2ZN6AfK+rvBJrtPy//ltwM9dz5JQ+gCjAPS7q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 216/862] ARM: 9247/1: mm: set readonly for MT_MEMORY_RO with ARM_LPAE
Date:   Wed, 19 Oct 2022 10:25:03 +0200
Message-Id: <20221019083259.575544616@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index a49f0b9c0f75..463fc2a8448f 100644
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




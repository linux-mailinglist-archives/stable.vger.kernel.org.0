Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A804E5924B2
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242398AbiHNQeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242528AbiHNQce (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:32:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A36DF72;
        Sun, 14 Aug 2022 09:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 025DB60C98;
        Sun, 14 Aug 2022 16:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EC9C433D6;
        Sun, 14 Aug 2022 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494430;
        bh=OTSD7ywY2HK6ow9eX5qqDkg99TBGdb+FkpGHMngwSc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MS773w8c+SB+RjdbcvMGDmT5IRtOSEqVPc+ciuFXbkiMNcMgg/PFdTcuhVOjp1dHc
         iFwqMU5l5K3cPy5boD4iRB8QWZbVNRAnMfb8xdyA9WfjUakT1UOTLJCAATWDEZ6JfG
         3on5mPrIlrzMnj5MgCYM3sTQsfKbtpBbKVLP7dxO+FIMOC88LrzroCWvScyKhF6YJf
         lS3NgP8Xy9JcllzUyXb4pYJ2nUXFdjXADKV7zboq+ZndedsZskR+HaXI6n/WHshdkv
         jXreSi0VrEOAYM1Drc74ARiJrNyD9RXA24C6vXTC6arDYx60pOnkWR6T9fadP1t1j0
         Y5iqibDeMf/qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
        rppt@kernel.org, kvalo@kernel.org, tglx@linutronix.de,
        christophe.leroy@csgroup.eu, nick.child@ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 18/28] powerpc/ioda/iommu/debugfs: Generate unique debugfs entries
Date:   Sun, 14 Aug 2022 12:25:58 -0400
Message-Id: <20220814162610.2397644-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162610.2397644-1-sashal@kernel.org>
References: <20220814162610.2397644-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit d73b46c3c1449bf27f793b9d9ee86ed70c7a7163 ]

The iommu_table::it_index is a LIOBN which is not initialized on PowerNV
as it is not used except IOMMU debugfs where it is used for a node name.

This initializes it_index witn a unique number to avoid warnings and
have a node for every iommu_table.

This should not cause any behavioral change without CONFIG_IOMMU_DEBUGFS.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220714080800.3712998-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 3dd35c327d1c..624822a81019 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1618,6 +1618,7 @@ static void pnv_pci_ioda1_setup_dma_pe(struct pnv_phb *phb,
 	tbl->it_ops = &pnv_ioda1_iommu_ops;
 	pe->table_group.tce32_start = tbl->it_offset << tbl->it_page_shift;
 	pe->table_group.tce32_size = tbl->it_size << tbl->it_page_shift;
+	tbl->it_index = (phb->hose->global_number << 16) | pe->pe_number;
 	if (!iommu_init_table(tbl, phb->hose->node, 0, 0))
 		panic("Failed to initialize iommu table");
 
@@ -1788,6 +1789,7 @@ static long pnv_pci_ioda2_setup_default_config(struct pnv_ioda_pe *pe)
 		res_end = min(window_size, SZ_4G) >> tbl->it_page_shift;
 	}
 
+	tbl->it_index = (pe->phb->hose->global_number << 16) | pe->pe_number;
 	if (iommu_init_table(tbl, pe->phb->hose->node, res_start, res_end))
 		rc = pnv_pci_ioda2_set_window(&pe->table_group, 0, tbl);
 	else
-- 
2.35.1


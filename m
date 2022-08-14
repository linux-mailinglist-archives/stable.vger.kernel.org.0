Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E47592237
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241406AbiHNPpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241426AbiHNPoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:44:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515075580;
        Sun, 14 Aug 2022 08:33:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFAE0B80B43;
        Sun, 14 Aug 2022 15:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CE1C433D7;
        Sun, 14 Aug 2022 15:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491235;
        bh=DDjUZxl2V2JdEZSkI5b5kOsibxbKLbbmvroI1QTDkPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSfDl37CbG8hqu6lLLsUWUCNmclu6537Mf1+3MBWUy+wWmSREZNlxe7dHtnrBbBNJ
         PHAsgUTG/ifqH5i+Prnqd1i13Lem9HQH1RtFvQKrb+ryFIMLlDHfXOrFiEALPPiVvT
         h4c2hvGdgPiOWO6IEzLEiOLNPy66X+Zymrcrubd76PxWd82i/9JPcyRxDrCVpXbJw0
         mks8vNrr+3OKPJUzJVVssS0LUGqV8195ZkUFe4czl+bcg7TRk08n6FjtueJkranx00
         aC6VYXI1JIL5W1PVlkSm0fpsa1YpRZUV5MFQnJ/g7HCdC50hGECGaZRz4bBp7qPDJP
         eEPyn7gggKg2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 30/46] PCI/ACPI: Guard ARM64-specific mcfg_quirks
Date:   Sun, 14 Aug 2022 11:32:31 -0400
Message-Id: <20220814153247.2378312-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 40a6cc141b4b9580de140bcb3e893445708acc5d ]

Guard ARM64-specific quirks with CONFIG_ARM64 to avoid build errors,
since mcfg_quirks will be shared by more than one architectures.

Link: https://lore.kernel.org/r/20220714124216.1489304-2-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_mcfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/pci_mcfg.c b/drivers/acpi/pci_mcfg.c
index 53cab975f612..63b98eae5e75 100644
--- a/drivers/acpi/pci_mcfg.c
+++ b/drivers/acpi/pci_mcfg.c
@@ -41,6 +41,8 @@ struct mcfg_fixup {
 static struct mcfg_fixup mcfg_quirks[] = {
 /*	{ OEM_ID, OEM_TABLE_ID, REV, SEGMENT, BUS_RANGE, ops, cfgres }, */
 
+#ifdef CONFIG_ARM64
+
 #define AL_ECAM(table_id, rev, seg, ops) \
 	{ "AMAZON", table_id, rev, seg, MCFG_BUS_ANY, ops }
 
@@ -169,6 +171,7 @@ static struct mcfg_fixup mcfg_quirks[] = {
 	ALTRA_ECAM_QUIRK(1, 13),
 	ALTRA_ECAM_QUIRK(1, 14),
 	ALTRA_ECAM_QUIRK(1, 15),
+#endif /* ARM64 */
 };
 
 static char mcfg_oem_id[ACPI_OEM_ID_SIZE];
-- 
2.35.1


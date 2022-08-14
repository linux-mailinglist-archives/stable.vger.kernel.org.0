Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7654D5920D9
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiHNPbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiHNPbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:31:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9A0BE13;
        Sun, 14 Aug 2022 08:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9C00B80B77;
        Sun, 14 Aug 2022 15:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBB6C433D6;
        Sun, 14 Aug 2022 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490975;
        bh=DDjUZxl2V2JdEZSkI5b5kOsibxbKLbbmvroI1QTDkPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGRStyQ1KCFA4tQD0fgBWn+y8drlREG0XcM9W4oahX73QQqwPkfXJYsMIQgpqwRSf
         TCIVnsXbutPdmenj0Ef0pK/3cazgOlxuc0mp9CNwxRT1v0uRrPfdzoWEHf35nr5P8P
         l5u/UMNqJoLUXHIcoDYQnrobYV8lP1D5LJK3NLckHC2y6Vhxq6cBzGrIvT1keVwdW1
         vC4NdIhbAQAWi1UXqonZo/mrF8sw9SAcqr8r2MQ6we69F7aGt1ccxumt7BXn++ew4o
         z/IDRtXqpO0u3Xy+YjBFCoDoz3D8cT+SLVsTmQSBaF3fcdKGJQlNFFcTLcKyC+QXZC
         d72tZV18PbZkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 41/64] PCI/ACPI: Guard ARM64-specific mcfg_quirks
Date:   Sun, 14 Aug 2022 11:24:14 -0400
Message-Id: <20220814152437.2374207-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
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


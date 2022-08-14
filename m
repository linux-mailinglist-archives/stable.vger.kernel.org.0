Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D602592284
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241507AbiHNPru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241957AbiHNPqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:46:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1291C914;
        Sun, 14 Aug 2022 08:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 474B2B80B83;
        Sun, 14 Aug 2022 15:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADDDC433C1;
        Sun, 14 Aug 2022 15:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491310;
        bh=YN7hsJzAs5oj+GODhyYpaGyRXv7Zw0L+eTzt7H41l3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmJQaC4uOH44yHVwbwPv9I29VK8xNOxg5IvoufaGmIkUSB6yLaG9Q5U5j/tM0AP9+
         QwSdbochadW0+EEv/UTClDgqW6kTnVk2kx2M5JqV1ubTEbaZRgvIllxPZ7oGegcdOl
         r6SKhb5a3Cvp6Vk3pEAVPP8mU2/4swrkG1T0ps1NXp1//uC5iiDgtPuTRqJh2VpeF9
         701e/RVGO2lyk8FhYcHmIejb7pWy5uLikxxwYiXWA4UVASG7XXUaBoWuy33e5PWX32
         YCJF7MAq0goM55b4VEllHN9XxjcOybeoi6mMkqcUbNz1KdB8ETEA6QbVXRmoep4Lc3
         YEiWRXlmH7fmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/31] PCI/ACPI: Guard ARM64-specific mcfg_quirks
Date:   Sun, 14 Aug 2022 11:34:20 -0400
Message-Id: <20220814153431.2379231-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153431.2379231-1-sashal@kernel.org>
References: <20220814153431.2379231-1-sashal@kernel.org>
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
index 95f23acd5b80..2709ef2b0351 100644
--- a/drivers/acpi/pci_mcfg.c
+++ b/drivers/acpi/pci_mcfg.c
@@ -41,6 +41,8 @@ struct mcfg_fixup {
 static struct mcfg_fixup mcfg_quirks[] = {
 /*	{ OEM_ID, OEM_TABLE_ID, REV, SEGMENT, BUS_RANGE, ops, cfgres }, */
 
+#ifdef CONFIG_ARM64
+
 #define AL_ECAM(table_id, rev, seg, ops) \
 	{ "AMAZON", table_id, rev, seg, MCFG_BUS_ANY, ops }
 
@@ -162,6 +164,7 @@ static struct mcfg_fixup mcfg_quirks[] = {
 	ALTRA_ECAM_QUIRK(1, 13),
 	ALTRA_ECAM_QUIRK(1, 14),
 	ALTRA_ECAM_QUIRK(1, 15),
+#endif /* ARM64 */
 };
 
 static char mcfg_oem_id[ACPI_OEM_ID_SIZE];
-- 
2.35.1


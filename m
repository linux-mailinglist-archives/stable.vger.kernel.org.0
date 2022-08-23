Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBEE59E33D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244107AbiHWMRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376311AbiHWMQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:16:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823599925B;
        Tue, 23 Aug 2022 02:41:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93B7861460;
        Tue, 23 Aug 2022 09:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B046C433D7;
        Tue, 23 Aug 2022 09:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247708;
        bh=YN7hsJzAs5oj+GODhyYpaGyRXv7Zw0L+eTzt7H41l3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyx9I8rfCdexyn9CuMu4sTSKZlmySn/ELG4TJKnD57yYjHf2cdat4AIhqSGvNg0W6
         lNp5MST0V6sRt8elBHsoILF9g1uq5WQ1uhjYrhRJHNtk4gWerWbVHgDFRNL4/Bkkdu
         Atm3RwmoJsXEpoqsvbgn8Yfk0znJp2iS1chezWv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhuacai@loongson.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/158] PCI/ACPI: Guard ARM64-specific mcfg_quirks
Date:   Tue, 23 Aug 2022 10:27:33 +0200
Message-Id: <20220823080050.795112958@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




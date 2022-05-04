Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E381351A9AC
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356488AbiEDRSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357426AbiEDRPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2591654BE9
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1AF3618E8
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2840CC385B0;
        Wed,  4 May 2022 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683513;
        bh=WV9yVpFHA7IrmDHjvJ1jLDIgWAIpziFFJhRpGHLg5lE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8R1IQcQICC8dUs+gahGALfK252B8ryCj+o/3Xez4b2+02fvU1dikMc9of3b38OrC
         9dTt0ODIYBnmPbTkkZX+9racc3GVd2AWdpNooIEobFgeNiqGujSNOngURgDO5wubbC
         OuEc8tln1uhDxw7ETpeLkc9C5F6+pVd7ZcPc8xjC5g56BCAyc/S9h/DyrURqdjHD/s
         LqFTBWqVoelIkxSC6g3EW1MDJLVN2t5G1tv57E7PCWV59liF/xV/qTHkGnxakELUwf
         fGMBxasjlmLRLinhsu5k8FWZ3+EdM91rOx9kDL6LTkV1q+VG1OFInn0/gqh0UCMwfV
         3bhQRfEAhlVDA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 21/30] PCI: aardvark: Enable MSI-X support
Date:   Wed,  4 May 2022 18:57:46 +0200
Message-Id: <20220504165755.30002-22-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
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

From: Pali Rohár <pali@kernel.org>

commit 754e449889b22fc3c34235e8836f08f51121d307 upstream.

According to PCI 3.0 specification, sending both MSI and MSI-X interrupts
is done by DWORD memory write operation to doorbell message address. The
write operation for MSI has zero upper 16 bits and the MSI interrupt number
in the lower 16 bits, while the write operation for MSI-X contains a 32-bit
value from MSI-X table.

Since the driver only uses interrupt numbers from range 0..31, the upper
16 bits of the DWORD memory write operation to doorbell message address
are zero even for MSI-X interrupts. Thus we can enable MSI-X interrupts.

Testing proves that kernel can correctly receive MSI-X interrupts from PCIe
cards which supports both MSI and MSI-X interrupts.

Link: https://lore.kernel.org/r/20220110015018.26359-13-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 43f79cbf9027..4cc88fa66979 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1339,7 +1339,7 @@ static struct irq_chip advk_msi_irq_chip = {
 
 static struct msi_domain_info advk_msi_domain_info = {
 	.flags	= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
-		  MSI_FLAG_MULTI_PCI_MSI,
+		  MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX,
 	.chip	= &advk_msi_irq_chip,
 };
 
-- 
2.35.1


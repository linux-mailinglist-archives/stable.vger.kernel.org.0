Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28CC4F444A
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349851AbiDEMH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358053AbiDEK15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE5840E4D;
        Tue,  5 Apr 2022 03:14:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FA0EB81BC5;
        Tue,  5 Apr 2022 10:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EDBC385A1;
        Tue,  5 Apr 2022 10:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153637;
        bh=SweP1HTw8tC+AtVVhlyi/ss/sL+iGct34bnHaSMvRHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iT+jUPl4EVNtAL0ANY4apqvL6qm8Et/vCc+kabD+psK/8sPdHH6JmF+iCvbstUDVX
         PLNwkvYaTvu0BcvaOq2TZB3gIMBw+SnHC9MEna/cM+cdccxNGI7DRicQBYqs49Cd5h
         GNj8ggIHV103mxg4WadmfvSEMtEymSHMWiWtBodI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/599] PCI: aardvark: Fix reading PCI_EXP_RTSTA_PME bit on emulated bridge
Date:   Tue,  5 Apr 2022 09:29:48 +0200
Message-Id: <20220405070307.582647954@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 735f5ae49e1b44742cc63ca9b5c1ffde3e94ba91 ]

The emulated bridge returns incorrect value for PCI_EXP_RTSTA register
during readout in advk_pci_bridge_emul_pcie_conf_read() function: the
correct bit is BIT(16), but we are setting BIT(23), because the code
does
  *value = (isr0 & PCIE_MSG_PM_PME_MASK) << 16
where
  PCIE_MSG_PM_PME_MASK
is
  BIT(7).

The code should probably have been something like
  *value = (!!(isr0 & PCIE_MSG_PM_PME_MASK)) << 16,
but we are better of using an if() and using the proper macro for this
bit.

Link: https://lore.kernel.org/r/20220110015018.26359-15-kabel@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index f30144c8c0bd..49ff8bf10c74 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -851,7 +851,9 @@ advk_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 	case PCI_EXP_RTSTA: {
 		u32 isr0 = advk_readl(pcie, PCIE_ISR0_REG);
 		u32 msglog = advk_readl(pcie, PCIE_MSG_LOG_REG);
-		*value = (isr0 & PCIE_MSG_PM_PME_MASK) << 16 | (msglog >> 16);
+		*value = msglog >> 16;
+		if (isr0 & PCIE_MSG_PM_PME_MASK)
+			*value |= PCI_EXP_RTSTA_PME;
 		return PCI_BRIDGE_EMUL_HANDLED;
 	}
 
-- 
2.34.1




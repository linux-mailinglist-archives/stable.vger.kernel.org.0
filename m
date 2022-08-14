Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0508659231E
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242117AbiHNPxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241760AbiHNPtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:49:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E8511161;
        Sun, 14 Aug 2022 08:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F574B80B27;
        Sun, 14 Aug 2022 15:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AF0C433C1;
        Sun, 14 Aug 2022 15:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491333;
        bh=s9lab+a5xifcAa284CeV2WZkDk2Ia40oFHO0Pen9x6Y=;
        h=From:To:Cc:Subject:Date:From;
        b=OSkKEbbEPw4LPJxlDfumdO1ei5aP1uPksIRhb1gCwsH1VQdtDr94BCrxB1WdMBL6V
         ZKamc9DmI3H2cQ91xdryoP2DcSJVRxFNiG+p5u/HRp8REptR7aCX9Df2AJThIqk5t+
         GbmAK9ovAg3ED/2sif/AUrk0Egt1aSvkmj8k0YhThbGAxYl7Xg3s5c2JiuJTROaFan
         FF6F3H2fbgmM0dVTu+K6S0cio0WEb8eLCKNg1zgkJjX139yYCH5PeL3UGxdwKrVdN4
         AIm1iXk88wZDYIzbewcPj08xsSMVcfZKoNEb/ZUklSxGR9PLzt2QAEqIG37nbokSDa
         KoJewzWZ8bxgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/21] PCI: Add ACS quirk for Broadcom BCM5750x NICs
Date:   Sun, 14 Aug 2022 11:35:11 -0400
Message-Id: <20220814153531.2379705-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit afd306a65cedb9589564bdb23a0c368abc4215fd ]

The Broadcom BCM5750x NICs may be multi-function devices.  They do not
advertise ACS capability. Peer-to-peer transactions are not possible
between the individual functions, so it is safe to treat them as fully
isolated.

Add an ACS quirk for these devices so the functions can be in independent
IOMMU groups and attached individually to userspace applications using
VFIO.

Link: https://lore.kernel.org/r/1654796507-28610-1-git-send-email-michael.chan@broadcom.com
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 2a4bc8df8563..8b98b7f3eb24 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4943,6 +4943,9 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_AMPERE, 0xE00C, pci_quirk_xgene_acs },
 	/* Broadcom multi-function device */
 	{ PCI_VENDOR_ID_BROADCOM, 0x16D7, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1750, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1751, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1752, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	/* Amazon Annapurna Labs */
 	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E6759212E
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbiHNPed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240725AbiHNPd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:33:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B2ECE10;
        Sun, 14 Aug 2022 08:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33BB060C58;
        Sun, 14 Aug 2022 15:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03B7C4314F;
        Sun, 14 Aug 2022 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491031;
        bh=XoTiZoUVZX4pd9WYhnysuZkslFJxFicRZdPAq2tGTyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZP5DIMF4ztMuXq7NNtZnygVTcNhv9dIw3jROlvb4F7Jpt5OgGHzY0kSnyEiy6bB6W
         rjMPLt0YBaDkxEtuYD4jD4VCwmeN+D6ZOFhos48h60PPUFlhxXHv3TTbLgY4ZKrHay
         beWVJrF+76sV4QZj/z/FDJwQ2HOL3T2CxG8hgCpjkkSl7EAbiWBqd8rtEPgV/p+MZL
         l5PV7Qpq9MnvanuKMgWWUUSJID2rokKjFj7kerM+OMnUvxlvyWaPjG59BL+Xs8okKf
         Kmq4e/pawJJFL2bmVE5KGTYCSnr2FcxFRH55yghLLic5O5AUSJ24VQucumfqex/dCK
         ZZWTcp4gKuUhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 03/56] PCI: Add ACS quirk for Broadcom BCM5750x NICs
Date:   Sun, 14 Aug 2022 11:29:33 -0400
Message-Id: <20220814153026.2377377-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
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
index 41aeaa235132..2e68f50bc7ae 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4924,6 +4924,9 @@ static const struct pci_dev_acs_enabled {
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71FE959E168
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356513AbiHWK5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244111AbiHWKy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:54:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8139B17E2F;
        Tue, 23 Aug 2022 02:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34EE661122;
        Tue, 23 Aug 2022 09:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB0AC433D6;
        Tue, 23 Aug 2022 09:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246003;
        bh=ort/3hcnaukUGsA7LDhSiF203JxpCct0qeqwR3Ahero=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiSsDGSV/ymZkzbsv3zM6+xdylYAt0w2pVemV64C3xoKhqnPQOw95UaT0N9BhjY5o
         QcmWRBkTIA2zLJkJ2vPVtBe34syyujuAcvaDxqrAxS63t9Obd1jmxbLHhS/9U3CxJj
         Hq5zgiMg5gpDvdolPikJhjt9StawQSwhIGyvM+nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 258/287] PCI: Add ACS quirk for Broadcom BCM5750x NICs
Date:   Tue, 23 Aug 2022 10:27:07 +0200
Message-Id: <20220823080109.963872987@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index 7cd38c9eaa02..f494e76faaa0 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4799,6 +4799,9 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_AMPERE, 0xE00C, pci_quirk_xgene_acs },
 	/* Broadcom multi-function device */
 	{ PCI_VENDOR_ID_BROADCOM, 0x16D7, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1750, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1751, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1752, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	{ 0 }
 };
-- 
2.35.1




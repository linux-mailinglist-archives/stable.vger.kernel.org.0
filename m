Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6F75922B9
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbiHNPwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242027AbiHNPu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1679AB4B5;
        Sun, 14 Aug 2022 08:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B951EB80B43;
        Sun, 14 Aug 2022 15:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABCEC433C1;
        Sun, 14 Aug 2022 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491399;
        bh=CZzuY3a27j4F+CBOVWD7MeVGBQoD3tKsr9GhoUeeke8=;
        h=From:To:Cc:Subject:Date:From;
        b=kyfe7Dz+QpJbK7nAV4PR0WajqPWm/7irEtEO1s3QdKakGqwhxC79bN3ytvtoQ1XyY
         LVjzk19MmOBvAbRXvpp9sb+zrv/o4pr9hrkGlegkBuUGCUiQHmTuocAWInXJnmpEvD
         e789Hj8vjaieIYis0JPeB9DlFNkvjaiIpwkCDea6NVzZDV9e+0zIFLxXLUZbtSC6jn
         9rlDqmspEUfBY5O7W6tvMMSV4MDvEvC70nUdSGw2SYYx1YlEvorO4YxmUnVTooiN1z
         s0pL6nmCukDVIW1PWvwjTWfpz04m0e/LqJi432BaK7ltaHoirgySpak88y2LIVm9IK
         4JQG3K74pPp5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/9] PCI: Add ACS quirk for Broadcom BCM5750x NICs
Date:   Sun, 14 Aug 2022 11:36:28 -0400
Message-Id: <20220814153637.2380406-1-sashal@kernel.org>
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
index 98327966e5b4..0a116359b5c7 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4760,6 +4760,9 @@ static const struct pci_dev_acs_enabled {
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


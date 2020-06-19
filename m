Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6FE20153A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390938AbgFSQTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389657AbgFSPBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:01:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A60920734;
        Fri, 19 Jun 2020 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578905;
        bh=Bavk9QbyY+cBR5Q37haU6BSR4Badx9cgk1Oa4nFKzzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKjFqojThTZMkGaJ7VH3CnOgSN6weQMU8a72zKzvs8vzpzPuEZBr9CzpP6Z5vj9Tp
         M/NCLtYXLYCOLBMb9Vac/uIbsgoiOPv4IXn1cbUBdZocSwCPaSvw56RM5qbgJRJ02m
         DqzGyG3PeRGK7JcVYZ4lQBYi/GP0K2fxfCoAmpM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhinav Ratna <abhinav.ratna@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/267] PCI: Add ACS quirk for iProc PAXB
Date:   Fri, 19 Jun 2020 16:33:07 +0200
Message-Id: <20200619141658.429157336@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhinav Ratna <abhinav.ratna@broadcom.com>

[ Upstream commit 46b2c32df7a462d0e64b68c513e5c4c1b2a399a7 ]

iProc PAXB Root Ports don't advertise an ACS capability, but they do not
allow peer-to-peer transactions between Root Ports.  Add an ACS quirk so
each Root Port can be in a separate IOMMU group.

[bhelgaas: commit log, comment, use common implementation style]
Link: https://lore.kernel.org/r/1566275985-25670-1-git-send-email-srinath.mannam@broadcom.com
Signed-off-by: Abhinav Ratna <abhinav.ratna@broadcom.com>
Signed-off-by: Srinath Mannam <srinath.mannam@broadcom.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 92892b1c35fa..013b84880e1d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4543,6 +4543,19 @@ static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags)
 	return acs_flags ? 0 : 1;
 }
 
+static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	/*
+	 * iProc PAXB Root Ports don't advertise an ACS capability, but
+	 * they do not allow peer-to-peer transactions between Root Ports.
+	 * Allow each Root Port to be in a separate IOMMU group by masking
+	 * SV/RR/CR/UF bits.
+	 */
+	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+
+	return acs_flags ? 0 : 1;
+}
+
 static const struct pci_dev_acs_enabled {
 	u16 vendor;
 	u16 device;
@@ -4634,6 +4647,7 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_AMPERE, 0xE00A, pci_quirk_xgene_acs },
 	{ PCI_VENDOR_ID_AMPERE, 0xE00B, pci_quirk_xgene_acs },
 	{ PCI_VENDOR_ID_AMPERE, 0xE00C, pci_quirk_xgene_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	{ 0 }
 };
 
-- 
2.25.1




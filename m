Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBA52E39D6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389997AbgL1N2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:28:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389992AbgL1N2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B661207C9;
        Mon, 28 Dec 2020 13:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162089;
        bh=1LYaBvGS1TBmljzMlr/y86uwI+jwIHkLZ3mD3NfVEMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12ItFO+hN987YzdlSiGqCb4Wxf+6mLmbqz5Ki+ohIa6SIuj7UmLhSuit2haU3avxo
         Tzs7mJPCVtYwL4Aisk19abQrdNbKbe4AvfozZMCdj+xZusoAKqNjpnpRLcJEW4vYJo
         03UWz4EwOzhIfSu3AUWcmd4KejfhbyigluYJSaak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bharat Gooty <bharat.gooty@broadcom.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 182/346] PCI: iproc: Fix out-of-bound array accesses
Date:   Mon, 28 Dec 2020 13:48:21 +0100
Message-Id: <20201228124928.586195610@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bharat Gooty <bharat.gooty@broadcom.com>

[ Upstream commit a3ff529f5d368a17ff35ada8009e101162ebeaf9 ]

Declare the full size array for all revisions of PAX register sets
to avoid potentially out of bound access of the register array
when they are being initialized in iproc_pcie_rev_init().

Link: https://lore.kernel.org/r/20201001060054.6616-2-srinath.mannam@broadcom.com
Fixes: 06324ede76cdf ("PCI: iproc: Improve core register population")
Signed-off-by: Bharat Gooty <bharat.gooty@broadcom.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pcie-iproc.c b/drivers/pci/controller/pcie-iproc.c
index ec86414216f97..f2d79e0235bc1 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -300,7 +300,7 @@ enum iproc_pcie_reg {
 };
 
 /* iProc PCIe PAXB BCMA registers */
-static const u16 iproc_pcie_reg_paxb_bcma[] = {
+static const u16 iproc_pcie_reg_paxb_bcma[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_CLK_CTRL]		= 0x000,
 	[IPROC_PCIE_CFG_IND_ADDR]	= 0x120,
 	[IPROC_PCIE_CFG_IND_DATA]	= 0x124,
@@ -311,7 +311,7 @@ static const u16 iproc_pcie_reg_paxb_bcma[] = {
 };
 
 /* iProc PCIe PAXB registers */
-static const u16 iproc_pcie_reg_paxb[] = {
+static const u16 iproc_pcie_reg_paxb[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_CLK_CTRL]		= 0x000,
 	[IPROC_PCIE_CFG_IND_ADDR]	= 0x120,
 	[IPROC_PCIE_CFG_IND_DATA]	= 0x124,
@@ -327,7 +327,7 @@ static const u16 iproc_pcie_reg_paxb[] = {
 };
 
 /* iProc PCIe PAXB v2 registers */
-static const u16 iproc_pcie_reg_paxb_v2[] = {
+static const u16 iproc_pcie_reg_paxb_v2[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_CLK_CTRL]		= 0x000,
 	[IPROC_PCIE_CFG_IND_ADDR]	= 0x120,
 	[IPROC_PCIE_CFG_IND_DATA]	= 0x124,
@@ -355,7 +355,7 @@ static const u16 iproc_pcie_reg_paxb_v2[] = {
 };
 
 /* iProc PCIe PAXC v1 registers */
-static const u16 iproc_pcie_reg_paxc[] = {
+static const u16 iproc_pcie_reg_paxc[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_CLK_CTRL]		= 0x000,
 	[IPROC_PCIE_CFG_IND_ADDR]	= 0x1f0,
 	[IPROC_PCIE_CFG_IND_DATA]	= 0x1f4,
@@ -364,7 +364,7 @@ static const u16 iproc_pcie_reg_paxc[] = {
 };
 
 /* iProc PCIe PAXC v2 registers */
-static const u16 iproc_pcie_reg_paxc_v2[] = {
+static const u16 iproc_pcie_reg_paxc_v2[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_MSI_GIC_MODE]	= 0x050,
 	[IPROC_PCIE_MSI_BASE_ADDR]	= 0x074,
 	[IPROC_PCIE_MSI_WINDOW_SIZE]	= 0x078,
-- 
2.27.0




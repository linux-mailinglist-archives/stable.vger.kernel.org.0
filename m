Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123FB2E63CE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405461AbgL1Pmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405155AbgL1Nqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:46:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96FAD20715;
        Mon, 28 Dec 2020 13:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163158;
        bh=wddrTEZSFp8tpg3DEI4euQqLtSB2pEiOL2ZO9DJISmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fA82Xce6dkbyZkTjdmefThBnamH4qyeGVwQjmwKOUNNozIhFSk38cEfqCh1qGJ9oD
         A8izXjwczMblY8EdjwtzZJS/7G035/fwjxjzEhJyT5qLnGFUQr9uex/bJzciB619WO
         qsRyAvGVMoxAIYsmPnMhbCWEh2LOz4p09qb99Ou4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bharat Gooty <bharat.gooty@broadcom.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/453] PCI: iproc: Fix out-of-bound array accesses
Date:   Mon, 28 Dec 2020 13:47:06 +0100
Message-Id: <20201228124946.354888773@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 933a4346ae5d6..c6b1c18165e5c 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -307,7 +307,7 @@ enum iproc_pcie_reg {
 };
 
 /* iProc PCIe PAXB BCMA registers */
-static const u16 iproc_pcie_reg_paxb_bcma[] = {
+static const u16 iproc_pcie_reg_paxb_bcma[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_CLK_CTRL]		= 0x000,
 	[IPROC_PCIE_CFG_IND_ADDR]	= 0x120,
 	[IPROC_PCIE_CFG_IND_DATA]	= 0x124,
@@ -318,7 +318,7 @@ static const u16 iproc_pcie_reg_paxb_bcma[] = {
 };
 
 /* iProc PCIe PAXB registers */
-static const u16 iproc_pcie_reg_paxb[] = {
+static const u16 iproc_pcie_reg_paxb[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_CLK_CTRL]		= 0x000,
 	[IPROC_PCIE_CFG_IND_ADDR]	= 0x120,
 	[IPROC_PCIE_CFG_IND_DATA]	= 0x124,
@@ -334,7 +334,7 @@ static const u16 iproc_pcie_reg_paxb[] = {
 };
 
 /* iProc PCIe PAXB v2 registers */
-static const u16 iproc_pcie_reg_paxb_v2[] = {
+static const u16 iproc_pcie_reg_paxb_v2[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_CLK_CTRL]		= 0x000,
 	[IPROC_PCIE_CFG_IND_ADDR]	= 0x120,
 	[IPROC_PCIE_CFG_IND_DATA]	= 0x124,
@@ -363,7 +363,7 @@ static const u16 iproc_pcie_reg_paxb_v2[] = {
 };
 
 /* iProc PCIe PAXC v1 registers */
-static const u16 iproc_pcie_reg_paxc[] = {
+static const u16 iproc_pcie_reg_paxc[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_CLK_CTRL]		= 0x000,
 	[IPROC_PCIE_CFG_IND_ADDR]	= 0x1f0,
 	[IPROC_PCIE_CFG_IND_DATA]	= 0x1f4,
@@ -372,7 +372,7 @@ static const u16 iproc_pcie_reg_paxc[] = {
 };
 
 /* iProc PCIe PAXC v2 registers */
-static const u16 iproc_pcie_reg_paxc_v2[] = {
+static const u16 iproc_pcie_reg_paxc_v2[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_MSI_GIC_MODE]	= 0x050,
 	[IPROC_PCIE_MSI_BASE_ADDR]	= 0x074,
 	[IPROC_PCIE_MSI_WINDOW_SIZE]	= 0x078,
-- 
2.27.0




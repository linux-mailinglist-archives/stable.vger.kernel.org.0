Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4362E4130
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439777AbgL1OME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439773AbgL1OMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACC1B206D4;
        Mon, 28 Dec 2020 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164682;
        bh=2cxPfFdtevGz+SzS58rMmf9JDv7xCB4o33hk7gN+MBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1A0t8IWM8XO+olPt+FpvtlOk723MKXI+z7TG8XMwmcmALLvD7nV2zJOrj54i/gXF
         jGCs0M3QCDbnEiEUoVf1BzTvEkl8pYlKm3dSXKtw0RONa5FtJlc2aMJUhXf4KMPnAN
         q6vUumWbOSh5CbUNdkzpbFGTr3rEoTZcWqyYkc5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Bacik <roman.bacik@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/717] PCI: iproc: Invalidate correct PAXB inbound windows
Date:   Mon, 28 Dec 2020 13:44:01 +0100
Message-Id: <20201228125032.632176227@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bacik <roman.bacik@broadcom.com>

[ Upstream commit 89bbcaac3dff21f3567956b3416f5ec8b45f5555 ]

Second stage bootloaders prior to Linux boot may use all inbound windows
including IARR1/IMAP1. We need to ensure that all previous configuration
of inbound windows are invalidated during the initialization stage of
the Linux iProc PCIe driver so let's add a fix to define and invalidate
IARR1/IMAP1 because it is currently missing, fixing the issue.

Link: https://lore.kernel.org/r/20201001060054.6616-3-srinath.mannam@broadcom.com
Fixes: 9415743e4c8a ("PCI: iproc: Invalidate PAXB address mapping")
Signed-off-by: Roman Bacik <roman.bacik@broadcom.com>
Signed-off-by: Srinath Mannam <srinath.mannam@broadcom.com>
[lorenzo.pieralisi@arm.com: commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-iproc.c b/drivers/pci/controller/pcie-iproc.c
index d901b9d392b8c..cc5b7823edeb7 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -192,8 +192,15 @@ static const struct iproc_pcie_ib_map paxb_v2_ib_map[] = {
 		.imap_window_offset = 0x4,
 	},
 	{
-		/* IARR1/IMAP1 (currently unused) */
-		.type = IPROC_PCIE_IB_MAP_INVALID,
+		/* IARR1/IMAP1 */
+		.type = IPROC_PCIE_IB_MAP_MEM,
+		.size_unit = SZ_1M,
+		.region_sizes = { 8 },
+		.nr_sizes = 1,
+		.nr_windows = 8,
+		.imap_addr_offset = 0x4,
+		.imap_window_offset = 0x8,
+
 	},
 	{
 		/* IARR2/IMAP2 */
@@ -351,6 +358,8 @@ static const u16 iproc_pcie_reg_paxb_v2[IPROC_PCIE_MAX_NUM_REG] = {
 	[IPROC_PCIE_OMAP3]		= 0xdf8,
 	[IPROC_PCIE_IARR0]		= 0xd00,
 	[IPROC_PCIE_IMAP0]		= 0xc00,
+	[IPROC_PCIE_IARR1]		= 0xd08,
+	[IPROC_PCIE_IMAP1]		= 0xd70,
 	[IPROC_PCIE_IARR2]		= 0xd10,
 	[IPROC_PCIE_IMAP2]		= 0xcc0,
 	[IPROC_PCIE_IARR3]		= 0xe00,
-- 
2.27.0




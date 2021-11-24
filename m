Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C751445D0C6
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352484AbhKXXIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352469AbhKXXIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F048B6108B;
        Wed, 24 Nov 2021 23:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795120;
        bh=8trR07MwLjC4gZLqp3Ls9OBhFxUIpegk9zxqgh9JfyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DC1ZGm+ZEKHI4iSLiT7wErurseusPR8AVPNqjTF+CkAVvEMoYHgnoO5ln287BwKd5
         //VscjQ29ATisCVqyZoffwsoqEFmTbk0g6xYS4+Z89emcLFWIblqGct8eaAtTsmbpy
         b2YCQNKITo1i7n12qR0moA6KmE5olWwW6t4d/ttZ3/CoGA+6kpbGFJa7GCPUiypTP+
         uooE+jviXT13aabODFbQEK9CA3STJUEd3q49EqIipbApZj2YQpfsFGckpzxn0c5Vbi
         XlluK59rvVbeTvE9uOPICSjf57Kh5T3pb8zu/Jgej78GYC6SH/rR9TRvOKZT1a/RsH
         qc2A7m/cwnk2A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 08/20] PCI: aardvark: Don't touch PCIe registers if no card connected
Date:   Thu, 25 Nov 2021 00:04:48 +0100
Message-Id: <20211124230500.27109-9-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 70e380250c3621c55ff218cbaf2272830d9dbb1d upstream.

When there is no PCIe card connected and advk_pcie_rd_conf() or
advk_pcie_wr_conf() is called for PCI bus which doesn't belong to emulated
root bridge, the aardvark driver throws the following error message:

  advk-pcie d0070000.pcie: config read/write timed out

Obviously accessing PCIe registers of disconnected card is not possible.

Extend check in advk_pcie_valid_device() function for validating
availability of PCIe bus. If PCIe link is down, then the device is marked
as Not Found and the driver does not try to access these registers.

This is just an optimization to prevent accessing PCIe registers when card
is disconnected. Trying to access PCIe registers of disconnected card does
not cause any crash, kernel just needs to wait for a timeout. So if card
disappear immediately after checking for PCIe link (before accessing PCIe
registers), it does not cause any problems.

Link: https://lore.kernel.org/r/20200702083036.12230-1-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 5837fff32f8e..d1bdd40d18fb 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -525,6 +525,13 @@ static bool advk_pcie_valid_device(struct advk_pcie *pcie, struct pci_bus *bus,
 	if ((bus->number == pcie->root_bus_nr) && PCI_SLOT(devfn) != 0)
 		return false;
 
+	/*
+	 * If the link goes down after we check for link-up, nothing bad
+	 * happens but the config access times out.
+	 */
+	if (bus->number != pcie->root_bus_nr && !advk_pcie_link_up(pcie))
+		return false;
+
 	return true;
 }
 
-- 
2.32.0


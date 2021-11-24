Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ACE45D06B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352183AbhKXWxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352275AbhKXWxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 997276108D;
        Wed, 24 Nov 2021 22:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794203;
        bh=LyV2hNjrEglMOyMZ/ocCcz0rKKps3Us4p2tMUasKAOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHX1Mo10Nn+ZbB4xQWVJ4OLGZ9Dj4AotRd+/53l4UmwsQ91IafGBTDYw6+d9LIxYu
         t+u6/lSHq69toR2ZQPu7SMYWfGPwpTjEmf+gbV43KaYVRgiWS8dWNZmQWM/1bbmpgy
         7ADbUWOxm0Z6XRLsswUZ5fumv18kR+++i3mwuYNGy4J2JGzatL1YY2kPCoyQRG7ouP
         nAi2YdviYLVsNf0UtwusihqHBRKgid+PCfTpDRfZWyq3TJ8gd/togmy9O+vxD6Qqd5
         SqG/o0v6N0r4of6es+VSckw3ciJCuRlUDS4l8YzZKSoW3p3TGLHvwJgXgMceTnl2fI
         TcfKtcwDfLEdQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 10/24] PCI: aardvark: Don't touch PCIe registers if no card connected
Date:   Wed, 24 Nov 2021 23:49:19 +0100
Message-Id: <20211124224933.24275-11-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
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
 drivers/pci/host/pci-aardvark.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 9426715316b2..acc04c4a37df 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -598,6 +598,13 @@ static bool advk_pcie_valid_device(struct advk_pcie *pcie, struct pci_bus *bus,
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


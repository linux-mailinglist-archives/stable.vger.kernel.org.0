Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F49461DDB
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379017AbhK2S34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47850 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351307AbhK2S1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BCCFCE167D;
        Mon, 29 Nov 2021 18:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49616C53FAD;
        Mon, 29 Nov 2021 18:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210274;
        bh=qsT2tlP3Dh1TzlaNCd1y/SMQPnJ76ylQRmy1AgwRj+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAt/tAn+MVA/Awd/sJ2n0nRkfe4Gdw6S7Gmm7JgVIwcRHNcvYpetIJpRnB56okAFE
         PwthXaLNuTR1f7ujRzfVaoCxvGabsT+Fi070TVL6O8TqGZk6kImhZPcW0mVTykSuJu
         XCcBUi7LTb3GAl0lH1ut4xDQBNenPphmC/mNh6Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 30/92] PCI: aardvark: Dont touch PCIe registers if no card connected
Date:   Mon, 29 Nov 2021 19:17:59 +0100
Message-Id: <20211129181708.414533084@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -806,6 +806,13 @@ static bool advk_pcie_valid_device(struc
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
 



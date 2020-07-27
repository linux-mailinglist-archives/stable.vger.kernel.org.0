Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6451822F0FE
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732153AbgG0OXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732148AbgG0OXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CDCE22BF5;
        Mon, 27 Jul 2020 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859827;
        bh=L+hvxD0ShNgRiW665zZgeC/VRcIF7HA/LgIxcg0wf7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+XnPq4h4MHdOqH/dBFeU+bk0iDUQAwyaCMyazCLB4Tav2+t0PU4dzRtuvfjJeinw
         C3/Gb5FHbNhSd5InpKOgJMtapwVjxhd5TMCb5E+lhvBvGk1ySbp9238AbgMDAu1hIz
         1etTvRQMxvSlPqHLb2nEoTzsRSaOvJEaT3N6Wamo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 090/179] enetc: Remove the mdio bus on PF probe bailout
Date:   Mon, 27 Jul 2020 16:04:25 +0200
Message-Id: <20200727134937.059668605@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit 26cb7085c8984e5b71d65c374a135134ed8cabb3 ]

For ENETC ports that register an external MDIO bus,
the bus doesn't get removed on the error bailout path
of enetc_pf_probe().

This issue became much more visible after recent:
commit 07095c025ac2 ("net: enetc: Use DT protocol information to set up the ports")
Before this commit, one could make probing fail on the error
path only by having register_netdev() fail, which is unlikely.
But after this commit, because it moved the enetc_of_phy_get()
call up in the probing sequence, now we can trigger an mdiobus_free()
bug just by forcing enetc_alloc_msix() to return error, i.e. with the
'pci=nomsi' kernel bootarg (since ENETC relies on MSI support to work),
as the calltrace below shows:

kernel BUG at /home/eiz/work/enetc/net/drivers/net/phy/mdio_bus.c:648!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[...]
Hardware name: LS1028A RDB Board (DT)
pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
pc : mdiobus_free+0x50/0x58
lr : devm_mdiobus_free+0x14/0x20
[...]
Call trace:
 mdiobus_free+0x50/0x58
 devm_mdiobus_free+0x14/0x20
 release_nodes+0x138/0x228
 devres_release_all+0x38/0x60
 really_probe+0x1c8/0x368
 driver_probe_device+0x5c/0xc0
 device_driver_attach+0x74/0x80
 __driver_attach+0x8c/0xd8
 bus_for_each_dev+0x7c/0xd8
 driver_attach+0x24/0x30
 bus_add_driver+0x154/0x200
 driver_register+0x64/0x120
 __pci_register_driver+0x44/0x50
 enetc_pf_driver_init+0x24/0x30
 do_one_initcall+0x60/0x1c0
 kernel_init_freeable+0x1fc/0x274
 kernel_init+0x14/0x110
 ret_from_fork+0x10/0x34

Fixes: ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 438648a06f2ae..041e19895adfa 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -919,6 +919,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	return 0;
 
 err_reg_netdev:
+	enetc_mdio_remove(pf);
 	enetc_of_put_phy(priv);
 	enetc_free_msix(priv);
 err_alloc_msix:
-- 
2.25.1




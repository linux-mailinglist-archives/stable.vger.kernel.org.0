Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150E033B69A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhCON6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232049AbhCON5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E40264EEC;
        Mon, 15 Mar 2021 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816659;
        bh=jc66TvqUUbe1HBobHMcLfxnpLpiyNn+zSqvT8O3Y9jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2qKRizsqfZ/g3DMNI+XWjXv+TsBBO8NLDe9mESyEQV6Cj36GECo3TvdJiRmgRCRo
         5poKAVgjfz7IqSvl/falzfyGgdrDQBDcbM17DkQ2MgpTmotIUayhLt17Nta46GxZj8
         qg6run+JUNm3KIh7L1Uos0PUQ3ClBJevdEgje+cQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 047/306] net: enetc: initialize RFS/RSS memories for unused ports too
Date:   Mon, 15 Mar 2021 14:51:50 +0100
Message-Id: <20210315135509.241900768@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 3222b5b613db558e9a494bbf53f3c984d90f71ea upstream.

Michael reports that since linux-next-20210211, the AER messages for ECC
errors have started reappearing, and this time they can be reliably
reproduced with the first ping on one of his LS1028A boards.

$ ping 1[   33.258069] pcieport 0000:00:1f.0: AER: Multiple Corrected error received: 0000:00:00.0
72.16.0.1
PING [   33.267050] pcieport 0000:00:1f.0: AER: can't find device of ID0000
172.16.0.1 (172.16.0.1): 56 data bytes
64 bytes from 172.16.0.1: seq=0 ttl=64 time=17.124 ms
64 bytes from 172.16.0.1: seq=1 ttl=64 time=0.273 ms

$ devmem 0x1f8010e10 32
0xC0000006

It isn't clear why this is necessary, but it seems that for the errors
to go away, we must clear the entire RFS and RSS memory, not just for
the ports in use.

Sadly the code is structured in such a way that we can't have unified
logic for the used and unused ports. For the minimal initialization of
an unused port, we need just to enable and ioremap the PF memory space,
and a control buffer descriptor ring. Unused ports must then free the
CBDR because the driver will exit, but used ports can not pick up from
where that code path left, since the CBDR API does not reinitialize a
ring when setting it up, so its producer and consumer indices are out of
sync between the software and hardware state. So a separate
enetc_init_unused_port function was created, and it gets called right
after the PF memory space is enabled.

Fixes: 07bf34a50e32 ("net: enetc: initialize the RFS and RSS memories")
Reported-by: Michael Walle <michael@walle.cc>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Michael Walle <michael@walle.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c    |    8 ++---
 drivers/net/ethernet/freescale/enetc/enetc.h    |    4 ++
 drivers/net/ethernet/freescale/enetc/enetc_pf.c |   33 ++++++++++++++++++++----
 3 files changed, 36 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -984,7 +984,7 @@ static void enetc_free_rxtx_rings(struct
 		enetc_free_tx_ring(priv->tx_ring[i]);
 }
 
-static int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
+int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 {
 	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
 
@@ -1005,7 +1005,7 @@ static int enetc_alloc_cbdr(struct devic
 	return 0;
 }
 
-static void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
+void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 {
 	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
 
@@ -1013,7 +1013,7 @@ static void enetc_free_cbdr(struct devic
 	cbdr->bd_base = NULL;
 }
 
-static void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
+void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
 {
 	/* set CBDR cache attributes */
 	enetc_wr(hw, ENETC_SICAR2,
@@ -1033,7 +1033,7 @@ static void enetc_setup_cbdr(struct enet
 	cbdr->cir = hw->reg + ENETC_SICBDRCIR;
 }
 
-static void enetc_clear_cbdr(struct enetc_hw *hw)
+void enetc_clear_cbdr(struct enetc_hw *hw)
 {
 	enetc_wr(hw, ENETC_SICBDRMR, 0);
 }
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -310,6 +310,10 @@ int enetc_setup_tc(struct net_device *nd
 void enetc_set_ethtool_ops(struct net_device *ndev);
 
 /* control buffer descriptor ring (CBDR) */
+int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr);
+void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr);
+void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr);
+void enetc_clear_cbdr(struct enetc_hw *hw);
 int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 			    char *mac_addr, int si_map);
 int enetc_clear_mac_flt_entry(struct enetc_si *si, int index);
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1041,6 +1041,26 @@ static int enetc_init_port_rss_memory(st
 	return err;
 }
 
+static void enetc_init_unused_port(struct enetc_si *si)
+{
+	struct device *dev = &si->pdev->dev;
+	struct enetc_hw *hw = &si->hw;
+	int err;
+
+	si->cbd_ring.bd_count = ENETC_CBDR_DEFAULT_SIZE;
+	err = enetc_alloc_cbdr(dev, &si->cbd_ring);
+	if (err)
+		return;
+
+	enetc_setup_cbdr(hw, &si->cbd_ring);
+
+	enetc_init_port_rfs_memory(si);
+	enetc_init_port_rss_memory(si);
+
+	enetc_clear_cbdr(hw);
+	enetc_free_cbdr(dev, &si->cbd_ring);
+}
+
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
@@ -1051,11 +1071,6 @@ static int enetc_pf_probe(struct pci_dev
 	struct enetc_pf *pf;
 	int err;
 
-	if (node && !of_device_is_available(node)) {
-		dev_info(&pdev->dev, "device is disabled, skipping\n");
-		return -ENODEV;
-	}
-
 	err = enetc_pci_probe(pdev, KBUILD_MODNAME, sizeof(*pf));
 	if (err) {
 		dev_err(&pdev->dev, "PCI probing failed\n");
@@ -1069,6 +1084,13 @@ static int enetc_pf_probe(struct pci_dev
 		goto err_map_pf_space;
 	}
 
+	if (node && !of_device_is_available(node)) {
+		enetc_init_unused_port(si);
+		dev_info(&pdev->dev, "device is disabled, skipping\n");
+		err = -ENODEV;
+		goto err_device_disabled;
+	}
+
 	pf = enetc_si_priv(si);
 	pf->si = si;
 	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
@@ -1151,6 +1173,7 @@ err_alloc_si_res:
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
+err_device_disabled:
 err_map_pf_space:
 	enetc_pci_remove(pdev);
 



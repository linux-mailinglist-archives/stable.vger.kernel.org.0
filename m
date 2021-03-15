Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EE533B690
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhCON6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231506AbhCON5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 647A264EFD;
        Mon, 15 Mar 2021 13:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816651;
        bh=R1tkQOlGZCS/T6g4f/tFDDfDpjd1tx/y4PsyLlEuNOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kcbBoRfR9y2RVgNt273SSnynu5dTLczV0x7txo9Qhc5o22yb6bMubOC4Kmz4h7OB
         TM1T6bHphdF+mDf70Xw7y2Ni1bCzlCxpdBZR4LWlE5KsnkyOyNdxnAy7CyhDOoESPA
         z7gzAYVPplcjHldznCvP6mSIZEKpgeemt4iUFALk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 026/168] net: enetc: dont overwrite the RSS indirection table when initializing
Date:   Mon, 15 Mar 2021 14:54:18 +0100
Message-Id: <20210315135551.214302116@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit c646d10dda2dcde82c6ce5a474522621ab2b8b19 upstream.

After the blamed patch, all RX traffic gets hashed to CPU 0 because the
hashing indirection table set up in:

enetc_pf_probe
-> enetc_alloc_si_resources
   -> enetc_configure_si
      -> enetc_setup_default_rss_table

is overwritten later in:

enetc_pf_probe
-> enetc_init_port_rss_memory

which zero-initializes the entire port RSS table in order to avoid ECC errors.

The trouble really is that enetc_init_port_rss_memory really neads
enetc_alloc_si_resources to be called, because it depends upon
enetc_alloc_cbdr and enetc_setup_cbdr. But that whole enetc_configure_si
thing could have been better thought out, it has nothing to do in a
function called "alloc_si_resources", especially since its counterpart,
"free_si_resources", does nothing to unwind the configuration of the SI.

The point is, we need to pull out enetc_configure_si out of
enetc_alloc_resources, and move it after enetc_init_port_rss_memory.
This allows us to set up the default RSS indirection table after
initializing the memory.

Fixes: 07bf34a50e32 ("net: enetc: initialize the RFS and RSS memories")
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c    |   11 +++--------
 drivers/net/ethernet/freescale/enetc/enetc.h    |    1 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c |    7 +++++++
 drivers/net/ethernet/freescale/enetc/enetc_vf.c |    7 +++++++
 4 files changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1016,13 +1016,12 @@ static int enetc_setup_default_rss_table
 	return 0;
 }
 
-static int enetc_configure_si(struct enetc_ndev_priv *priv)
+int enetc_configure_si(struct enetc_ndev_priv *priv)
 {
 	struct enetc_si *si = priv->si;
 	struct enetc_hw *hw = &si->hw;
 	int err;
 
-	enetc_setup_cbdr(hw, &si->cbd_ring);
 	/* set SI cache attributes */
 	enetc_wr(hw, ENETC_SICAR0,
 		 ENETC_SICAR_RD_COHERENT | ENETC_SICAR_WR_COHERENT);
@@ -1068,6 +1067,8 @@ int enetc_alloc_si_resources(struct enet
 	if (err)
 		return err;
 
+	enetc_setup_cbdr(&si->hw, &si->cbd_ring);
+
 	priv->cls_rules = kcalloc(si->num_fs_entries, sizeof(*priv->cls_rules),
 				  GFP_KERNEL);
 	if (!priv->cls_rules) {
@@ -1075,14 +1076,8 @@ int enetc_alloc_si_resources(struct enet
 		goto err_alloc_cls;
 	}
 
-	err = enetc_configure_si(priv);
-	if (err)
-		goto err_config_si;
-
 	return 0;
 
-err_config_si:
-	kfree(priv->cls_rules);
 err_alloc_cls:
 	enetc_clear_cbdr(&si->hw);
 	enetc_free_cbdr(priv->dev, &si->cbd_ring);
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -221,6 +221,7 @@ void enetc_get_si_caps(struct enetc_si *
 void enetc_init_si_rings_params(struct enetc_ndev_priv *priv);
 int enetc_alloc_si_resources(struct enetc_ndev_priv *priv);
 void enetc_free_si_resources(struct enetc_ndev_priv *priv);
+int enetc_configure_si(struct enetc_ndev_priv *priv);
 
 int enetc_open(struct net_device *ndev);
 int enetc_close(struct net_device *ndev);
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -920,6 +920,12 @@ static int enetc_pf_probe(struct pci_dev
 		goto err_init_port_rss;
 	}
 
+	err = enetc_configure_si(priv);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to configure SI\n");
+		goto err_config_si;
+	}
+
 	err = enetc_alloc_msix(priv);
 	if (err) {
 		dev_err(&pdev->dev, "MSIX alloc failed\n");
@@ -945,6 +951,7 @@ err_reg_netdev:
 	enetc_mdio_remove(pf);
 	enetc_of_put_phy(priv);
 	enetc_free_msix(priv);
+err_config_si:
 err_init_port_rss:
 err_init_port_rfs:
 err_alloc_msix:
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -189,6 +189,12 @@ static int enetc_vf_probe(struct pci_dev
 		goto err_alloc_si_res;
 	}
 
+	err = enetc_configure_si(priv);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to configure SI\n");
+		goto err_config_si;
+	}
+
 	err = enetc_alloc_msix(priv);
 	if (err) {
 		dev_err(&pdev->dev, "MSIX alloc failed\n");
@@ -208,6 +214,7 @@ static int enetc_vf_probe(struct pci_dev
 
 err_reg_netdev:
 	enetc_free_msix(priv);
+err_config_si:
 err_alloc_msix:
 	enetc_free_si_resources(priv);
 err_alloc_si_res:



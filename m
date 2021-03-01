Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9AC328BF1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240485AbhCASnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:43:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240191AbhCASh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:37:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7AE365012;
        Mon,  1 Mar 2021 17:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618651;
        bh=wv+7pgcKUHla4PJ1ndnf56SUfG/ahrxUITsC1mxEgYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rf+ptk36n2XCnaxFbyuyCJj/Q2u9jR1gc/M2Q0M7phoeJBbx6ETArLpiIH5O9gKdU
         I6zOfojPkKY/J66Eyucwfayo+SNxDGx6Nb7YzE6QC28mk5GgDZB8hO2K5Uf9mIV0oR
         oDoBr13og4FR3uXYo13rPLrjlr0zHsJwm3lmv3o0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/663] net: enetc: fix destroyed phylink dereference during unbind
Date:   Mon,  1 Mar 2021 17:06:23 +0100
Message-Id: <20210301161148.433060661@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 3af409ca278d4a8d50e91f9f7c4c33b175645cf3 ]

The following call path suggests that calling unregister_netdev on an
interface that is up will first bring it down.

enetc_pf_remove
-> unregister_netdev
   -> unregister_netdevice_queue
      -> unregister_netdevice_many
         -> dev_close_many
            -> __dev_close_many
               -> enetc_close
                  -> enetc_stop
                     -> phylink_stop

However, enetc first destroys the phylink instance, then calls
unregister_netdev. This is already dissimilar to the setup (and error
path teardown path) from enetc_pf_probe, but more than that, it is buggy
because it is invalid to call phylink_stop after phylink_destroy.

So let's first unregister the netdev (and let the .ndo_stop events
consume themselves), then destroy the phylink instance, then free the
netdev.

Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 06514af0df106..796e3d6f23f09 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1164,14 +1164,15 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	struct enetc_ndev_priv *priv;
 
 	priv = netdev_priv(si->ndev);
-	enetc_phylink_destroy(priv);
-	enetc_mdiobus_destroy(pf);
 
 	if (pf->num_vfs)
 		enetc_sriov_configure(pdev, 0);
 
 	unregister_netdev(si->ndev);
 
+	enetc_phylink_destroy(priv);
+	enetc_mdiobus_destroy(pf);
+
 	enetc_free_msix(priv);
 
 	enetc_free_si_resources(priv);
-- 
2.27.0




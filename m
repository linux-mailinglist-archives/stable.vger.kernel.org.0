Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474B633B71A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhCON7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232062AbhCON5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20FEE64F0D;
        Mon, 15 Mar 2021 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816661;
        bh=KyhRkJu76SQjITrL0Y+C/w9/g1Uj7Z66XJy9r1h2G1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UatkTrI3mPOs6HsZSIbSlypRfWFd+Jsxw3gcpX7uqEZ3ojX+rZU2U9oEOSsPW0Nli
         Vh2cXO9gXot/N/h7TAH99+0xJBXFlzSKIyc/81DYmK8QxVYHPc4ds/627g7gTtr78V
         lSmOlRDYLbdBfNivGtis0D6Gnb0rb+PNfYebKZIY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Markus=20Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 040/290] net: enetc: dont disable VLAN filtering in IFF_PROMISC mode
Date:   Mon, 15 Mar 2021 14:52:13 +0100
Message-Id: <20210315135543.278204175@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit a74dbce9d4541888fe0d39afe69a3a95004669b4 upstream.

Quoting from the blamed commit:

    In promiscuous mode, it is more intuitive that all traffic is received,
    including VLAN tagged traffic. It appears that it is necessary to set
    the flag in PSIPVMR for that to be the case, so VLAN promiscuous mode is
    also temporarily enabled. On exit from promiscuous mode, the setting
    made by ethtool is restored.

Intuitive or not, there isn't any definition issued by a standards body
which says that promiscuity has anything to do with VLAN filtering - it
only has to do with accepting packets regardless of destination MAC address.

In fact people are already trying to use this misunderstanding/bug of
the enetc driver as a justification to transform promiscuity into
something it never was about: accepting every packet (maybe that would
be the "rx-all" netdev feature?):
https://lore.kernel.org/netdev/20201110153958.ci5ekor3o2ekg3ky@ipetronik.com/

This is relevant because there are use cases in the kernel (such as
tc-flower rules with the protocol 802.1Q and a vlan_id key) which do not
(yet) use the vlan_vid_add API to be compatible with VLAN-filtering NICs
such as enetc, so for those, disabling rx-vlan-filter is currently the
only right solution to make these setups work:
https://lore.kernel.org/netdev/CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com/
The blamed patch has unintentionally introduced one more way for this to
work, which is to enable IFF_PROMISC, however this is non-portable
because port promiscuity is not meant to disable VLAN filtering.
Therefore, it could invite people to write broken scripts for enetc, and
then wonder why they are broken when migrating to other drivers that
don't handle promiscuity in the same way.

Fixes: 7070eea5e95a ("enetc: permit configuration of rx-vlan-filter with ethtool")
Cc: Markus Blöchl <Markus.Bloechl@ipetronik.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -190,7 +190,6 @@ static void enetc_pf_set_rx_mode(struct
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
-	char vlan_promisc_simap = pf->vlan_promisc_simap;
 	struct enetc_hw *hw = &priv->si->hw;
 	bool uprom = false, mprom = false;
 	struct enetc_mac_filter *filter;
@@ -203,16 +202,12 @@ static void enetc_pf_set_rx_mode(struct
 		psipmr = ENETC_PSIPMR_SET_UP(0) | ENETC_PSIPMR_SET_MP(0);
 		uprom = true;
 		mprom = true;
-		/* Enable VLAN promiscuous mode for SI0 (PF) */
-		vlan_promisc_simap |= BIT(0);
 	} else if (ndev->flags & IFF_ALLMULTI) {
 		/* enable multi cast promisc mode for SI0 (PF) */
 		psipmr = ENETC_PSIPMR_SET_MP(0);
 		mprom = true;
 	}
 
-	enetc_set_vlan_promisc(&pf->si->hw, vlan_promisc_simap);
-
 	/* first 2 filter entries belong to PF */
 	if (!uprom) {
 		/* Update unicast filters */



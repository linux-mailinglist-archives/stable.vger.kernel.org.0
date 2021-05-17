Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E09F383540
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243256AbhEQPQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243715AbhEQPOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:14:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5495361C61;
        Mon, 17 May 2021 14:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261929;
        bh=QC5ha4TMX+jv+AkEVRdL8x+jfrSeuRBiUQl+af5vZ4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5NIPQbCF4/kVoG9rtFDFMsYMhGcvoiwJEsHhynyguDRcHssWldRDDFPrverxllpI
         EAgEMw9qaEv3h+SUrxTXlhKVlQu7+uDZC2zGEBTZsSujNi+sp5w9FlCXstYA7I7fP/
         WDESngw7tjDYRG4BH1+ELIHo7KKHGWADbcCexsJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/141] i40e: fix the restart auto-negotiation after FEC modified
Date:   Mon, 17 May 2021 16:02:25 +0200
Message-Id: <20210517140245.901126130@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslaw Gawin <jaroslawx.gawin@intel.com>

[ Upstream commit 61343e6da7810de81d6b826698946ae4f9070819 ]

When FEC mode was changed the link didn't know it because
the link was not reset and new parameters were not negotiated.
Set a flag 'I40E_AQ_PHY_ENABLE_ATOMIC_LINK' in 'abilities'
to restart the link and make it run with the new settings.

Fixes: 1d96340196f1 ("i40e: Add support FEC configuration for Fortville 25G")
Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index b519e5af5ed9..502b4abc0aab 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1406,7 +1406,8 @@ static int i40e_set_fec_cfg(struct net_device *netdev, u8 fec_cfg)
 
 		memset(&config, 0, sizeof(config));
 		config.phy_type = abilities.phy_type;
-		config.abilities = abilities.abilities;
+		config.abilities = abilities.abilities |
+				   I40E_AQ_PHY_ENABLE_ATOMIC_LINK;
 		config.phy_type_ext = abilities.phy_type_ext;
 		config.link_speed = abilities.link_speed;
 		config.eee_capability = abilities.eee_capability;
-- 
2.30.2




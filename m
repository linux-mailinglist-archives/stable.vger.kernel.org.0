Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046C23CDD54
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239574AbhGSO5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239565AbhGSO4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:56:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BE3B6113C;
        Mon, 19 Jul 2021 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708849;
        bh=bnp0iwysihyhrIc4vUGI8XraUKqlJQMUpJmHyO7+VsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXG3ntS46tnuv1U0yQ6gZ5wD8XfFcp9FL0Krg0WbE9SolInXTZLOFZmWK+GrrpTJW
         OeMLAJzlXJ+RbRe8NfApDzXA58niKk73+pRTreliOTMdldyFlqXge8EgvWYgdR/K8q
         9B1/K0UQJyjQdR2BA9fnP6FjP/pkd69h2FcMjUNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Karen Sornek <karen.sornek@intel.com>,
        Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/421] i40e: Fix autoneg disabling for non-10GBaseT links
Date:   Mon, 19 Jul 2021 16:49:26 +0200
Message-Id: <20210719144951.838218872@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit 9262793e59f0423437166a879a73d056b1fe6f9a ]

Disabling autonegotiation was allowed only for 10GBaseT PHY.
The condition was changed to check if link media type is BaseT.

Fixes: 3ce12ee9d8f9 ("i40e: Fix order of checks when enabling/disabling autoneg in ethtool")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Karen Sornek <karen.sornek@intel.com>
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 9148d93c5c63..4c7c1998f358 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -948,8 +948,7 @@ static int i40e_set_link_ksettings(struct net_device *netdev,
 			if (ethtool_link_ksettings_test_link_mode(&safe_ks,
 								  supported,
 								  Autoneg) &&
-			    hw->phy.link_info.phy_type !=
-			    I40E_PHY_TYPE_10GBASE_T) {
+			    hw->phy.media_type != I40E_MEDIA_TYPE_BASET) {
 				netdev_info(netdev, "Autoneg cannot be disabled on this phy\n");
 				err = -EINVAL;
 				goto done;
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE5B3C5439
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343909AbhGLH5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346637AbhGLHxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFEE6117A;
        Mon, 12 Jul 2021 07:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076244;
        bh=+w6zZEWtnix7IzEd5I6z6tOpqtGVzuDHeP+9F32X4SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GI17vxVK5fjxaeKIZCFDPsLQPBAYLvd0vvtL73qhT0PvyAVSUNk1g8692UuxefaVD
         6rc3n9rEoAfnmnUapCtAHyGAR29a4n0GtMnBo8qlU2jPmZIxC06uIjf1d8hAAlzmb4
         kiCZzPj/13K/aQf88sL4pshM8pd828dOHXE7bRO8=
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
Subject: [PATCH 5.13 558/800] i40e: Fix autoneg disabling for non-10GBaseT links
Date:   Mon, 12 Jul 2021 08:09:41 +0200
Message-Id: <20210712061026.776818473@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index ccd5b9486ea9..3e822bad4851 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1262,8 +1262,7 @@ static int i40e_set_link_ksettings(struct net_device *netdev,
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




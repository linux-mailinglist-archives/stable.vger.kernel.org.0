Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056C145C146
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348182AbhKXNQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:16:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348781AbhKXNOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6CB361AA4;
        Wed, 24 Nov 2021 12:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757827;
        bh=D5prBRVHoRoICqucyomoCUZB+edbO/DzreDSY6iKGDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvV2fOQxtKt2UUsIRDCiBpp1Kmg4G3RvgoZ4N6Ro9WOAJzska89LWEj9cL/bWMXkT
         7pzeOgJcqJnm1nzx6GSib5mDoa2i+zPfR21igt1N5qXIfUGA5WqZlUthW6XBAT+Wqh
         KA1a791sTE3Ybn50HzYQtEzWmV/h+yegF74/2vqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Nunley <nicholas.d.nunley@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 288/323] iavf: check for null in iavf_fix_features
Date:   Wed, 24 Nov 2021 12:57:58 +0100
Message-Id: <20211124115728.624581935@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Nunley <nicholas.d.nunley@intel.com>

[ Upstream commit 8a4a126f4be88eb8b5f00a165ab58c35edf4ef76 ]

If the driver has lost contact with the PF then it enters a disabled state
and frees adapter->vf_res. However, ndo_fix_features can still be called on
the interface, so we need to check for this condition first. Since we have
no information on the features at this time simply leave them unmodified
and return.

Fixes: c4445aedfe09 ("i40evf: Fix VLAN features")
Signed-off-by: Nicholas Nunley <nicholas.d.nunley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40evf/i40evf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_main.c b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
index ac5709624c7ad..1fd8cc5ac306c 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_main.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
@@ -3185,7 +3185,8 @@ static netdev_features_t i40evf_fix_features(struct net_device *netdev,
 {
 	struct i40evf_adapter *adapter = netdev_priv(netdev);
 
-	if (!(adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN))
+	if (adapter->vf_res &&
+	    !(adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN))
 		features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
 			      NETIF_F_HW_VLAN_CTAG_RX |
 			      NETIF_F_HW_VLAN_CTAG_FILTER);
-- 
2.33.0




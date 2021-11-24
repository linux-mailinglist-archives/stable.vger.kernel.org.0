Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1AE45C562
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347887AbhKXN5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352366AbhKXNy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E45561504;
        Wed, 24 Nov 2021 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759175;
        bh=QmJe54iRhzz0vAi7dCGLFqgX+U7Ar1Wycuxbr4Ur1Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DchSgYfmKUZvKbhJ08uDIS7umbDMJ/4m88r+b+YGMrlSgRmo8mjHegh+a/2LVhE7C
         UpGQwKDHaZ7wlJ4LEn8kORK6113UcJ7I7CisCNvXQB8CjammHQ6edmvEvJbxHb/Uos
         lJN52YQHhKQDuFkw+k2BBpkewqVRza8XF4DTvxI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Nunley <nicholas.d.nunley@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/279] iavf: check for null in iavf_fix_features
Date:   Wed, 24 Nov 2021 12:56:51 +0100
Message-Id: <20211124115723.092541936@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
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
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index cada4e0e40b48..12976ccca1b6e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3442,7 +3442,8 @@ static netdev_features_t iavf_fix_features(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	if (!(adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN))
+	if (adapter->vf_res &&
+	    !(adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN))
 		features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
 			      NETIF_F_HW_VLAN_CTAG_RX |
 			      NETIF_F_HW_VLAN_CTAG_FILTER);
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A067F1018A1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfKSF0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:26:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbfKSF0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0416D21783;
        Tue, 19 Nov 2019 05:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141212;
        bh=FBFUnT8LQXED72+Al9YJaWDfbqJLi+M8khoAEx+dqV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhG6GQnz+SIKWKjvi/XIEQ9ORO+HBefxJTwMjA/hdvz/VMa0XrkPj0G+zK0F2SlT+
         mlKp2cFpbYzUHvSDMVXcbC/R7LvxcmqLfViT46JbXK91dYydF1RZ2U6+976EjFh5hM
         wII0l1wt5lGOFKgHNeX5tgZ6TR5j3uDV29w0UG0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Patryk=20Ma=C5=82ek?= <patryk.malek@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/422] i40evf: Dont enable vlan stripping when rx offload is turned on
Date:   Tue, 19 Nov 2019 06:14:39 +0100
Message-Id: <20191119051404.785783726@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patryk Małek <patryk.malek@intel.com>

[ Upstream commit 3bd77e2ae1477d6f87fc3f542c737119d5decf9f ]

With current implementation of i40evf_set_features when user sets
any offload via ethtool we set I40EVF_FLAG_AQ_ENABLE_VLAN_STRIPPING
as a required aq which triggers driver to call
i40evf_enable_vlan_stripping. This shouldn't take place.
This patches fixes it by setting the flag only when VLAN offload
is turned on.

Signed-off-by: Patryk Małek <patryk.malek@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40evf/i40evf_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_main.c b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
index bc4fa9df6da3e..3fc46d2adc087 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_main.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
@@ -3097,18 +3097,19 @@ static int i40evf_set_features(struct net_device *netdev,
 {
 	struct i40evf_adapter *adapter = netdev_priv(netdev);
 
-	/* Don't allow changing VLAN_RX flag when VLAN is set for VF
-	 * and return an error in this case
+	/* Don't allow changing VLAN_RX flag when adapter is not capable
+	 * of VLAN offload
 	 */
-	if (VLAN_ALLOWED(adapter)) {
+	if (!VLAN_ALLOWED(adapter)) {
+		if ((netdev->features ^ features) & NETIF_F_HW_VLAN_CTAG_RX)
+			return -EINVAL;
+	} else if ((netdev->features ^ features) & NETIF_F_HW_VLAN_CTAG_RX) {
 		if (features & NETIF_F_HW_VLAN_CTAG_RX)
 			adapter->aq_required |=
 				I40EVF_FLAG_AQ_ENABLE_VLAN_STRIPPING;
 		else
 			adapter->aq_required |=
 				I40EVF_FLAG_AQ_DISABLE_VLAN_STRIPPING;
-	} else if ((netdev->features ^ features) & NETIF_F_HW_VLAN_CTAG_RX) {
-		return -EINVAL;
 	}
 
 	return 0;
-- 
2.20.1




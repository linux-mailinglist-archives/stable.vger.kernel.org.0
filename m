Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2199177F49
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgCCRts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:49:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730880AbgCCRtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:49:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31EF0214D8;
        Tue,  3 Mar 2020 17:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257786;
        bh=r4NGeJpo9n1jEBQWdQe7fvt6gNYjq7LXsVhijfIB5e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0MsQQikn9CkfXtnq8poP5KofnWPx8Nc9rt9sRb/CVWQ4M2IDpGdM2mYJCUqh+iMX
         pmxfU9/w4vC++xXOY5hLvOP9BWaHQ207vXOKK+z6oMJfGyfS8ckTzupaXAgk/PMEmQ
         XgdTK1U93fhRj/OeExsbErVzz9OKa4HxrPdxUy2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikita Danilov <ndanilov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 128/176] net: atlantic: better loopback mode handling
Date:   Tue,  3 Mar 2020 18:43:12 +0100
Message-Id: <20200303174319.545640380@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

commit b42726fcf76e9367e524392e0ead7e672cc0791c upstream.

Add checks to not enable multiple loopback modes simultaneously,
It was also discovered that for dma loopback to function correctly
promisc mode should be enabled on device.

Fixes: ea4b4d7fc106 ("net: atlantic: loopback tests via private flags")
Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c       |    5 +++++
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |   13 ++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -722,6 +722,11 @@ static int aq_ethtool_set_priv_flags(str
 	if (flags & ~AQ_PRIV_FLAGS_MASK)
 		return -EOPNOTSUPP;
 
+	if (hweight32((flags | priv_flags) & AQ_HW_LOOPBACK_MASK) > 1) {
+		netdev_info(ndev, "Can't enable more than one loopback simultaneously\n");
+		return -EINVAL;
+	}
+
 	cfg->priv_flags = flags;
 
 	if ((priv_flags ^ flags) & BIT(AQ_HW_LOOPBACK_DMA_NET)) {
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -885,13 +885,16 @@ static int hw_atl_b0_hw_packet_filter_se
 {
 	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
 	unsigned int i = 0U;
+	u32 vlan_promisc;
+	u32 l2_promisc;
 
-	hw_atl_rpfl2promiscuous_mode_en_set(self,
-					    IS_FILTER_ENABLED(IFF_PROMISC));
+	l2_promisc = IS_FILTER_ENABLED(IFF_PROMISC) ||
+		     !!(cfg->priv_flags & BIT(AQ_HW_LOOPBACK_DMA_NET));
+	vlan_promisc = l2_promisc || cfg->is_vlan_force_promisc;
 
-	hw_atl_rpf_vlan_prom_mode_en_set(self,
-				     IS_FILTER_ENABLED(IFF_PROMISC) ||
-				     cfg->is_vlan_force_promisc);
+	hw_atl_rpfl2promiscuous_mode_en_set(self, l2_promisc);
+
+	hw_atl_rpf_vlan_prom_mode_en_set(self, vlan_promisc);
 
 	hw_atl_rpfl2multicast_flr_en_set(self,
 					 IS_FILTER_ENABLED(IFF_ALLMULTI) &&



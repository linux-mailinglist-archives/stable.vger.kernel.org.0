Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6EC3AEE39
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhFUQ1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231865AbhFUQZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:25:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80B63613C0;
        Mon, 21 Jun 2021 16:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292500;
        bh=mBzhU17Dv3EMuR/gEjuHo844arVn+MsquxXbgPkFOew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlHKHKk7Q0U+DO4z7Pex1illJ5j95jEyAS9p5wusQQQ0ROnIKR2QkErjbjAg4D4cx
         /8i87svHY5F5SJ2hTvy6930pms0IuMYJCigncbIjRNLlk1Oob9M1UUK2L0ho2EXymI
         BLh54k550gjq84AXlMkBeU2iAC8SbRo/c1aMFllo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/146] ice: add ndo_bpf callback for safe mode netdev ops
Date:   Mon, 21 Jun 2021 18:14:13 +0200
Message-Id: <20210621154912.060044790@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit ebc5399ea1dfcddac31974091086a3379141899b ]

ice driver requires a programmable pipeline firmware package in order to
have a support for advanced features. Otherwise, driver falls back to so
called 'safe mode'. For that mode, ndo_bpf callback is not exposed and
when user tries to load XDP program, the following happens:

$ sudo ./xdp1 enp179s0f1
libbpf: Kernel error message: Underlying driver does not support XDP in native mode
link set xdp fd failed

which is sort of confusing, as there is a native XDP support, but not in
the current mode. Improve the user experience by providing the specific
ndo_bpf callback dedicated for safe mode which will make use of extack
to explicitly let the user know that the DDP package is missing and
that's the reason that the XDP can't be loaded onto interface currently.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Fixes: efc2214b6047 ("ice: Add support for XDP")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6f30aad7695f..1567ddd4c5b8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2539,6 +2539,20 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	return (ret || xdp_ring_err) ? -ENOMEM : 0;
 }
 
+/**
+ * ice_xdp_safe_mode - XDP handler for safe mode
+ * @dev: netdevice
+ * @xdp: XDP command
+ */
+static int ice_xdp_safe_mode(struct net_device __always_unused *dev,
+			     struct netdev_bpf *xdp)
+{
+	NL_SET_ERR_MSG_MOD(xdp->extack,
+			   "Please provide working DDP firmware package in order to use XDP\n"
+			   "Refer to Documentation/networking/device_drivers/ethernet/intel/ice.rst");
+	return -EOPNOTSUPP;
+}
+
 /**
  * ice_xdp - implements XDP handler
  * @dev: netdevice
@@ -6786,6 +6800,7 @@ static const struct net_device_ops ice_netdev_safe_mode_ops = {
 	.ndo_change_mtu = ice_change_mtu,
 	.ndo_get_stats64 = ice_get_stats64,
 	.ndo_tx_timeout = ice_tx_timeout,
+	.ndo_bpf = ice_xdp_safe_mode,
 };
 
 static const struct net_device_ops ice_netdev_ops = {
-- 
2.30.2




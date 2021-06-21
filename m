Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3123AEFB7
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhFUQle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233216AbhFUQjc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:39:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF0DF613E2;
        Mon, 21 Jun 2021 16:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292997;
        bh=6WyVyJEExZGgXhAMxATUTql6TdnuUul7yCeXMGAvLa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUcTjQ8phI7QE1l5pQ9LXR5tf8gMJgt0gjSPriTRJFmDC6s/3iJdG18nJ1F9Y2ciY
         JmToA1wDRAOUNdoLkJMUuK4dkjjtO1C/ngHH2PvH1OhhB7qht4CiNNBW0apJCStqbT
         N9WE/SfqlHggAV6jYfoyoUPO0b1ToaMAJ4dI5+BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 027/178] ice: add ndo_bpf callback for safe mode netdev ops
Date:   Mon, 21 Jun 2021 18:14:01 +0200
Message-Id: <20210621154922.797502795@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
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
index d821c687f239..b61cd84be97f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2554,6 +2554,20 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
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
@@ -6805,6 +6819,7 @@ static const struct net_device_ops ice_netdev_safe_mode_ops = {
 	.ndo_change_mtu = ice_change_mtu,
 	.ndo_get_stats64 = ice_get_stats64,
 	.ndo_tx_timeout = ice_tx_timeout,
+	.ndo_bpf = ice_xdp_safe_mode,
 };
 
 static const struct net_device_ops ice_netdev_ops = {
-- 
2.30.2




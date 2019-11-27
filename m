Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDEFF10B9A0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbfK0UzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:55:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729273AbfK0UzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:55:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AC7D2070B;
        Wed, 27 Nov 2019 20:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888118;
        bh=j82QhQpXPv5+VtTXBhJZUJkVcMlz5UdcKmH4gmp6dvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbaufDDVT1Rxe946ub9EJ6pBT7dbih2iBC3zaxrcxhc5yAJee7AOxAG9gmWiQcxmQ
         KohSBJt+q7wLlDjsm2uOoLROFmYZPid4v4hr4Y7QXuu6/tYRT+e+zPELTBJ9c6IxAq
         Ld6nOapaP/aIVuiNuaXBFHEKfhuqF7qInT6KCLAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 004/306] net: rtnetlink: prevent underflows in do_setvfinfo()
Date:   Wed, 27 Nov 2019 21:27:34 +0100
Message-Id: <20191127203115.077884468@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d658c8f56ec7b3de8051a24afb25da9ba3c388c5 ]

The "ivm->vf" variable is a u32, but the problem is that a number of
drivers cast it to an int and then forget to check for negatives.  An
example of this is in the cxgb4 driver.

drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
  2890  static int cxgb4_mgmt_get_vf_config(struct net_device *dev,
  2891                                      int vf, struct ifla_vf_info *ivi)
                                            ^^^^^^
  2892  {
  2893          struct port_info *pi = netdev_priv(dev);
  2894          struct adapter *adap = pi->adapter;
  2895          struct vf_info *vfinfo;
  2896
  2897          if (vf >= adap->num_vfs)
                    ^^^^^^^^^^^^^^^^^^^
  2898                  return -EINVAL;
  2899          vfinfo = &adap->vfinfo[vf];
                ^^^^^^^^^^^^^^^^^^^^^^^^^^

There are 48 functions affected.

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:8435 hclge_set_vf_vlan_filter() warn: can 'vfid' underflow 's32min-2147483646'
drivers/net/ethernet/freescale/enetc/enetc_pf.c:377 enetc_pf_set_vf_mac() warn: can 'vf' underflow 's32min-2147483646'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:2899 cxgb4_mgmt_get_vf_config() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:2960 cxgb4_mgmt_set_vf_rate() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3019 cxgb4_mgmt_set_vf_rate() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3038 cxgb4_mgmt_set_vf_vlan() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3086 cxgb4_mgmt_set_vf_link_state() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/chelsio/cxgb/cxgb2.c:791 get_eeprom() warn: can 'i' underflow 's32min-(-4),0,4-s32max'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:82 bnxt_set_vf_spoofchk() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:164 bnxt_set_vf_trust() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:186 bnxt_get_vf_config() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:228 bnxt_set_vf_mac() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:264 bnxt_set_vf_vlan() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:293 bnxt_set_vf_bw() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c:333 bnxt_set_vf_link_state() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:2595 bnx2x_vf_op_prep() warn: can 'vfidx' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:2595 bnx2x_vf_op_prep() warn: can 'vfidx' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2281 bnx2x_post_vf_bulletin() warn: can 'vf' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2285 bnx2x_post_vf_bulletin() warn: can 'vf' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2286 bnx2x_post_vf_bulletin() warn: can 'vf' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2292 bnx2x_post_vf_bulletin() warn: can 'vf' underflow 's32min-63'
drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c:2297 bnx2x_post_vf_bulletin() warn: can 'vf' underflow 's32min-63'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:1832 qlcnic_sriov_set_vf_mac() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:1864 qlcnic_sriov_set_vf_tx_rate() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:1937 qlcnic_sriov_set_vf_vlan() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:2005 qlcnic_sriov_get_vf_config() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c:2036 qlcnic_sriov_set_vf_spoofchk() warn: can 'vf' underflow 's32min-254'
drivers/net/ethernet/emulex/benet/be_main.c:1914 be_get_vf_config() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:1915 be_get_vf_config() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:1922 be_set_vf_tvt() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:1951 be_clear_vf_tvt() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:2063 be_set_vf_tx_rate() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/emulex/benet/be_main.c:2091 be_set_vf_link_state() warn: can 'vf' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:2609 ice_set_vf_port_vlan() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:3050 ice_get_vf_cfg() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:3103 ice_set_vf_spoofchk() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:3181 ice_set_vf_mac() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:3237 ice_set_vf_trust() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c:3286 ice_set_vf_link_state() warn: can 'vf_id' underflow 's32min-65534'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3919 i40e_validate_vf() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:3957 i40e_ndo_set_vf_mac() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4104 i40e_ndo_set_vf_port_vlan() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4263 i40e_ndo_set_vf_bw() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4309 i40e_ndo_get_vf_config() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4371 i40e_ndo_set_vf_link_state() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4441 i40e_ndo_set_vf_spoofchk() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4441 i40e_ndo_set_vf_spoofchk() warn: can 'vf_id' underflow 's32min-2147483646'
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:4504 i40e_ndo_set_vf_trust() warn: can 'vf_id' underflow 's32min-2147483646'

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2126,6 +2126,8 @@ static int do_setvfinfo(struct net_devic
 	if (tb[IFLA_VF_MAC]) {
 		struct ifla_vf_mac *ivm = nla_data(tb[IFLA_VF_MAC]);
 
+		if (ivm->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_mac)
 			err = ops->ndo_set_vf_mac(dev, ivm->vf,
@@ -2137,6 +2139,8 @@ static int do_setvfinfo(struct net_devic
 	if (tb[IFLA_VF_VLAN]) {
 		struct ifla_vf_vlan *ivv = nla_data(tb[IFLA_VF_VLAN]);
 
+		if (ivv->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_vlan)
 			err = ops->ndo_set_vf_vlan(dev, ivv->vf, ivv->vlan,
@@ -2169,6 +2173,8 @@ static int do_setvfinfo(struct net_devic
 		if (len == 0)
 			return -EINVAL;
 
+		if (ivvl[0]->vf >= INT_MAX)
+			return -EINVAL;
 		err = ops->ndo_set_vf_vlan(dev, ivvl[0]->vf, ivvl[0]->vlan,
 					   ivvl[0]->qos, ivvl[0]->vlan_proto);
 		if (err < 0)
@@ -2179,6 +2185,8 @@ static int do_setvfinfo(struct net_devic
 		struct ifla_vf_tx_rate *ivt = nla_data(tb[IFLA_VF_TX_RATE]);
 		struct ifla_vf_info ivf;
 
+		if (ivt->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_get_vf_config)
 			err = ops->ndo_get_vf_config(dev, ivt->vf, &ivf);
@@ -2197,6 +2205,8 @@ static int do_setvfinfo(struct net_devic
 	if (tb[IFLA_VF_RATE]) {
 		struct ifla_vf_rate *ivt = nla_data(tb[IFLA_VF_RATE]);
 
+		if (ivt->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_rate)
 			err = ops->ndo_set_vf_rate(dev, ivt->vf,
@@ -2209,6 +2219,8 @@ static int do_setvfinfo(struct net_devic
 	if (tb[IFLA_VF_SPOOFCHK]) {
 		struct ifla_vf_spoofchk *ivs = nla_data(tb[IFLA_VF_SPOOFCHK]);
 
+		if (ivs->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_spoofchk)
 			err = ops->ndo_set_vf_spoofchk(dev, ivs->vf,
@@ -2220,6 +2232,8 @@ static int do_setvfinfo(struct net_devic
 	if (tb[IFLA_VF_LINK_STATE]) {
 		struct ifla_vf_link_state *ivl = nla_data(tb[IFLA_VF_LINK_STATE]);
 
+		if (ivl->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_link_state)
 			err = ops->ndo_set_vf_link_state(dev, ivl->vf,
@@ -2233,6 +2247,8 @@ static int do_setvfinfo(struct net_devic
 
 		err = -EOPNOTSUPP;
 		ivrssq_en = nla_data(tb[IFLA_VF_RSS_QUERY_EN]);
+		if (ivrssq_en->vf >= INT_MAX)
+			return -EINVAL;
 		if (ops->ndo_set_vf_rss_query_en)
 			err = ops->ndo_set_vf_rss_query_en(dev, ivrssq_en->vf,
 							   ivrssq_en->setting);
@@ -2243,6 +2259,8 @@ static int do_setvfinfo(struct net_devic
 	if (tb[IFLA_VF_TRUST]) {
 		struct ifla_vf_trust *ivt = nla_data(tb[IFLA_VF_TRUST]);
 
+		if (ivt->vf >= INT_MAX)
+			return -EINVAL;
 		err = -EOPNOTSUPP;
 		if (ops->ndo_set_vf_trust)
 			err = ops->ndo_set_vf_trust(dev, ivt->vf, ivt->setting);
@@ -2253,15 +2271,18 @@ static int do_setvfinfo(struct net_devic
 	if (tb[IFLA_VF_IB_NODE_GUID]) {
 		struct ifla_vf_guid *ivt = nla_data(tb[IFLA_VF_IB_NODE_GUID]);
 
+		if (ivt->vf >= INT_MAX)
+			return -EINVAL;
 		if (!ops->ndo_set_vf_guid)
 			return -EOPNOTSUPP;
-
 		return handle_vf_guid(dev, ivt, IFLA_VF_IB_NODE_GUID);
 	}
 
 	if (tb[IFLA_VF_IB_PORT_GUID]) {
 		struct ifla_vf_guid *ivt = nla_data(tb[IFLA_VF_IB_PORT_GUID]);
 
+		if (ivt->vf >= INT_MAX)
+			return -EINVAL;
 		if (!ops->ndo_set_vf_guid)
 			return -EOPNOTSUPP;
 



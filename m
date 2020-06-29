Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867F820D8C8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgF2Tll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387828AbgF2Tkr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED0512481F;
        Mon, 29 Jun 2020 15:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444339;
        bh=MCYkuFW+5XeYXr71zGuhSH25Gd1iQl/aqkrPgJdzNhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7VthXyju+5Thp9Rb+2p2l9eQJYZmFghR284PvvQ2ftO6tVn3OC8DnSAn+wnCkNvW
         jcK9mbyoKm1c98MtwjDgbZ/6UqM96ZbnEq1hlDxFcwFq4rTPSrGCXzB1rFwHHUDDfV
         UZL57C9Qkg8B6F0p15c+WJ/BmVaCRmAlB5CJH5CY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 014/178] openvswitch: take into account de-fragmentation/gso_size in execute_check_pkt_len
Date:   Mon, 29 Jun 2020 11:22:39 -0400
Message-Id: <20200629152523.2494198-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 17843655708e1941c0653af3cd61be6948e36f43 ]

ovs connection tracking module performs de-fragmentation on incoming
fragmented traffic. Take info account if traffic has been de-fragmented
in execute_check_pkt_len action otherwise we will perform the wrong
nested action considering the original packet size. This issue typically
occurs if ovs-vswitchd adds a rule in the pipeline that requires connection
tracking (e.g. OVN stateful ACLs) before execute_check_pkt_len action.
Moreover take into account GSO fragment size for GSO packet in
execute_check_pkt_len routine

Fixes: 4d5ec89fc8d14 ("net: openvswitch: Add a new action check_pkt_len")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 99352f09deaac..3d96dab104490 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1146,9 +1146,10 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
 				 struct sw_flow_key *key,
 				 const struct nlattr *attr, bool last)
 {
+	struct ovs_skb_cb *ovs_cb = OVS_CB(skb);
 	const struct nlattr *actions, *cpl_arg;
+	int len, max_len, rem = nla_len(attr);
 	const struct check_pkt_len_arg *arg;
-	int rem = nla_len(attr);
 	bool clone_flow_key;
 
 	/* The first netlink attribute in 'attr' is always
@@ -1157,7 +1158,11 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
 	cpl_arg = nla_data(attr);
 	arg = nla_data(cpl_arg);
 
-	if (skb->len <= arg->pkt_len) {
+	len = ovs_cb->mru ? ovs_cb->mru + skb->mac_len : skb->len;
+	max_len = arg->pkt_len;
+
+	if ((skb_is_gso(skb) && skb_gso_validate_mac_len(skb, max_len)) ||
+	    len <= max_len) {
 		/* Second netlink attribute in 'attr' is always
 		 * 'OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_LESS_EQUAL'.
 		 */
-- 
2.25.1


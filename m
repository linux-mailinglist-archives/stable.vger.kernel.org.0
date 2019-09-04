Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FD4A90CB
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388917AbfIDSLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389971AbfIDSLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:11:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D05352087E;
        Wed,  4 Sep 2019 18:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620702;
        bh=3PPlJtyaYmGB8nr08FGdGC9v13Bgstuekc9LvF+Trjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCvFUH0DPNmcZ7bglVOCS+IrzPUR0gNqL/OldegLB+NugUXNuOdEtFeVlPymZOIu8
         yCaef7hmRVI1nGTAgL+c9jlCuW2fAvQvaJRqjbZo05vDX/C9aZCpv6z8cV33A726eg
         e2SgXqf5Ae1qahsQc/OKn8ZpExDG4TwuHx51abcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 056/143] openvswitch: Fix conntrack cache with timeout
Date:   Wed,  4 Sep 2019 19:53:19 +0200
Message-Id: <20190904175316.266310168@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

[ Upstream commit 7177895154e6a35179d332f4a584d396c50d0612 ]

This patch addresses a conntrack cache issue with timeout policy.
Currently, we do not check if the timeout extension is set properly in the
cached conntrack entry.  Thus, after packet recirculate from conntrack
action, the timeout policy is not applied properly.  This patch fixes the
aforementioned issue.

Fixes: 06bd2bdf19d2 ("openvswitch: Add timeout support to ct action")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -67,6 +67,7 @@ struct ovs_conntrack_info {
 	struct md_mark mark;
 	struct md_labels labels;
 	char timeout[CTNL_TIMEOUT_NAME_MAX];
+	struct nf_ct_timeout *nf_ct_timeout;
 #if IS_ENABLED(CONFIG_NF_NAT)
 	struct nf_nat_range2 range;  /* Only present for SRC NAT and DST NAT. */
 #endif
@@ -697,6 +698,14 @@ static bool skb_nfct_cached(struct net *
 		if (help && rcu_access_pointer(help->helper) != info->helper)
 			return false;
 	}
+	if (info->nf_ct_timeout) {
+		struct nf_conn_timeout *timeout_ext;
+
+		timeout_ext = nf_ct_timeout_find(ct);
+		if (!timeout_ext || info->nf_ct_timeout !=
+		    rcu_dereference(timeout_ext->timeout))
+			return false;
+	}
 	/* Force conntrack entry direction to the current packet? */
 	if (info->force && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 		/* Delete the conntrack entry if confirmed, else just release
@@ -1657,6 +1666,10 @@ int ovs_ct_copy_action(struct net *net,
 				      ct_info.timeout))
 			pr_info_ratelimited("Failed to associated timeout "
 					    "policy `%s'\n", ct_info.timeout);
+		else
+			ct_info.nf_ct_timeout = rcu_dereference(
+				nf_ct_timeout_find(ct_info.ct)->timeout);
+
 	}
 
 	if (helper) {



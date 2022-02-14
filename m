Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464B04B4D6B
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349938AbiBNLHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 06:07:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349947AbiBNLGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 06:06:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED5E654BD;
        Mon, 14 Feb 2022 01:51:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31D98B80DC6;
        Mon, 14 Feb 2022 09:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEFFC340E9;
        Mon, 14 Feb 2022 09:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832264;
        bh=BbSSN1LxW+AgbdGKuAdVOOtAYMpiNGH/xDwGSjh2p90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfRJvL9FgNHZq8xw+sJdaxOq8cI+ybdQog5WpT4WLCucP3qlsHISm/3J/0ZdJS95i
         FFd5NDPzNRcGWEWW7uJkLHvBRni+NOqCC7J50yW2w8B4ipQ/t+aR7lqSWR7AoBwLms
         IBG06WHe/C16eSxIVfJzsyOflLmm3bbUhb5PfnIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pham Thanh Tuyen <phamtyn@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/172] netfilter: ctnetlink: disable helper autoassign
Date:   Mon, 14 Feb 2022 10:25:57 +0100
Message-Id: <20220214092509.825202798@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d1ca60efc53d665cf89ed847a14a510a81770b81 ]

When userspace, e.g. conntrackd, inserts an entry with a specified helper,
its possible that the helper is lost immediately after its added:

ctnetlink_create_conntrack
  -> nf_ct_helper_ext_add + assign helper
    -> ctnetlink_setup_nat
      -> ctnetlink_parse_nat_setup
         -> parse_nat_setup -> nfnetlink_parse_nat_setup
	                       -> nf_nat_setup_info
                                 -> nf_conntrack_alter_reply
                                   -> __nf_ct_try_assign_helper

... and __nf_ct_try_assign_helper will zero the helper again.

Set IPS_HELPER bit to bypass auto-assign logic, its unwanted, just like
when helper is assigned via ruleset.

Dropped old 'not strictly necessary' comment, it referred to use of
rcu_assign_pointer() before it got replaced by RCU_INIT_POINTER().

NB: Fixes tag intentionally incorrect, this extends the referenced commit,
but this change won't build without IPS_HELPER introduced there.

Fixes: 6714cf5465d280 ("netfilter: nf_conntrack: fix explicit helper attachment and NAT")
Reported-by: Pham Thanh Tuyen <phamtyn@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h | 2 +-
 net/netfilter/nf_conntrack_netlink.c               | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 4b3395082d15c..26071021e986f 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -106,7 +106,7 @@ enum ip_conntrack_status {
 	IPS_NAT_CLASH = IPS_UNTRACKED,
 #endif
 
-	/* Conntrack got a helper explicitly attached via CT target. */
+	/* Conntrack got a helper explicitly attached (ruleset, ctnetlink). */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 81d03acf68d4d..1c02be04aaf5c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2310,7 +2310,8 @@ ctnetlink_create_conntrack(struct net *net,
 			if (helper->from_nlattr)
 				helper->from_nlattr(helpinfo, ct);
 
-			/* not in hash table yet so not strictly necessary */
+			/* disable helper auto-assignment for this entry */
+			ct->status |= IPS_HELPER;
 			RCU_INIT_POINTER(help->helper, helper);
 		}
 	} else {
-- 
2.34.1




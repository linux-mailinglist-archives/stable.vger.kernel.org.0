Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2764B4A0D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiBNKbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348307AbiBNKav (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:30:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CDC6A3AD;
        Mon, 14 Feb 2022 01:59:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85162B80DC4;
        Mon, 14 Feb 2022 09:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4916C340E9;
        Mon, 14 Feb 2022 09:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832763;
        bh=8qqjLMYSvueRz7AGEphev8UfHG+Nq3FEAtl2P0/Vr4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSkfMK0LYLskW+DOkyn8TKLQUkhTMv1vZbMvuW6VIhlQ8mVflg1HgZWIHmdtBkh13
         oGzCoTF/dMxp06I+IYPtIE6sFnjmLRVl35PU8qE885ezXMwr2U/CbPbG+XkcB0PNdl
         ytSpr0qhc/fs7jcbfGFyGuwt3zao3J7LTGq9oMSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pham Thanh Tuyen <phamtyn@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 117/203] netfilter: ctnetlink: disable helper autoassign
Date:   Mon, 14 Feb 2022 10:26:01 +0100
Message-Id: <20220214092514.230071345@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
index ec4164c32d270..2d7f63ad33604 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2311,7 +2311,8 @@ ctnetlink_create_conntrack(struct net *net,
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




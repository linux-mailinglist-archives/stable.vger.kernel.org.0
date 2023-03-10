Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C626B41FD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjCJN6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjCJN6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:58:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E4920064
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8FAD616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9533C433EF;
        Fri, 10 Mar 2023 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456710;
        bh=9UuA0A+uAEMCOOHAMnFMS3nJj5Mltkmgd75S2/vbRTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAdpBxBqTFosq3rahPBEs7c56VU+xYcbq9uoM63B6ruo+lZKCQubXpgRerc1O3BLL
         C/sF+EnTc/b4X5eVikQqNXGferCL3bJ5TmBIIC/XVeRKU7KkdyWKu1iRU0fUl4W1uo
         rt7udlTEhACgL8VoVAAnf0uo21l4rxVDm4lCWnHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 096/211] net/sched: act_mpls: fix action bind logic
Date:   Fri, 10 Mar 2023 14:37:56 +0100
Message-Id: <20230310133721.696760904@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit e88d78a773cb5242e933930c8855bf4b2e8c2397 ]

The TC architecture allows filters and actions to be created independently.
In filters the user can reference action objects using:
tc action add action mpls ... index 1
tc filter add ... action mpls index 1

In the current code for act_mpls this is broken as it checks netlink
attributes for create/update before actually checking if we are binding to an
existing action.

tdc results:
1..53
ok 1 a933 - Add MPLS dec_ttl action with pipe opcode
ok 2 08d1 - Add mpls dec_ttl action with pass opcode
ok 3 d786 - Add mpls dec_ttl action with drop opcode
ok 4 f334 - Add mpls dec_ttl action with reclassify opcode
ok 5 29bd - Add mpls dec_ttl action with continue opcode
ok 6 48df - Add mpls dec_ttl action with jump opcode
ok 7 62eb - Add mpls dec_ttl action with trap opcode
ok 8 09d2 - Add mpls dec_ttl action with opcode and cookie
ok 9 c170 - Add mpls dec_ttl action with opcode and cookie of max length
ok 10 9118 - Add mpls dec_ttl action with invalid opcode
ok 11 6ce1 - Add mpls dec_ttl action with label (invalid)
ok 12 352f - Add mpls dec_ttl action with tc (invalid)
ok 13 fa1c - Add mpls dec_ttl action with ttl (invalid)
ok 14 6b79 - Add mpls dec_ttl action with bos (invalid)
ok 15 d4c4 - Add mpls pop action with ip proto
ok 16 91fb - Add mpls pop action with ip proto and cookie
ok 17 92fe - Add mpls pop action with mpls proto
ok 18 7e23 - Add mpls pop action with no protocol (invalid)
ok 19 6182 - Add mpls pop action with label (invalid)
ok 20 6475 - Add mpls pop action with tc (invalid)
ok 21 067b - Add mpls pop action with ttl (invalid)
ok 22 7316 - Add mpls pop action with bos (invalid)
ok 23 38cc - Add mpls push action with label
ok 24 c281 - Add mpls push action with mpls_mc protocol
ok 25 5db4 - Add mpls push action with label, tc and ttl
ok 26 7c34 - Add mpls push action with label, tc ttl and cookie of max length
ok 27 16eb - Add mpls push action with label and bos
ok 28 d69d - Add mpls push action with no label (invalid)
ok 29 e8e4 - Add mpls push action with ipv4 protocol (invalid)
ok 30 ecd0 - Add mpls push action with out of range label (invalid)
ok 31 d303 - Add mpls push action with out of range tc (invalid)
ok 32 fd6e - Add mpls push action with ttl of 0 (invalid)
ok 33 19e9 - Add mpls mod action with mpls label
ok 34 1fde - Add mpls mod action with max mpls label
ok 35 0c50 - Add mpls mod action with mpls label exceeding max (invalid)
ok 36 10b6 - Add mpls mod action with mpls label of MPLS_LABEL_IMPLNULL (invalid)
ok 37 57c9 - Add mpls mod action with mpls min tc
ok 38 6872 - Add mpls mod action with mpls max tc
ok 39 a70a - Add mpls mod action with mpls tc exceeding max (invalid)
ok 40 6ed5 - Add mpls mod action with mpls ttl
ok 41 77c1 - Add mpls mod action with mpls ttl and cookie
ok 42 b80f - Add mpls mod action with mpls max ttl
ok 43 8864 - Add mpls mod action with mpls min ttl
ok 44 6c06 - Add mpls mod action with mpls ttl of 0 (invalid)
ok 45 b5d8 - Add mpls mod action with mpls ttl exceeding max (invalid)
ok 46 451f - Add mpls mod action with mpls max bos
ok 47 a1ed - Add mpls mod action with mpls min bos
ok 48 3dcf - Add mpls mod action with mpls bos exceeding max (invalid)
ok 49 db7c - Add mpls mod action with protocol (invalid)
ok 50 b070 - Replace existing mpls push action with new ID
ok 51 95a9 - Replace existing mpls push action with new label, tc, ttl and cookie
ok 52 6cce - Delete mpls pop action
ok 53 d138 - Flush mpls actions

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mpls.c | 66 +++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 29 deletions(-)

diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 6b26bdb999d77..809f7928a1be6 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -190,40 +190,67 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 	parm = nla_data(tb[TCA_MPLS_PARMS]);
 	index = parm->index;
 
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
+	if (err < 0)
+		return err;
+	exists = err;
+	if (exists && bind)
+		return 0;
+
+	if (!exists) {
+		ret = tcf_idr_create(tn, index, est, a, &act_mpls_ops, bind,
+				     true, flags);
+		if (ret) {
+			tcf_idr_cleanup(tn, index);
+			return ret;
+		}
+
+		ret = ACT_P_CREATED;
+	} else if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
+		tcf_idr_release(*a, bind);
+		return -EEXIST;
+	}
+
 	/* Verify parameters against action type. */
 	switch (parm->m_action) {
 	case TCA_MPLS_ACT_POP:
 		if (!tb[TCA_MPLS_PROTO]) {
 			NL_SET_ERR_MSG_MOD(extack, "Protocol must be set for MPLS pop");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		if (!eth_proto_is_802_3(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
 			NL_SET_ERR_MSG_MOD(extack, "Invalid protocol type for MPLS pop");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		if (tb[TCA_MPLS_LABEL] || tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC] ||
 		    tb[TCA_MPLS_BOS]) {
 			NL_SET_ERR_MSG_MOD(extack, "Label, TTL, TC or BOS cannot be used with MPLS pop");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		break;
 	case TCA_MPLS_ACT_DEC_TTL:
 		if (tb[TCA_MPLS_PROTO] || tb[TCA_MPLS_LABEL] ||
 		    tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC] || tb[TCA_MPLS_BOS]) {
 			NL_SET_ERR_MSG_MOD(extack, "Label, TTL, TC, BOS or protocol cannot be used with MPLS dec_ttl");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		break;
 	case TCA_MPLS_ACT_PUSH:
 	case TCA_MPLS_ACT_MAC_PUSH:
 		if (!tb[TCA_MPLS_LABEL]) {
 			NL_SET_ERR_MSG_MOD(extack, "Label is required for MPLS push");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		if (tb[TCA_MPLS_PROTO] &&
 		    !eth_p_mpls(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
 			NL_SET_ERR_MSG_MOD(extack, "Protocol must be an MPLS type for MPLS push");
-			return -EPROTONOSUPPORT;
+			err = -EPROTONOSUPPORT;
+			goto release_idr;
 		}
 		/* Push needs a TTL - if not specified, set a default value. */
 		if (!tb[TCA_MPLS_TTL]) {
@@ -238,33 +265,14 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 	case TCA_MPLS_ACT_MODIFY:
 		if (tb[TCA_MPLS_PROTO]) {
 			NL_SET_ERR_MSG_MOD(extack, "Protocol cannot be used with MPLS modify");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		break;
 	default:
 		NL_SET_ERR_MSG_MOD(extack, "Unknown MPLS action");
-		return -EINVAL;
-	}
-
-	err = tcf_idr_check_alloc(tn, &index, a, bind);
-	if (err < 0)
-		return err;
-	exists = err;
-	if (exists && bind)
-		return 0;
-
-	if (!exists) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mpls_ops, bind, true, flags);
-		if (ret) {
-			tcf_idr_cleanup(tn, index);
-			return ret;
-		}
-
-		ret = ACT_P_CREATED;
-	} else if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
-		tcf_idr_release(*a, bind);
-		return -EEXIST;
+		err = -EINVAL;
+		goto release_idr;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
-- 
2.39.2




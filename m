Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919EC56FBB8
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiGKJeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbiGKJeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:34:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0AE4AD52;
        Mon, 11 Jul 2022 02:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDDD7B80E6D;
        Mon, 11 Jul 2022 09:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E245C34115;
        Mon, 11 Jul 2022 09:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531100;
        bh=x+n02lqPWItvAjdGSPkEYYyeV0aQ4CySBYUYedRQtTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwJwEobcxbDXDcJg70puIIN0VrNVaakxJmk/qmfaykGgMStWNZvat+cahroApA8AG
         wimkABs/SlWYFyoMhbAaQFzLZ9jdXg1YCaLT9m0E3pcEyH+D+h++SdnaafsyNjxWmn
         IIPf9l3x4kDME0Q+8/77zMflycXoyj9w1PmLGs5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 096/112] net/sched: act_police: Add extack messages for offload failure
Date:   Mon, 11 Jul 2022 11:07:36 +0200
Message-Id: <20220711090552.294762568@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit b50e462bc22df4488ec04d85606646e3db5952b8 ]

For better error reporting to user space, add extack messages when
police action offload fails.

Example:

 # echo 1 > /sys/kernel/tracing/events/netlink/netlink_extack/enable

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action police rate 100Mbit burst 10000
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-182     [000] b..1.    21.592969: netlink_extack: msg=act_police: Offload not supported when conform/exceed action is "reclassify"
       tc-182     [000] .....    21.592982: netlink_extack: msg=cls_matchall: Failed to setup flow action

 # tc filter add dev dummy0 ingress pref 1 proto all matchall skip_sw action police rate 100Mbit burst 10000 conform-exceed drop/continue
 Error: cls_matchall: Failed to setup flow action.
 We have an error talking to the kernel

 # cat /sys/kernel/tracing/trace_pipe
       tc-184     [000] b..1.    38.882579: netlink_extack: msg=act_police: Offload not supported when conform/exceed action is "continue"
       tc-184     [000] .....    38.882593: netlink_extack: msg=cls_matchall: Failed to setup flow action

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_police.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 77c17e9b46d1..79c8901f66ab 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -419,7 +419,8 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
-static int tcf_police_act_to_flow_act(int tc_act, u32 *extval)
+static int tcf_police_act_to_flow_act(int tc_act, u32 *extval,
+				      struct netlink_ext_ack *extack)
 {
 	int act_id = -EOPNOTSUPP;
 
@@ -430,12 +431,20 @@ static int tcf_police_act_to_flow_act(int tc_act, u32 *extval)
 			act_id = FLOW_ACTION_DROP;
 		else if (tc_act == TC_ACT_PIPE)
 			act_id = FLOW_ACTION_PIPE;
+		else if (tc_act == TC_ACT_RECLASSIFY)
+			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when conform/exceed action is \"reclassify\"");
+		else
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported conform/exceed action offload");
 	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_GOTO_CHAIN)) {
 		act_id = FLOW_ACTION_GOTO;
 		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
 	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_JUMP)) {
 		act_id = FLOW_ACTION_JUMP;
 		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
+	} else if (tc_act == TC_ACT_UNSPEC) {
+		NL_SET_ERR_MSG_MOD(extack, "Offload not supported when conform/exceed action is \"continue\"");
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported conform/exceed action offload");
 	}
 
 	return act_id;
@@ -467,14 +476,16 @@ static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
 		entry->police.mtu = tcf_police_tcfp_mtu(act);
 
 		act_id = tcf_police_act_to_flow_act(police->tcf_action,
-						    &entry->police.exceed.extval);
+						    &entry->police.exceed.extval,
+						    extack);
 		if (act_id < 0)
 			return act_id;
 
 		entry->police.exceed.act_id = act_id;
 
 		act_id = tcf_police_act_to_flow_act(p->tcfp_result,
-						    &entry->police.notexceed.extval);
+						    &entry->police.notexceed.extval,
+						    extack);
 		if (act_id < 0)
 			return act_id;
 
-- 
2.35.1




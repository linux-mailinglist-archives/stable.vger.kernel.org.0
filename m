Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22C869CDDE
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjBTNxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbjBTNxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:53:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A18C1CAE3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:53:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A929160E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBCCC433EF;
        Mon, 20 Feb 2023 13:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901221;
        bh=cIkvjKeT4PtZ4G0y/YYsOSAmMmk+jGVL3klohv1Cjg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OemdiIn4jv5fh1XARS8D35u3TncLeqoz5wQfjrvTY9gr7XuxCMCNEdLLAIkJ5gSGk
         LMQ+R2M6sSUFM1ZyG3+pFYvGbc2GpLMDdhHEYjpOeRPe4U0thKeGP9iEfgA/jp4tjN
         yX2DEFwe0BclHJLJIWGah4Yc7SLTXUTd4HphI56U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 76/83] net/sched: act_ctinfo: use percpu stats
Date:   Mon, 20 Feb 2023 14:36:49 +0100
Message-Id: <20230220133556.351328467@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 21c167aa0ba943a7cac2f6969814f83bb701666b ]

The tc action act_ctinfo was using shared stats, fix it to use percpu stats
since bstats_update() must be called with locks or with a percpu pointer argument.

tdc results:
1..12
ok 1 c826 - Add ctinfo action with default setting
ok 2 0286 - Add ctinfo action with dscp
ok 3 4938 - Add ctinfo action with valid cpmark and zone
ok 4 7593 - Add ctinfo action with drop control
ok 5 2961 - Replace ctinfo action zone and action control
ok 6 e567 - Delete ctinfo action with valid index
ok 7 6a91 - Delete ctinfo action with invalid index
ok 8 5232 - List ctinfo actions
ok 9 7702 - Flush ctinfo actions
ok 10 3201 - Add ctinfo action with duplicate index
ok 11 8295 - Add ctinfo action with invalid index
ok 12 3964 - Replace ctinfo action with invalid goto_chain control

Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://lore.kernel.org/r/20230210200824.444856-1-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ctinfo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 65a20f3c9514e..56e0a5eb64942 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -92,7 +92,7 @@ static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
 	cp = rcu_dereference_bh(ca->params);
 
 	tcf_lastuse_update(&ca->tcf_tm);
-	bstats_update(&ca->tcf_bstats, skb);
+	tcf_action_update_bstats(&ca->common, skb);
 	action = READ_ONCE(ca->tcf_action);
 
 	wlen = skb_network_offset(skb);
@@ -211,8 +211,8 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	index = actparm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_ctinfo_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_ctinfo_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
-- 
2.39.0




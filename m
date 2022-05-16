Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE2F528F0B
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241584AbiEPTue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346453AbiEPTt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:49:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C9E43AF2;
        Mon, 16 May 2022 12:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33E30B815F6;
        Mon, 16 May 2022 19:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3EFC385AA;
        Mon, 16 May 2022 19:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730312;
        bh=elYD8fjMUZjLGbxsKLKL6KOqN9jdSSD/fSjASIUWHZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZ1bpU5Uen8osIZNZuc8m89kvouvwGBeR3t/+hdvfqmADhqUmr64UEeTK6x/mU37t
         jNAiLdDQAOQPzKDOqcKaH0VQO+uhFfMCwOzX5W2gV30Q28OsbzcP+3GtR2xMRvxoLM
         dIDS0B5tcDA3iOgliueUT/F53W0u5YKujRH06Whc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/66] net/sched: act_pedit: really ensure the skb is writable
Date:   Mon, 16 May 2022 21:36:24 +0200
Message-Id: <20220516193620.115452297@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 8b796475fd7882663a870456466a4fb315cc1bd6 ]

Currently pedit tries to ensure that the accessed skb offset
is writable via skb_unclone(). The action potentially allows
touching any skb bytes, so it may end-up modifying shared data.

The above causes some sporadic MPTCP self-test failures, due to
this code:

	tc -n $ns2 filter add dev ns2eth$i egress \
		protocol ip prio 1000 \
		handle 42 fw \
		action pedit munge offset 148 u8 invert \
		pipe csum tcp \
		index 100

The above modifies a data byte outside the skb head and the skb is
a cloned one, carrying a TCP output packet.

This change addresses the issue by keeping track of a rough
over-estimate highest skb offset accessed by the action and ensuring
such offset is really writable.

Note that this may cause performance regressions in some scenarios,
but hopefully pedit is not in the critical path.

Fixes: db2c24175d14 ("act_pedit: access skb->data safely")
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/1fcf78e6679d0a287dd61bb0f04730ce33b3255d.1652194627.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_pedit.h |  1 +
 net/sched/act_pedit.c         | 26 ++++++++++++++++++++++----
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
index 748cf87a4d7e..3e02709a1df6 100644
--- a/include/net/tc_act/tc_pedit.h
+++ b/include/net/tc_act/tc_pedit.h
@@ -14,6 +14,7 @@ struct tcf_pedit {
 	struct tc_action	common;
 	unsigned char		tcfp_nkeys;
 	unsigned char		tcfp_flags;
+	u32			tcfp_off_max_hint;
 	struct tc_pedit_key	*tcfp_keys;
 	struct tcf_pedit_key_ex	*tcfp_keys_ex;
 };
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index b45304446e13..90510298b32a 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -149,7 +149,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	struct nlattr *pattr;
 	struct tcf_pedit *p;
 	int ret = 0, err;
-	int ksize;
+	int i, ksize;
 	u32 index;
 
 	if (!nla) {
@@ -228,6 +228,18 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		p->tcfp_nkeys = parm->nkeys;
 	}
 	memcpy(p->tcfp_keys, parm->keys, ksize);
+	p->tcfp_off_max_hint = 0;
+	for (i = 0; i < p->tcfp_nkeys; ++i) {
+		u32 cur = p->tcfp_keys[i].off;
+
+		/* The AT option can read a single byte, we can bound the actual
+		 * value with uchar max.
+		 */
+		cur += (0xff & p->tcfp_keys[i].offmask) >> p->tcfp_keys[i].shift;
+
+		/* Each key touches 4 bytes starting from the computed offset */
+		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
+	}
 
 	p->tcfp_flags = parm->flags;
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -308,13 +320,18 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 			 struct tcf_result *res)
 {
 	struct tcf_pedit *p = to_pedit(a);
+	u32 max_offset;
 	int i;
 
-	if (skb_unclone(skb, GFP_ATOMIC))
-		return p->tcf_action;
-
 	spin_lock(&p->tcf_lock);
 
+	max_offset = (skb_transport_header_was_set(skb) ?
+		      skb_transport_offset(skb) :
+		      skb_network_offset(skb)) +
+		     p->tcfp_off_max_hint;
+	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
+		goto unlock;
+
 	tcf_lastuse_update(&p->tcf_tm);
 
 	if (p->tcfp_nkeys > 0) {
@@ -403,6 +420,7 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 	p->tcf_qstats.overlimits++;
 done:
 	bstats_update(&p->tcf_bstats, skb);
+unlock:
 	spin_unlock(&p->tcf_lock);
 	return p->tcf_action;
 }
-- 
2.35.1




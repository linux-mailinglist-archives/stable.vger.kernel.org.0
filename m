Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE8369B9B5
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 12:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBRLWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 06:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBRLWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 06:22:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1BF1B4
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 03:22:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D505560AEF
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 11:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0E1C433EF;
        Sat, 18 Feb 2023 11:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676719332;
        bh=6Suo9c7vRUpn718z9yBWbxqb5PNjlq58O9Xmswjt3Nc=;
        h=Subject:To:Cc:From:Date:From;
        b=kz1AkXLM2xpy2eZCirIe8h7bFvg7mAbFgmGTx9M+KCcjV8HghW2Jjdf01cu3ckKgo
         THYMTKOFQeBusqAEsRwkvIFr2ZXVZmTFY3Pf9hVBfP5U8k5EsV306YqRhEoCyvbeAN
         NfNWer/SCPwD7y/tClLQ8RPUiyYMYn737ApbOIUo=
Subject: FAILED: patch "[PATCH] net/sched: act_ctinfo: use percpu stats" failed to apply to 5.15-stable tree
To:     pctammela@mojatatu.com, jhs@mojatatu.com, kuba@kernel.org,
        larysa.zaremba@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Feb 2023 12:22:09 +0100
Message-ID: <167671932914420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

21c167aa0ba9 ("net/sched: act_ctinfo: use percpu stats")
40bd094d65fc ("flow_offload: fill flags to action structure")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 21c167aa0ba943a7cac2f6969814f83bb701666b Mon Sep 17 00:00:00 2001
From: Pedro Tammela <pctammela@mojatatu.com>
Date: Fri, 10 Feb 2023 17:08:25 -0300
Subject: [PATCH] net/sched: act_ctinfo: use percpu stats

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

diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 4b1b59da5c0b..4d15b6a6169c 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -93,7 +93,7 @@ TC_INDIRECT_SCOPE int tcf_ctinfo_act(struct sk_buff *skb,
 	cp = rcu_dereference_bh(ca->params);
 
 	tcf_lastuse_update(&ca->tcf_tm);
-	bstats_update(&ca->tcf_bstats, skb);
+	tcf_action_update_bstats(&ca->common, skb);
 	action = READ_ONCE(ca->tcf_action);
 
 	wlen = skb_network_offset(skb);
@@ -212,8 +212,8 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
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


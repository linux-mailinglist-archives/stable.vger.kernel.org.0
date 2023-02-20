Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5BD69CDE3
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjBTNxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbjBTNxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:53:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AB41D930
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96B6AB80B4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A965C433EF;
        Mon, 20 Feb 2023 13:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901226;
        bh=YWED7BKr75/WFBur95Zx0AtVxFD19dmzh5P3McXo8+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OilPVl60GSmhqiDTjnfbU/uLWdbk39CgO5GSkUQ2hyL510UDIqhJdtEaIV8xZ5wQ6
         sD+1Aq5osY36K0nviJMxu/va00Hl1t3lzSR7GJqNgfsj57Wh8uTJHbF2iu+uvBlpf2
         u0z36kSv+l4Bf7Kya5272xxPbX/rdJh6JOR9nB5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, valis <sec@valis.email>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 60/83] net/sched: tcindex: update imperfect hash filters respecting rcu
Date:   Mon, 20 Feb 2023 14:36:33 +0100
Message-Id: <20230220133555.769278388@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pedro Tammela <pctammela@mojatatu.com>

commit ee059170b1f7e94e55fa6cadee544e176a6e59c2 upstream.

The imperfect hash area can be updated while packets are traversing,
which will cause a use-after-free when 'tcf_exts_exec()' is called
with the destroyed tcf_ext.

CPU 0:               CPU 1:
tcindex_set_parms    tcindex_classify
tcindex_lookup
                     tcindex_lookup
tcf_exts_change
                     tcf_exts_exec [UAF]

Stop operating on the shared area directly, by using a local copy,
and update the filter with 'rcu_replace_pointer()'. Delete the old
filter version only after a rcu grace period elapsed.

Fixes: 9b0d4446b569 ("net: sched: avoid atomic swap in tcf_exts_change")
Reported-by: valis <sec@valis.email>
Suggested-by: valis <sec@valis.email>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://lore.kernel.org/r/20230209143739.279867-1-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_tcindex.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
+#include <linux/rcupdate.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
@@ -338,6 +339,7 @@ tcindex_set_parms(struct net *net, struc
 	struct tcf_result cr = {};
 	int err, balloc = 0;
 	struct tcf_exts e;
+	bool update_h = false;
 
 	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
 	if (err < 0)
@@ -455,10 +457,13 @@ tcindex_set_parms(struct net *net, struc
 		}
 	}
 
-	if (cp->perfect)
+	if (cp->perfect) {
 		r = cp->perfect + handle;
-	else
-		r = tcindex_lookup(cp, handle) ? : &new_filter_result;
+	} else {
+		/* imperfect area is updated in-place using rcu */
+		update_h = !!tcindex_lookup(cp, handle);
+		r = &new_filter_result;
+	}
 
 	if (r == &new_filter_result) {
 		f = kzalloc(sizeof(*f), GFP_KERNEL);
@@ -484,7 +489,28 @@ tcindex_set_parms(struct net *net, struc
 
 	rcu_assign_pointer(tp->root, cp);
 
-	if (r == &new_filter_result) {
+	if (update_h) {
+		struct tcindex_filter __rcu **fp;
+		struct tcindex_filter *cf;
+
+		f->result.res = r->res;
+		tcf_exts_change(&f->result.exts, &r->exts);
+
+		/* imperfect area bucket */
+		fp = cp->h + (handle % cp->hash);
+
+		/* lookup the filter, guaranteed to exist */
+		for (cf = rcu_dereference_bh_rtnl(*fp); cf;
+		     fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
+			if (cf->key == handle)
+				break;
+
+		f->next = cf->next;
+
+		cf = rcu_replace_pointer(*fp, f, 1);
+		tcf_exts_get_net(&cf->result.exts);
+		tcf_queue_work(&cf->rwork, tcindex_destroy_fexts_work);
+	} else if (r == &new_filter_result) {
 		struct tcindex_filter *nfp;
 		struct tcindex_filter __rcu **fp;
 



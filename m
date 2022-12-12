Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D2164A1BB
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbiLLNoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbiLLNn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A66D6C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:43:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E8DD6106C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3076C433D2;
        Mon, 12 Dec 2022 13:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852629;
        bh=Ho6aLkLDumGSpP5eYGA2yhkvLgYVF/hmgZSgghT44Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRLVK+GuGjWVvEHhnBvxMEKmH+1Fy/jsd2wohK47i6b2Icajsoch8tiCihFoY9DPQ
         22L5l6pxaWs5UhH+9PaW9L7MMCzOCNNmSpYYvOOPSB1MiqWEPahLsxsl7uZ1v0mQQR
         AdJAhXY5cEH8yAkI+1I2RoskDPr/HSTRptUunKm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Ivan Babrou <ivan@ivan.computer>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 094/157] netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark
Date:   Mon, 12 Dec 2022 14:17:22 +0100
Message-Id: <20221212130938.592859020@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 1feeae071507ad65cf9f462a1bdd543a4bf89e71 ]

All warnings (new ones prefixed by >>):

   net/netfilter/nf_conntrack_netlink.c: In function '__ctnetlink_glue_build':
>> net/netfilter/nf_conntrack_netlink.c:2674:13: warning: unused variable 'mark' [-Wunused-variable]
    2674 |         u32 mark;
         |             ^~~~

Fixes: 52d1aa8b8249 ("netfilter: conntrack: Fix data-races around ct mark")
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Ivan Babrou <ivan@ivan.computer>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d71150a40fb0..1286ae7d4609 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -328,8 +328,13 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, u32 mark)
+static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 {
+	u32 mark = READ_ONCE(ct->mark);
+
+	if (!mark)
+		return 0;
+
 	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
 		goto nla_put_failure;
 	return 0;
@@ -543,7 +548,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, READ_ONCE(ct->mark)) < 0 ||
+	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -722,7 +727,6 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
-	u32 mark;
 	int err;
 
 	if (events & (1 << IPCT_DESTROY)) {
@@ -827,9 +831,8 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	mark = READ_ONCE(ct->mark);
-	if ((events & (1 << IPCT_MARK) || mark) &&
-	    ctnetlink_dump_mark(skb, mark) < 0)
+	if (events & (1 << IPCT_MARK) &&
+	    ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -2671,7 +2674,6 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
-	u32 mark;
 
 	zone = nf_ct_zone(ct);
 
@@ -2733,8 +2735,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	mark = READ_ONCE(ct->mark);
-	if (mark && ctnetlink_dump_mark(skb, mark) < 0)
+	if (ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
-- 
2.35.1




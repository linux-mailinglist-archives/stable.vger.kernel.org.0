Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4EC64A0BC
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiLLN3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiLLN3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:29:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024D6132
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:29:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9625E61025
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BEEC433F1;
        Mon, 12 Dec 2022 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851773;
        bh=dSTvkbl7td0zpHjnORlRYdPitxf6p3PqyX/lI0jEeiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGCgikwNQVpNQZW5EC8quAx8Pg4y8egJSOY6hDGGwDQoRuPg8g7m0A+4YV+XqGroT
         GTO1EDuLijgsNCHaxvyV+mHvS5qGJuytCkuyMgnGi0J2tFl2BmV/wi2mR6LPVotnTn
         TZIQrHICyyWraS7eDe7j5z8csbkbQ/0J86DN/QCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Ivan Babrou <ivan@ivan.computer>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/123] netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark
Date:   Mon, 12 Dec 2022 14:17:13 +0100
Message-Id: <20221212130929.764219762@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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
index 1727a4c4764f..2cc6092b4f86 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -322,8 +322,13 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
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
@@ -537,7 +542,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, READ_ONCE(ct->mark)) < 0 ||
+	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -716,7 +721,6 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
-	u32 mark;
 	int err;
 
 	if (events & (1 << IPCT_DESTROY)) {
@@ -821,9 +825,8 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
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
@@ -2692,7 +2695,6 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
-	u32 mark;
 
 	zone = nf_ct_zone(ct);
 
@@ -2754,8 +2756,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
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




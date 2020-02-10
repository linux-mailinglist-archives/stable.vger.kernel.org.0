Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E36D415785C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgBJNHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:07:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbgBJMjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:46 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 061AF20842;
        Mon, 10 Feb 2020 12:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338386;
        bh=z2Wr99/hnxhyJFTdoxttMlAbVjx2g25LtoZuj0j3cIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHdl400uVAw4T9H+rMIsixzN+1Xcv2B6NlgxmyOCaw2i9UITMjuBu7Xdd0Z4c5P3N
         mpjGAT2gwtMT0MYUaDgZjHBqhev3/Ol0zrIDVUPgm/KcpRY/PEooyKU3iTu0PT8e6u
         q8g54H8j8O46Ohitfhl8plK65RUdtXVsTwrf8oMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.5 029/367] netfilter: ipset: fix suspicious RCU usage in find_set_and_id
Date:   Mon, 10 Feb 2020 04:29:02 -0800
Message-Id: <20200210122426.592428008@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kadlecsik József <kadlec@blackhole.kfki.hu>

commit 5038517119d50ed0240059b1d7fc2faa92371c08 upstream.

find_set_and_id() is called when the NFNL_SUBSYS_IPSET mutex is held.
However, in the error path there can be a follow-up recvmsg() without
the mutex held. Use the start() function of struct netlink_dump_control
instead of dump() to verify and report if the specified set does not
exist.

Thanks to Pablo Neira Ayuso for helping me to understand the subleties
of the netlink protocol.

Reported-by: syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipset/ip_set_core.c |   41 +++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1483,31 +1483,34 @@ ip_set_dump_policy[IPSET_ATTR_CMD_MAX +
 };
 
 static int
-dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
+ip_set_dump_start(struct netlink_callback *cb)
 {
 	struct nlmsghdr *nlh = nlmsg_hdr(cb->skb);
 	int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 	struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
 	struct nlattr *attr = (void *)nlh + min_len;
+	struct sk_buff *skb = cb->skb;
+	struct ip_set_net *inst = ip_set_pernet(sock_net(skb->sk));
 	u32 dump_type;
-	ip_set_id_t index;
 	int ret;
 
 	ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, attr,
 			nlh->nlmsg_len - min_len,
 			ip_set_dump_policy, NULL);
 	if (ret)
-		return ret;
+		goto error;
 
 	cb->args[IPSET_CB_PROTO] = nla_get_u8(cda[IPSET_ATTR_PROTOCOL]);
 	if (cda[IPSET_ATTR_SETNAME]) {
+		ip_set_id_t index;
 		struct ip_set *set;
 
 		set = find_set_and_id(inst, nla_data(cda[IPSET_ATTR_SETNAME]),
 				      &index);
-		if (!set)
-			return -ENOENT;
-
+		if (!set) {
+			ret = -ENOENT;
+			goto error;
+		}
 		dump_type = DUMP_ONE;
 		cb->args[IPSET_CB_INDEX] = index;
 	} else {
@@ -1523,10 +1526,17 @@ dump_init(struct netlink_callback *cb, s
 	cb->args[IPSET_CB_DUMP] = dump_type;
 
 	return 0;
+
+error:
+	/* We have to create and send the error message manually :-( */
+	if (nlh->nlmsg_flags & NLM_F_ACK) {
+		netlink_ack(cb->skb, nlh, ret, NULL);
+	}
+	return ret;
 }
 
 static int
-ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
+ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	ip_set_id_t index = IPSET_INVALID_ID, max;
 	struct ip_set *set = NULL;
@@ -1537,18 +1547,8 @@ ip_set_dump_start(struct sk_buff *skb, s
 	bool is_destroyed;
 	int ret = 0;
 
-	if (!cb->args[IPSET_CB_DUMP]) {
-		ret = dump_init(cb, inst);
-		if (ret < 0) {
-			nlh = nlmsg_hdr(cb->skb);
-			/* We have to create and send the error message
-			 * manually :-(
-			 */
-			if (nlh->nlmsg_flags & NLM_F_ACK)
-				netlink_ack(cb->skb, nlh, ret, NULL);
-			return ret;
-		}
-	}
+	if (!cb->args[IPSET_CB_DUMP])
+		return -EINVAL;
 
 	if (cb->args[IPSET_CB_INDEX] >= inst->ip_set_max)
 		goto out;
@@ -1684,7 +1684,8 @@ static int ip_set_dump(struct net *net,
 
 	{
 		struct netlink_dump_control c = {
-			.dump = ip_set_dump_start,
+			.start = ip_set_dump_start,
+			.dump = ip_set_dump_do,
 			.done = ip_set_dump_done,
 		};
 		return netlink_dump_start(ctnl, skb, nlh, &c);



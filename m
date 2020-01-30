Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E0F14E150
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbgA3SnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:43:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730206AbgA3SnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BA2B20702;
        Thu, 30 Jan 2020 18:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409802;
        bh=4r41XwWnQLvKXg6Y4MxWnONC3/blYPnIxwt0j11V8nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/WIenSWuemwcJHUXZaXcguTfvQTa1Q0BOmkCCUjUpLMN1Uhzytogj0vnf9dHL4fC
         dzKl+gwoMqyASXreUNu4PtwXzojUBZ+pawXJraEGMCZtHc3a6HaVTpD+ldk01Kq/SP
         qe/dY2SD6ciqrnh1qhxjSa5zxTo0xDRlvaDsguE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 037/110] net_sched: walk through all child classes in tc_bind_tclass()
Date:   Thu, 30 Jan 2020 19:38:13 +0100
Message-Id: <20200130183619.765651904@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 760d228e322e99cdf6d81b4b60a268b8f13cf67a ]

In a complex TC class hierarchy like this:

tc qdisc add dev eth0 root handle 1:0 cbq bandwidth 100Mbit         \
  avpkt 1000 cell 8
tc class add dev eth0 parent 1:0 classid 1:1 cbq bandwidth 100Mbit  \
  rate 6Mbit weight 0.6Mbit prio 8 allot 1514 cell 8 maxburst 20      \
  avpkt 1000 bounded

tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip \
  sport 80 0xffff flowid 1:3
tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip \
  sport 25 0xffff flowid 1:4

tc class add dev eth0 parent 1:1 classid 1:3 cbq bandwidth 100Mbit  \
  rate 5Mbit weight 0.5Mbit prio 5 allot 1514 cell 8 maxburst 20      \
  avpkt 1000
tc class add dev eth0 parent 1:1 classid 1:4 cbq bandwidth 100Mbit  \
  rate 3Mbit weight 0.3Mbit prio 5 allot 1514 cell 8 maxburst 20      \
  avpkt 1000

where filters are installed on qdisc 1:0, so we can't merely
search from class 1:1 when creating class 1:3 and class 1:4. We have
to walk through all the child classes of the direct parent qdisc.
Otherwise we would miss filters those need reverse binding.

Fixes: 07d79fc7d94e ("net_sched: add reverse binding for tc class")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_api.c |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1910,22 +1910,24 @@ static int tcf_node_bind(struct tcf_prot
 	return 0;
 }
 
-static void tc_bind_tclass(struct Qdisc *q, u32 portid, u32 clid,
-			   unsigned long new_cl)
+struct tc_bind_class_args {
+	struct qdisc_walker w;
+	unsigned long new_cl;
+	u32 portid;
+	u32 clid;
+};
+
+static int tc_bind_class_walker(struct Qdisc *q, unsigned long cl,
+				struct qdisc_walker *w)
 {
+	struct tc_bind_class_args *a = (struct tc_bind_class_args *)w;
 	const struct Qdisc_class_ops *cops = q->ops->cl_ops;
 	struct tcf_block *block;
 	struct tcf_chain *chain;
-	unsigned long cl;
 
-	cl = cops->find(q, portid);
-	if (!cl)
-		return;
-	if (!cops->tcf_block)
-		return;
 	block = cops->tcf_block(q, cl, NULL);
 	if (!block)
-		return;
+		return 0;
 	for (chain = tcf_get_next_chain(block, NULL);
 	     chain;
 	     chain = tcf_get_next_chain(block, chain)) {
@@ -1936,12 +1938,29 @@ static void tc_bind_tclass(struct Qdisc
 			struct tcf_bind_args arg = {};
 
 			arg.w.fn = tcf_node_bind;
-			arg.classid = clid;
+			arg.classid = a->clid;
 			arg.base = cl;
-			arg.cl = new_cl;
+			arg.cl = a->new_cl;
 			tp->ops->walk(tp, &arg.w, true);
 		}
 	}
+
+	return 0;
+}
+
+static void tc_bind_tclass(struct Qdisc *q, u32 portid, u32 clid,
+			   unsigned long new_cl)
+{
+	const struct Qdisc_class_ops *cops = q->ops->cl_ops;
+	struct tc_bind_class_args args = {};
+
+	if (!cops->tcf_block)
+		return;
+	args.portid = portid;
+	args.clid = clid;
+	args.new_cl = new_cl;
+	args.w.fn = tc_bind_class_walker;
+	q->ops->cl_ops->walk(q, &args.w);
 }
 
 #else



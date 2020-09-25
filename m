Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E54E2787AB
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgIYMt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbgIYMtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65FE021D91;
        Fri, 25 Sep 2020 12:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038164;
        bh=AYe5I3zPyTIC8FEv4xdzcMMvnWr2dMBJk6QoVn2JaMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVYu1H0H4ALvBUnEDjTCUMdGC9rLCB67pgdFBhQ7Tvfqvt8BYOZkwKrZA5U62hWES
         J4rSbEDKB2eRZ8qT15On6q5yl1KdOJylk3WSVaVQRaFFFTWKMSz9FrqegVzPkBatge
         NCfLSA4B7L9bFdEJ13tr5KnWEbfGySAQ4quMXeM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8267241609ae8c23b248@syzkaller.appspotmail.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 26/56] taprio: Fix allowing too small intervals
Date:   Fri, 25 Sep 2020 14:48:16 +0200
Message-Id: <20200925124731.748913559@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit b5b73b26b3ca34574124ed7ae9c5ba8391a7f176 ]

It's possible that the user specifies an interval that couldn't allow
any packet to be transmitted. This also avoids the issue of the
hrtimer handler starving the other threads because it's running too
often.

The solution is to reject interval sizes that according to the current
link speed wouldn't allow any packet to be transmitted.

Reported-by: syzbot+8267241609ae8c23b248@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -777,9 +777,11 @@ static const struct nla_policy taprio_po
 	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
 };
 
-static int fill_sched_entry(struct nlattr **tb, struct sched_entry *entry,
+static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
+			    struct sched_entry *entry,
 			    struct netlink_ext_ack *extack)
 {
+	int min_duration = length_to_duration(q, ETH_ZLEN);
 	u32 interval = 0;
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
@@ -794,7 +796,10 @@ static int fill_sched_entry(struct nlatt
 		interval = nla_get_u32(
 			tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]);
 
-	if (interval == 0) {
+	/* The interval should allow at least the minimum ethernet
+	 * frame to go out.
+	 */
+	if (interval < min_duration) {
 		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
 		return -EINVAL;
 	}
@@ -804,8 +809,9 @@ static int fill_sched_entry(struct nlatt
 	return 0;
 }
 
-static int parse_sched_entry(struct nlattr *n, struct sched_entry *entry,
-			     int index, struct netlink_ext_ack *extack)
+static int parse_sched_entry(struct taprio_sched *q, struct nlattr *n,
+			     struct sched_entry *entry, int index,
+			     struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = { };
 	int err;
@@ -819,10 +825,10 @@ static int parse_sched_entry(struct nlat
 
 	entry->index = index;
 
-	return fill_sched_entry(tb, entry, extack);
+	return fill_sched_entry(q, tb, entry, extack);
 }
 
-static int parse_sched_list(struct nlattr *list,
+static int parse_sched_list(struct taprio_sched *q, struct nlattr *list,
 			    struct sched_gate_list *sched,
 			    struct netlink_ext_ack *extack)
 {
@@ -847,7 +853,7 @@ static int parse_sched_list(struct nlatt
 			return -ENOMEM;
 		}
 
-		err = parse_sched_entry(n, entry, i, extack);
+		err = parse_sched_entry(q, n, entry, i, extack);
 		if (err < 0) {
 			kfree(entry);
 			return err;
@@ -862,7 +868,7 @@ static int parse_sched_list(struct nlatt
 	return i;
 }
 
-static int parse_taprio_schedule(struct nlattr **tb,
+static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 				 struct sched_gate_list *new,
 				 struct netlink_ext_ack *extack)
 {
@@ -883,8 +889,8 @@ static int parse_taprio_schedule(struct
 		new->cycle_time = nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST])
-		err = parse_sched_list(
-			tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], new, extack);
+		err = parse_sched_list(q, tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST],
+				       new, extack);
 	if (err < 0)
 		return err;
 
@@ -1474,7 +1480,7 @@ static int taprio_change(struct Qdisc *s
 		goto free_sched;
 	}
 
-	err = parse_taprio_schedule(tb, new_admin, extack);
+	err = parse_taprio_schedule(q, tb, new_admin, extack);
 	if (err < 0)
 		goto free_sched;
 



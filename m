Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71E114B9FA
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgA1OXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:23:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbgA1OXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:23:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BD6824688;
        Tue, 28 Jan 2020 14:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221423;
        bh=Ie5ac0/XrS9CVpHlpHaFvjt+q9xSY7ZqJ+bgBdImDwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUn/l8PoMElI08gSPCxK/4XXyPjCBFn05x9vUMArKoQBvZ+QbcJ/dT3j11Zwdv1k7
         oxABQLgw6qOXVArBZo864M40akHYdlvB7O7xSHKzqj2Aisgzw6yQnfEC1Q+T23yvOR
         uDo9MHtDqG+5cLsEB5bj4AafiwiNX9lmh6VJzZY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 217/271] net: netem: fix error path for corrupted GSO frames
Date:   Tue, 28 Jan 2020 15:06:06 +0100
Message-Id: <20200128135908.697925823@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit a7fa12d15855904aff1716e1fc723c03ba38c5cc ]

To corrupt a GSO frame we first perform segmentation.  We then
proceed using the first segment instead of the full GSO skb and
requeue the rest of the segments as separate packets.

If there are any issues with processing the first segment we
still want to process the rest, therefore we jump to the
finish_segs label.

Commit 177b8007463c ("net: netem: fix backlog accounting for
corrupted GSO frames") started using the pointer to the first
segment in the "rest of segments processing", but as mentioned
above the first segment may had already been freed at this point.

Backlog corrections for parent qdiscs have to be adjusted.

Fixes: 177b8007463c ("net: netem: fix backlog accounting for corrupted GSO frames")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 308d92491757e..11c4c93f5ded7 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -510,6 +510,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		    skb_checksum_help(skb)) {
 			qdisc_drop(skb, sch, to_free);
+			skb = NULL;
 			goto finish_segs;
 		}
 
@@ -586,9 +587,10 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 finish_segs:
 	if (segs) {
 		unsigned int len, last_len;
-		int nb = 0;
+		int nb;
 
-		len = skb->len;
+		len = skb ? skb->len : 0;
+		nb = skb ? 1 : 0;
 
 		while (segs) {
 			skb2 = segs->next;
@@ -605,7 +607,8 @@ finish_segs:
 			}
 			segs = skb2;
 		}
-		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
+		/* Parent qdiscs accounted for 1 skb of size @prev_len */
+		qdisc_tree_reduce_backlog(sch, -(nb - 1), -(len - prev_len));
 	}
 	return NET_XMIT_SUCCESS;
 }
-- 
2.20.1




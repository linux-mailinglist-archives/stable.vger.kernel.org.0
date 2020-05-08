Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754D41CAFF3
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgEHNWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbgEHMjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26A8F20731;
        Fri,  8 May 2020 12:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941578;
        bh=wgcTiinubvj3Unpo1co4lZareMm7Mk4dIxnyal2sNQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UqOrr9BuidwfO60Qf0SxDdGFe2FHe+1s3kjc7P2zzBu/QXZc3ZeYBT8Vm+FkGTi8/
         SiCwc8V+y8NH+B/uF4zldRG13HNG9AxzmAZn+T+UFzoBfdmItFHSHfIw2cC0VPRer5
         OCxNJDwyykAxPIVkZsOOOJMCrA0hfQ/ZsIb1EMo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 088/312] sch_drr: update backlog as well
Date:   Fri,  8 May 2020 14:31:19 +0200
Message-Id: <20200508123130.732852195@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

commit 6a73b571b63075ef408c83f07c2565b5652f93cc upstream.

Fixes: 2ccccf5fb43f ("net_sched: update hierarchical backlog too")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_drr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -375,6 +375,7 @@ static int drr_enqueue(struct sk_buff *s
 		cl->deficit = cl->quantum;
 	}
 
+	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 	return err;
 }
@@ -405,6 +406,7 @@ static struct sk_buff *drr_dequeue(struc
 
 			bstats_update(&cl->bstats, skb);
 			qdisc_bstats_update(sch, skb);
+			qdisc_qstats_backlog_dec(sch, skb);
 			sch->q.qlen--;
 			return skb;
 		}
@@ -426,6 +428,7 @@ static unsigned int drr_drop(struct Qdis
 		if (cl->qdisc->ops->drop) {
 			len = cl->qdisc->ops->drop(cl->qdisc);
 			if (len > 0) {
+				sch->qstats.backlog -= len;
 				sch->q.qlen--;
 				if (cl->qdisc->q.qlen == 0)
 					list_del(&cl->alist);
@@ -461,6 +464,7 @@ static void drr_reset_qdisc(struct Qdisc
 			qdisc_reset(cl->qdisc);
 		}
 	}
+	sch->qstats.backlog = 0;
 	sch->q.qlen = 0;
 }
 



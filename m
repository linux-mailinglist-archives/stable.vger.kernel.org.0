Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF1C3E7FCC
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhHJRnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232085AbhHJRlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:41:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7677961058;
        Tue, 10 Aug 2021 17:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617094;
        bh=5rcsyPFByf0ZprwZ+NDG9Eu3dfyZrhlK0z8ayDrea2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2rXwVAfXsxKtub4E73BqIk6o2rdhXD8V7l48/d3FNhDSpCO92lGcyA2WhFRT9JrJ
         32bJDGppLfQ5/7hLwUHyVyDB1DIbfz9qdHJJBwOC/rouk4o53mknEqdov697ZYg4ch
         8rJ7DNXXlogGoS2b+6cCG6wsOPAbbn5srVUacers=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/135] net: sched: fix lockdep_set_class() typo error for sch->seqlock
Date:   Tue, 10 Aug 2021 19:29:37 +0200
Message-Id: <20210810172957.148233258@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 06f5553e0f0c2182268179b93856187d9cb86dd5 ]

According to comment in qdisc_alloc(), sch->seqlock's lockdep
class key should be set to qdisc_tx_busylock, due to possible
type error, sch->busylock's lockdep class key is set to
qdisc_tx_busylock, which is duplicated because sch->busylock's
lockdep class key is already set in qdisc_alloc().

So fix it by replacing sch->busylock with sch->seqlock.

Fixes: 96009c7d500e ("sched: replace __QDISC_STATE_RUNNING bit with a spin lock")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 854d2b38db85..05aa2571a409 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -886,7 +886,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 
 	/* seqlock has the same scope of busylock, for NOLOCK qdisc */
 	spin_lock_init(&sch->seqlock);
-	lockdep_set_class(&sch->busylock,
+	lockdep_set_class(&sch->seqlock,
 			  dev->qdisc_tx_busylock ?: &qdisc_tx_busylock);
 
 	seqcount_init(&sch->running);
-- 
2.30.2




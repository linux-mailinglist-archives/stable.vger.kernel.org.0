Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3CB3E811A
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbhHJRzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236937AbhHJRxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:53:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A956961213;
        Tue, 10 Aug 2021 17:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617440;
        bh=1memrWi5ponK9ta8UTKX7L4xQXR6+pAOy1mX/jPqdyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0CJEKwwzbuHFZ55wARCZA61c77+Wu6QkhscwumgI2nVZCDMZjIct/cHDBd1fkLHS
         7TjVTprNJ89LJHRDJ4lCRpBu8+uHCmEmtkkDBOtERH8BlynMKZeZ2T3fav3bQcZVXh
         2htuf3hC/9Oa3wCRaxlGTSFaIamaH4v08QNfa4dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 058/175] net: sched: fix lockdep_set_class() typo error for sch->seqlock
Date:   Tue, 10 Aug 2021 19:29:26 +0200
Message-Id: <20210810173002.860663150@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
index fc8b56bcabf3..1ee96a5c5ee0 100644
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




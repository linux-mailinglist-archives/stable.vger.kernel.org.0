Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302A03D61A3
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhGZPc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232361AbhGZPab (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BBE160240;
        Mon, 26 Jul 2021 16:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315860;
        bh=MwThTflVdON8+PjJgXphdsRoMD83rejvJwXVY2l3kuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w71W06EhU9eopTUCQNlyGV4e/OyQ6OLbg3mQ6ORT9eDEzFth7ANvpHx87MDgkgAI+
         vu1D+568txW9zefGS58qLNI5Deni9s/Hzbd/4Tk5Wy3njNhBf07cMPMaQaD0f4dLa6
         rXdoPfdRfM1jSHIPNNe7f90A4PYLPAySLn5A6KRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com
Subject: [PATCH 5.13 095/223] net: sched: fix memory leak in tcindex_partial_destroy_work
Date:   Mon, 26 Jul 2021 17:38:07 +0200
Message-Id: <20210726153849.359585643@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit f5051bcece50140abd1a11a2d36dc3ec5484fc32 ]

Syzbot reported memory leak in tcindex_set_parms(). The problem was in
non-freed perfect hash in tcindex_partial_destroy_work().

In tcindex_set_parms() new tcindex_data is allocated and some fields from
old one are copied to new one, but not the perfect hash. Since
tcindex_partial_destroy_work() is the destroy function for old
tcindex_data, we need to free perfect hash to avoid memory leak.

Reported-and-tested-by: syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com
Fixes: 331b72922c5f ("net: sched: RCU cls_tcindex")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_tcindex.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 5b274534264c..e9a8a2c86bbd 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -278,6 +278,8 @@ static int tcindex_filter_result_init(struct tcindex_filter_result *r,
 			     TCA_TCINDEX_POLICE);
 }
 
+static void tcindex_free_perfect_hash(struct tcindex_data *cp);
+
 static void tcindex_partial_destroy_work(struct work_struct *work)
 {
 	struct tcindex_data *p = container_of(to_rcu_work(work),
@@ -285,7 +287,8 @@ static void tcindex_partial_destroy_work(struct work_struct *work)
 					      rwork);
 
 	rtnl_lock();
-	kfree(p->perfect);
+	if (p->perfect)
+		tcindex_free_perfect_hash(p);
 	kfree(p);
 	rtnl_unlock();
 }
-- 
2.30.2




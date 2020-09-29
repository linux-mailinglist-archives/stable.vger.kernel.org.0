Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D423527C9BD
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732154AbgI2MNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730130AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E69823B46;
        Tue, 29 Sep 2020 11:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379250;
        bh=E7sEuOlidsnYxIa4credmvL4XyeXxhsRic+xEuLnfvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zfgt5gPKwLOMrQIzS3r4mJqFfdU0j/ccy0qbgXB1icQsYmkAtMXqgowoxgGENYLd1
         Sm1ba3kNNAjbIlO4XTMfAY1JQEkEfjyBKIq1+lXEsSZ5/Y+HQjOgyzRYPZ2xEDFNnG
         Nbln4tv/A0kVgUk2yt4S2Dmmb+7CqAWermp062Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/388] ipv6_route_seq_next should increase position index
Date:   Tue, 29 Sep 2020 12:56:50 +0200
Message-Id: <20200929110014.307591977@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 4fc427e0515811250647d44de38d87d7b0e0790f ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 96d80e50bf35b..9ca6c32065ec6 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2479,14 +2479,13 @@ static void *ipv6_route_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct net *net = seq_file_net(seq);
 	struct ipv6_route_iter *iter = seq->private;
 
+	++(*pos);
 	if (!v)
 		goto iter_table;
 
 	n = rcu_dereference_bh(((struct fib6_info *)v)->fib6_next);
-	if (n) {
-		++*pos;
+	if (n)
 		return n;
-	}
 
 iter_table:
 	ipv6_route_check_sernum(iter);
@@ -2494,8 +2493,6 @@ iter_table:
 	r = fib6_walk_continue(&iter->w);
 	spin_unlock_bh(&iter->tbl->tb6_lock);
 	if (r > 0) {
-		if (v)
-			++*pos;
 		return iter->w.leaf;
 	} else if (r < 0) {
 		fib6_walker_unlink(net, &iter->w);
-- 
2.25.1




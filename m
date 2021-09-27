Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1306F419B03
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbhI0ROz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237138AbhI0RN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B772611ED;
        Mon, 27 Sep 2021 17:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762582;
        bh=H6ZXWIbRg4/5Y7eKzNvR0bi6aZYbenYOhFHKM/MZkvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=As9NI17TrF09zFCqfFqrYD/QpDRIElitGPiTl3GC+9HuLRXAYNq0z/IbFWYrd3BlA
         W0gBcIjTgEBiRD4AgwSzAT59XLGwk63X/Oh/+4+LSpBGVh9fbQXQGK2XkL27vm/FRl
         E5Pmpysjxhl8pypurHOx5cDcNv1bYdDZ0qFm8XG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhang kai <zhangkaiheb@126.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/103] ipv6: delay fib6_sernum increase in fib6_add
Date:   Mon, 27 Sep 2021 19:02:50 +0200
Message-Id: <20210927170228.465711401@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhang kai <zhangkaiheb@126.com>

[ Upstream commit e87b5052271e39d62337ade531992b7e5d8c2cfa ]

only increase fib6_sernum in net namespace after add fib6_info
successfully.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 1fb79dbde0cb..e43f1fbac28b 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1376,7 +1376,6 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	int err = -ENOMEM;
 	int allow_create = 1;
 	int replace_required = 0;
-	int sernum = fib6_new_sernum(info->nl_net);
 
 	if (info->nlh) {
 		if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
@@ -1476,7 +1475,7 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	if (!err) {
 		if (rt->nh)
 			list_add(&rt->nh_list, &rt->nh->f6i_list);
-		__fib6_update_sernum_upto_root(rt, sernum);
+		__fib6_update_sernum_upto_root(rt, fib6_new_sernum(info->nl_net));
 		fib6_start_gc(info->nl_net, rt);
 	}
 
-- 
2.33.0




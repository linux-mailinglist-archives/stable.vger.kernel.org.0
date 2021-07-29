Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637593DA551
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbhG2OA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238101AbhG2N6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:58:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC61660F46;
        Thu, 29 Jul 2021 13:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567129;
        bh=EEaZdNLYcxb5DPk3/i+7IoNtTtEPO0ga9LoLHTgqD0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcKyqjkJZ/I0UIR6XNySiIglwvG/Aor0W1JW/Sr1/NvSxf2+MMJ3mP/cwZ+7GXaCx
         n9/+4WPw2f59+nFJpuo+pQudGsOoMMZF7I0qjFhqHexIOiePUcZbRMrY/1VnTRKKVp
         8tRPXP0Q/5dSUVs8xvqqDEbvk7nhdrJIvQbM/sv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/24] ipv6: ip6_finish_output2: set sk into newly allocated nskb
Date:   Thu, 29 Jul 2021 15:54:44 +0200
Message-Id: <20210729135138.015826499@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
References: <20210729135137.267680390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 2d85a1b31dde84038ea07ad825c3d8d3e71f4344 ]

skb_set_owner_w() should set sk not to old skb but to new nskb.

Fixes: 5796015fa968 ("ipv6: allocate enough headroom in ip6_finish_output2()")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Link: https://lore.kernel.org/r/70c0744f-89ae-1869-7e3e-4fa292158f4b@virtuozzo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 781d3bc64b71..72a673a43a75 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -74,7 +74,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
 			if (likely(nskb)) {
 				if (skb->sk)
-					skb_set_owner_w(skb, skb->sk);
+					skb_set_owner_w(nskb, skb->sk);
 				consume_skb(skb);
 			} else {
 				kfree_skb(skb);
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF0535C044
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbhDLJMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239245AbhDLJHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:07:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F51361263;
        Mon, 12 Apr 2021 09:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218215;
        bh=2sIrRiXC24IZ3c+sMIwarCIiK0yziEiQgeC2Jk0JQKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCqCK5ugq+pQRNqMn0N1AtjrM/Y6I5pzRczSOuZZjTryHSeQgaX4cWuDyuFh0QQrP
         0WoUQ98dUxHXahRL/y4OR+iULgnlyDQukuHFojqwdzjA1qJmUyornJZrZQQdM5uUpI
         roQMQqM0Pxw+peAhaMtBpQfO8sVdg2RkR7M/WKgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 114/210] xfrm: Fix NULL pointer dereference on policy lookup
Date:   Mon, 12 Apr 2021 10:40:19 +0200
Message-Id: <20210412084019.804329665@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit b1e3a5607034aa0a481c6f69a6893049406665fb ]

When xfrm interfaces are used in combination with namespaces
and ESP offload, we get a dst_entry NULL pointer dereference.
This is because we don't have a dst_entry attached in the ESP
offloading case and we need to do a policy lookup before the
namespace transition.

Fix this by expicit checking of skb_dst(skb) before accessing it.

Fixes: f203b76d78092 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index bfbc7810df94..c58a6d4eb610 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1097,7 +1097,7 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 		return __xfrm_policy_check(sk, ndir, skb, family);
 
 	return	(!net->xfrm.policy_count[dir] && !secpath_exists(skb)) ||
-		(skb_dst(skb)->flags & DST_NOPOLICY) ||
+		(skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
 		__xfrm_policy_check(sk, ndir, skb, family);
 }
 
-- 
2.30.2




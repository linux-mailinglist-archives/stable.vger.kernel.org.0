Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD7735BE6B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238608AbhDLI6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238573AbhDLI4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:56:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F321B6124A;
        Mon, 12 Apr 2021 08:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217772;
        bh=2sIrRiXC24IZ3c+sMIwarCIiK0yziEiQgeC2Jk0JQKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxD//1Z51U1zgQcFCa2j8xTvxqIaLiTExiLfQ3sRzL0cVteqeV4Ducyhr7Rga9xaq
         SGCgxFIxi9qPF13l1R/MS8dawwVOHplosovVoI6cGzYGp86SYmPEDGrxtQ+WEvqce1
         2P4bQEunK+OvwPYa40lNZrWxreNwuys8C/vjrlLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/188] xfrm: Fix NULL pointer dereference on policy lookup
Date:   Mon, 12 Apr 2021 10:40:18 +0200
Message-Id: <20210412084017.108022670@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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




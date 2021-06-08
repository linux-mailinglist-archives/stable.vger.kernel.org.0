Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAD53A0286
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbhFHTGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236333AbhFHTDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:03:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FD4D61879;
        Tue,  8 Jun 2021 18:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177928;
        bh=SR7TwnqRT9aOFTBruccWbgoF5gRaRBe/+emlZzBKv+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=by9Jzj6EQhPPkis77AoRLc13/cOqmJRgPmqqug/YOE9WHaEW+zs8zs5TAQpTwb5Pp
         lX80zIJZVVnAhNLLuaIqQ53fKpV9cATgr4wg1prvMUG4ryaHMTiUWjx6N+ucddRlU2
         kx6N3KdsrsHXs2Q84swQYkjXuXMwEBXFbVo8uK1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 006/161] netfilter: conntrack: unregister ipv4 sockopts on error unwind
Date:   Tue,  8 Jun 2021 20:25:36 +0200
Message-Id: <20210608175945.692084164@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 22cbdbcfb61acc78d5fc21ebb13ccc0d7e29f793 ]

When ipv6 sockopt register fails, the ipv4 one needs to be removed.

Fixes: a0ae2562c6c ("netfilter: conntrack: remove l3proto abstraction")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 47e9319d2cf3..71892822bbf5 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -660,7 +660,7 @@ int nf_conntrack_proto_init(void)
 
 #if IS_ENABLED(CONFIG_IPV6)
 cleanup_sockopt:
-	nf_unregister_sockopt(&so_getorigdst6);
+	nf_unregister_sockopt(&so_getorigdst);
 #endif
 	return ret;
 }
-- 
2.30.2




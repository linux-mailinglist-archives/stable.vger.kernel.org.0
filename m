Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD543A00B4
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhFHSqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235245AbhFHSoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:44:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8363F61451;
        Tue,  8 Jun 2021 18:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177394;
        bh=bzWsk3v5m+fHHsjzPgFotD73dnM61etbWCZJa3TE6r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJFoJGKKQ/VUb8cE7bxFWMn6tIBrdbY4aH9J+HaM1Akhm48AokaJ+/ga+nD4Lbe1e
         +wrljYvjHxe3G/+IB+dV9EceqmXuF4veiBk2J4O1dmZbLZM56xMVC7Qo9a9seEOHYv
         uQ1WYwa+LCGVK4Ot3jU8cv0ap2VzQ/PvO62qdlrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/78] netfilter: conntrack: unregister ipv4 sockopts on error unwind
Date:   Tue,  8 Jun 2021 20:26:35 +0200
Message-Id: <20210608175935.483904814@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
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
index aaf4293ddd45..75e6b429635d 100644
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




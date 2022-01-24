Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D895C49995F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455126AbiAXVeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:34:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34150 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449188AbiAXVPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:15:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D33BB81142;
        Mon, 24 Jan 2022 21:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C72C340E5;
        Mon, 24 Jan 2022 21:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058899;
        bh=sSDFp/4Isibgx+viCawhWzXdWhERJeA4CwQLf+j1haA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmxxWRaBLW1EP7oynW0cNk2ETT9/es42GK4g9MWY3xj96QIr4g6prRS8JlKCushyr
         BXGD/Q8FwRccdQDM3tJ2EmezlWE0+txwL4XgACb3auCah5jL9TsuKbAzzY+OzGAvqU
         hb84dVtCuukFnlmxB00Uq1Y3THvec//5KBPka3v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0437/1039] netfilter: egress: avoid a lockdep splat
Date:   Mon, 24 Jan 2022 19:37:06 +0100
Message-Id: <20220124184139.986966049@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6316136ec6e3dd1c302f7e7289a9ee46ecc610ae ]

include/linux/netfilter_netdev.h:97 suspicious rcu_dereference_check() usage!
2 locks held by sd-resolve/1100:
 0: ..(rcu_read_lock_bh){1:3}, at: ip_finish_output2
 1: ..(rcu_read_lock_bh){1:3}, at: __dev_queue_xmit
 __dev_queue_xmit+0 ..

The helper has two callers, one uses rcu_read_lock, the other
rcu_read_lock_bh().  Annotate the dereference to reflect this.

Fixes: 42df6e1d221dd ("netfilter: Introduce egress hook")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter_netdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index b71b57a83bb4f..b4dd96e4dc8dc 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -94,7 +94,7 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
 		return skb;
 #endif
 
-	e = rcu_dereference(dev->nf_hooks_egress);
+	e = rcu_dereference_check(dev->nf_hooks_egress, rcu_read_lock_bh_held());
 	if (!e)
 		return skb;
 
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C970434CA71
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbhC2Iii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234280AbhC2Igh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF9FC61613;
        Mon, 29 Mar 2021 08:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006957;
        bh=KPcYmxIsnUGx5m7FKjSmupJ5Uhrm65quTBUIhkOylzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0a4M8VnizvLzq3RaXESx21O876WYBBSr75KE6pYgQi9BBlomnbDQHCe0GnA6hbBm
         0EgNkZtKAOxNn0bt1ugi0/wWpDRQdPKlevJJyw1pZsHh4lx2vUY8/tgxRw8hN67P+G
         iUbjEyWRu/ve/QXdIZlarA1ue6VzQmy6AfF97CQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 168/254] netfilter: flowtable: Make sure GC works periodically in idle system
Date:   Mon, 29 Mar 2021 09:58:04 +0200
Message-Id: <20210329075638.692435657@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

[ Upstream commit 740b486a8d1f966e68ac0666f1fd57441a7cda94 ]

Currently flowtable's GC work is initialized as deferrable, which
means GC cannot work on time when system is idle. So the hardware
offloaded flow may be deleted for timeout, since its used time is
not timely updated.

Resolve it by initializing the GC work as delayed work instead of
deferrable.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4a4acbba78ff..b03feb6e1226 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -506,7 +506,7 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 {
 	int err;
 
-	INIT_DEFERRABLE_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
+	INIT_DELAYED_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
 	flow_block_init(&flowtable->flow_block);
 	init_rwsem(&flowtable->flow_block_lock);
 
-- 
2.30.1




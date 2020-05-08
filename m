Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F141CACA4
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbgEHMzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbgEHMzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:55:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFD3E24967;
        Fri,  8 May 2020 12:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942515;
        bh=X+8B5r+3ozNjTtxJhR0LgbtW2wp7VlQ+Pb0lz57jQmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EJuMTw7j22QFN5qlMWmfPwB810aTk+EBK4u9XBQ1PUVIZE2/yaZs2OWxNXp6aqU1
         GFrPgGgLek/Z6PBPYpFIQ2/DoP8WZpzXs26+a6P9iqis2zj1+Va8XjQOV84Q8ebEcV
         AsChDFtShoaSy3D6VaFhs5GG2I+vu7uHB02IgA6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Yihao Wu <wuyihao@linux.alibaba.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 09/49] SUNRPC/cache: Fix unsafe traverse caused double-free in cache_purge
Date:   Fri,  8 May 2020 14:35:26 +0200
Message-Id: <20200508123044.289470166@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yihao Wu <wuyihao@linux.alibaba.com>

[ Upstream commit 43e33924c38e8faeb0c12035481cb150e602e39d ]

Deleting list entry within hlist_for_each_entry_safe is not safe unless
next pointer (tmp) is protected too. It's not, because once hash_lock
is released, cache_clean may delete the entry that tmp points to. Then
cache_purge can walk to a deleted entry and tries to double free it.

Fix this bug by holding only the deleted entry's reference.

Suggested-by: NeilBrown <neilb@suse.de>
Signed-off-by: Yihao Wu <wuyihao@linux.alibaba.com>
Reviewed-by: NeilBrown <neilb@suse.de>
[ cel: removed unused variable ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/cache.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index bd843a81afa0b..d36cea4e270de 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -521,7 +521,6 @@ void cache_purge(struct cache_detail *detail)
 {
 	struct cache_head *ch = NULL;
 	struct hlist_head *head = NULL;
-	struct hlist_node *tmp = NULL;
 	int i = 0;
 
 	spin_lock(&detail->hash_lock);
@@ -533,7 +532,9 @@ void cache_purge(struct cache_detail *detail)
 	dprintk("RPC: %d entries in %s cache\n", detail->entries, detail->name);
 	for (i = 0; i < detail->hash_size; i++) {
 		head = &detail->hash_table[i];
-		hlist_for_each_entry_safe(ch, tmp, head, cache_list) {
+		while (!hlist_empty(head)) {
+			ch = hlist_entry(head->first, struct cache_head,
+					 cache_list);
 			sunrpc_begin_cache_remove_entry(ch, detail);
 			spin_unlock(&detail->hash_lock);
 			sunrpc_end_cache_remove_entry(ch, detail);
-- 
2.20.1




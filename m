Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57CD1675E7
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732557AbgBUIN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732537AbgBUINZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:13:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1F9024650;
        Fri, 21 Feb 2020 08:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272805;
        bh=AxKfZmAdFXCPVhMsF/7rjFQ7ZLiEFxpynnsIU06lQ8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vy5bcGjiKajLWkz2WHZj7BepMIodY1sT6swZgGL21vOprsw6sb7n4w7cJZgCP1MPk
         7JONmlIgGYX0gWcreAG9+scvTEGo/4x2D4rCn7E1yhYfE8rnaMuzbqovOR7qEY6lyJ
         29Tmcoh+tlE/ezcTMZTKwHUnUvsznfFsHXcEw5oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 281/344] sunrpc: Fix potential leaks in sunrpc_cache_unhash()
Date:   Fri, 21 Feb 2020 08:41:20 +0100
Message-Id: <20200221072415.283630414@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 1d82163714c16ebe09c7a8c9cd3cef7abcc16208 ]

When we unhash the cache entry, we need to handle any pending upcalls
by calling cache_fresh_unlocked().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index f740cb51802af..7ede1e52fd812 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1888,7 +1888,9 @@ void sunrpc_cache_unhash(struct cache_detail *cd, struct cache_head *h)
 	if (!hlist_unhashed(&h->cache_list)){
 		hlist_del_init_rcu(&h->cache_list);
 		cd->entries--;
+		set_bit(CACHE_CLEANED, &h->flags);
 		spin_unlock(&cd->hash_lock);
+		cache_fresh_unlocked(h, cd);
 		cache_put(h, cd);
 	} else
 		spin_unlock(&cd->hash_lock);
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342AA191CA
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbfEISvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727147AbfEISvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C6C1217D7;
        Thu,  9 May 2019 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427904;
        bh=yJF8lUBdAhNaHazmnRQ+EhrijC77SHZHX6lPsm/ryjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndgPu2W3BnaMCQahXz17j/TrqFcrBBeZeI/Q9d8gBCcumXsJ8HnHDrofkPQNDULkc
         T9GAl+U/p6ePaf4G5b0+1acQpzTuMdWUQREyXPbvURFDwShexGJ+ynLsFI/Qj0IqQb
         EGgCskxpZQI2mP96BW7CWWynJGTp35XII3/MJqRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        "Tobin C. Harding" <tobin@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 48/95] slab: fix a crash by reading /proc/slab_allocators
Date:   Thu,  9 May 2019 20:42:05 +0200
Message-Id: <20190509181312.836321156@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fcf88917dd435c6a4cb2830cb086ee58605a1d85 ]

The commit 510ded33e075 ("slab: implement slab_root_caches list")
changes the name of the list node within "struct kmem_cache" from "list"
to "root_caches_node", but leaks_show() still use the "list" which
causes a crash when reading /proc/slab_allocators.

You need to have CONFIG_SLAB=y and CONFIG_MEMCG=y to see the problem,
because without MEMCG all slab caches are root caches, and the "list"
node happens to be the right one.

Fixes: 510ded33e075 ("slab: implement slab_root_caches list")
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Tobin C. Harding <tobin@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index 2f2aa8eaf7d98..188c4b65255dc 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4297,7 +4297,8 @@ static void show_symbol(struct seq_file *m, unsigned long address)
 
 static int leaks_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *cachep = list_entry(p, struct kmem_cache, list);
+	struct kmem_cache *cachep = list_entry(p, struct kmem_cache,
+					       root_caches_node);
 	struct page *page;
 	struct kmem_cache_node *n;
 	const char *name;
-- 
2.20.1




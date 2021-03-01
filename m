Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC963291AC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243226AbhCAUaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:30:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243306AbhCAUXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:23:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EA796511E;
        Mon,  1 Mar 2021 18:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621946;
        bh=YmAebTOCi4twYnF8MKZGDDCVL7SOVN8EifS9QJsyc28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0D4rZGeZnY5snqx5QLUux0VvPLe1f9SKv1gioB4weR+L/TGBAF5qU01PbERwPp8kB
         H5WNAkJJKpReUpVGNttflS3T+t5JM6crPGg9e7oXMepi+sy+R6pqDWW/mYhtPJJ94p
         lhGJV9MttmR+ULBQTEiUM0VFz+hOgAZApohmUW8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 702/775] mm: memcontrol: fix get_active_memcg return value
Date:   Mon,  1 Mar 2021 17:14:30 +0100
Message-Id: <20210301161236.060534216@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 1685bde6b9af55923180a76152036c7fb7176db0 upstream.

We use a global percpu int_active_memcg variable to store the remote memcg
when we are in the interrupt context.  But get_active_memcg always return
the current->active_memcg or root_mem_cgroup.  The remote memcg (set in
the interrupt context) is ignored.  This is not what we want.  So fix it.

Link: https://lkml.kernel.org/r/20210223091101.42150-1-songmuchun@bytedance.com
Fixes: 37d5985c003d ("mm: kmem: prepare remote memcg charging infra for interrupt contexts")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1080,13 +1080,9 @@ static __always_inline struct mem_cgroup
 
 	rcu_read_lock();
 	memcg = active_memcg();
-	if (memcg) {
-		/* current->active_memcg must hold a ref. */
-		if (WARN_ON_ONCE(!css_tryget(&memcg->css)))
-			memcg = root_mem_cgroup;
-		else
-			memcg = current->active_memcg;
-	}
+	/* remote memcg must hold a ref. */
+	if (memcg && WARN_ON_ONCE(!css_tryget(&memcg->css)))
+		memcg = root_mem_cgroup;
 	rcu_read_unlock();
 
 	return memcg;



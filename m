Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D471D0E8B
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388190AbgEMKBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732597AbgEMJv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D6BE20575;
        Wed, 13 May 2020 09:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363486;
        bh=bRprwhULdLSmMkWbpcyasmCDFpAt5pBcEH9Ox3Ydgq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOdhm98QoyN1zxiihXFvHogMlKEGTF4lYqlyvijl70CHODg3X/lXdQb7j+4AsX4Dj
         vYaHVaPZ4KM2GL5JQ/vqpummv4jtIrSeZHSAEFQe4UMDqm7UStywI0UjpyXf8LvEQb
         gA7QLRqoqkyvww+rIqgwhRxYSSA85Iwm/ZwVlke8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 86/90] mm, memcg: fix error return value of mem_cgroup_css_alloc()
Date:   Wed, 13 May 2020 11:45:22 +0200
Message-Id: <20200513094418.119037500@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

commit 11d6761218d19ca06ae5387f4e3692c4fa9e7493 upstream.

When I run my memcg testcase which creates lots of memcgs, I found
there're unexpected out of memory logs while there're still enough
available free memory.  The error log is

  mkdir: cannot create directory 'foo.65533': Cannot allocate memory

The reason is when we try to create more than MEM_CGROUP_ID_MAX memcgs,
an -ENOMEM errno will be set by mem_cgroup_css_alloc(), but the right
errno should be -ENOSPC "No space left on device", which is an
appropriate errno for userspace's failed mkdir.

As the errno really misled me, we should make it right.  After this
patch, the error log will be

  mkdir: cannot create directory 'foo.65533': No space left on device

[akpm@linux-foundation.org: s/EBUSY/ENOSPC/, per Michal]
[akpm@linux-foundation.org: s/EBUSY/ENOSPC/, per Michal]
Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Link: http://lkml.kernel.org/r/20200407063621.GA18914@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/1586192163-20099-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5101,19 +5101,22 @@ static struct mem_cgroup *mem_cgroup_all
 	unsigned int size;
 	int node;
 	int __maybe_unused i;
+	long error = -ENOMEM;
 
 	size = sizeof(struct mem_cgroup);
 	size += nr_node_ids * sizeof(struct mem_cgroup_per_node *);
 
 	memcg = kzalloc(size, GFP_KERNEL);
 	if (!memcg)
-		return NULL;
+		return ERR_PTR(error);
 
 	memcg->id.id = idr_alloc(&mem_cgroup_idr, NULL,
 				 1, MEM_CGROUP_ID_MAX,
 				 GFP_KERNEL);
-	if (memcg->id.id < 0)
+	if (memcg->id.id < 0) {
+		error = memcg->id.id;
 		goto fail;
+	}
 
 	memcg->vmstats_local = alloc_percpu(struct memcg_vmstats_percpu);
 	if (!memcg->vmstats_local)
@@ -5158,7 +5161,7 @@ static struct mem_cgroup *mem_cgroup_all
 fail:
 	mem_cgroup_id_remove(memcg);
 	__mem_cgroup_free(memcg);
-	return NULL;
+	return ERR_PTR(error);
 }
 
 static struct cgroup_subsys_state * __ref
@@ -5169,8 +5172,8 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	long error = -ENOMEM;
 
 	memcg = mem_cgroup_alloc();
-	if (!memcg)
-		return ERR_PTR(error);
+	if (IS_ERR(memcg))
+		return ERR_CAST(memcg);
 
 	memcg->high = PAGE_COUNTER_MAX;
 	memcg->soft_limit = PAGE_COUNTER_MAX;
@@ -5220,7 +5223,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 fail:
 	mem_cgroup_id_remove(memcg);
 	mem_cgroup_free(memcg);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(error);
 }
 
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)



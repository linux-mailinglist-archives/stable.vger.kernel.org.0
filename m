Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFCA171E40
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388459AbgB0OKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:10:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388455AbgB0OKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:10:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2B4121D7E;
        Thu, 27 Feb 2020 14:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812601;
        bh=gXEv9AwRo9KfG6wELhy75P1nWv/0fTeMF95Dm0lXkyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ei6/ogCpbXdgs7KpqDMQeC80q7v064ihgih766vPlolATwG4lhabqjK84N1OJnLAJ
         FS8aAoq7YieSDnkZuRD90m3LLcfpH+3Ege9YMAOjE8e36qpK7WPMPOJr7L9AEbQ/V9
         kXa4n0/yIPrPUNscP83LbyVNVYJ9sqEkJkgJXlY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 063/135] mm/memcontrol.c: lost css_put in memcg_expand_shrinker_maps()
Date:   Thu, 27 Feb 2020 14:36:43 +0100
Message-Id: <20200227132238.614620688@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit 75866af62b439859d5146b7093ceb6b482852683 upstream.

for_each_mem_cgroup() increases css reference counter for memory cgroup
and requires to use mem_cgroup_iter_break() if the walk is cancelled.

Link: http://lkml.kernel.org/r/c98414fb-7e1f-da0f-867a-9340ec4bd30b@virtuozzo.com
Fixes: 0a4465d34028 ("mm, memcg: assign memcg-aware shrinkers bitmap to memcg")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -418,8 +418,10 @@ int memcg_expand_shrinker_maps(int new_i
 		if (mem_cgroup_is_root(memcg))
 			continue;
 		ret = memcg_expand_one_shrinker_map(memcg, size, old_size);
-		if (ret)
+		if (ret) {
+			mem_cgroup_iter_break(NULL, memcg);
 			goto unlock;
+		}
 	}
 unlock:
 	if (!ret)



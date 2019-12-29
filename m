Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAE612C8B8
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733209AbfL2R5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:57:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733206AbfL2R5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B90F7227BF;
        Sun, 29 Dec 2019 17:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642230;
        bh=YBMaCe+J+xlk2jiqRprad+cQv/PH8L8vT5bPX6bNK2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNUAlAZIN7OvYLMj3s6zSJWvXZT006lJKZ8CAs3aMgOQZUu+Xbi7hDrabeAhwvujK
         ZZwyXSIFZZaM/od9g/JfBvRwAk64v0am3ITFXdOwwADPqw2QfldmV8Jvtd+wL75Cb3
         2CU5dSwWay6JgofoJqYGaPemzRszbd2Rah8wxywU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <yang.shi@linux.alibaba.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 396/434] mm: vmscan: protect shrinker idr replace with CONFIG_MEMCG
Date:   Sun, 29 Dec 2019 18:27:29 +0100
Message-Id: <20191229172728.690545768@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>

commit 42a9a53bb394a1de2247ef78f0b802ae86798122 upstream.

Since commit 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on
memcg kmem"), shrinkers' idr is protected by CONFIG_MEMCG instead of
CONFIG_MEMCG_KMEM, so it makes no sense to protect shrinker idr replace
with CONFIG_MEMCG_KMEM.

And in the CONFIG_MEMCG && CONFIG_SLOB case, shrinker_idr contains only
shrinker, and it is deferred_split_shrinker.  But it is never actually
called, since idr_replace() is never compiled due to the wrong #ifdef.
The deferred_split_shrinker all the time is staying in half-registered
state, and it's never called for subordinate mem cgroups.

Link: http://lkml.kernel.org/r/1575486978-45249-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -422,7 +422,7 @@ void register_shrinker_prepared(struct s
 {
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		idr_replace(&shrinker_idr, shrinker, shrinker->id);
 #endif



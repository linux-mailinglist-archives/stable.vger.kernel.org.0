Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EB340E0F8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240873AbhIPQZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240889AbhIPQX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7626760F8F;
        Thu, 16 Sep 2021 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808972;
        bh=Lx/7dvfq/ZH0FLfRLQXCRbj4o1l2TjiKGWN5OXRUYgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q54cdi+M30pqyDq3V/Dmv3x+dQav8vQLVLmVRGL98o+czBMZwfpbtiycHPwTOWrat
         EN6naV+CAjY+Me+rE3tt4ALWNxCylB3sML6Swi5XqysQ8geFN/7nPeCwtdAph2utep
         FYBJ6jk6vHdmAVlALNjz8GMZGetaNpRMYCEbjYTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Shakeel Butt <shakeelb@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 291/306] memcg: enable accounting for pids in nested pid namespaces
Date:   Thu, 16 Sep 2021 18:00:36 +0200
Message-Id: <20210916155804.021257012@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit fab827dbee8c2e06ca4ba000fa6c48bcf9054aba upstream.

Commit 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
enabled memcg accounting for pids allocated from init_pid_ns.pid_cachep,
but forgot to adjust the setting for nested pid namespaces.  As a result,
pid memory is not accounted exactly where it is really needed, inside
memcg-limited containers with their own pid namespaces.

Pid was one the first kernel objects enabled for memcg accounting.
init_pid_ns.pid_cachep marked by SLAB_ACCOUNT and we can expect that any
new pids in the system are memcg-accounted.

Though recently I've noticed that it is wrong.  nested pid namespaces
creates own slab caches for pid objects, nested pids have increased size
because contain id both for all parent and for own pid namespaces.  The
problem is that these slab caches are _NOT_ marked by SLAB_ACCOUNT, as a
result any pids allocated in nested pid namespaces are not
memcg-accounted.

Pid struct in nested pid namespace consumes up to 500 bytes memory, 100000
such objects gives us up to ~50Mb unaccounted memory, this allow container
to exceed assigned memcg limits.

Link: https://lkml.kernel.org/r/8b6de616-fd1a-02c6-cbdb-976ecdcfa604@virtuozzo.com
Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
Cc: stable@vger.kernel.org
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/pid_namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -51,7 +51,8 @@ static struct kmem_cache *create_pid_cac
 	mutex_lock(&pid_caches_mutex);
 	/* Name collision forces to do allocation under mutex. */
 	if (!*pkc)
-		*pkc = kmem_cache_create(name, len, 0, SLAB_HWCACHE_ALIGN, 0);
+		*pkc = kmem_cache_create(name, len, 0,
+					 SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, 0);
 	mutex_unlock(&pid_caches_mutex);
 	/* current can fail, but someone else can succeed. */
 	return READ_ONCE(*pkc);



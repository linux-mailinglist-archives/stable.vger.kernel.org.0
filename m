Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E72911A5EDF
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 16:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgDLOEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 10:04:44 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38938 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgDLOEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 10:04:44 -0400
Received: by mail-pj1-f67.google.com with SMTP id o1so1982857pjs.4
        for <stable@vger.kernel.org>; Sun, 12 Apr 2020 07:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eixCw1xPj/tb4QlnWiRc+JPy+QFvVa7Xxm9n1sZX7yw=;
        b=vPEz/SDBW0I9ywKFJJ8l5YRbowg1JkuJGzHS7nGpQhnVLyymZPd8I5TOkd5YtMzMfO
         n4vm2pj3iV2XOusfQc8+JuP32LnpBuPLmdJpD4UnE5+MPv41tW7wtzE6gikudcl50pr/
         +Tt3kOmAaDGy0XkNlBQABv1yiWcXYAvkto9lbBEaGlUjXnOGUPKgwkHx5r0RgUpBdL/2
         rvNISWVhVURTzop52NfSWJqkPlAys+gAhzs255X7PQztCj/fL+vYEo+W+ZTUYYVIBKM6
         WgWG68v0xlxKFvaq7UqEZ+x1yNGFni8PO5pFJ5NsjVhKkbhXo5U7Jp5dJLSz4lxIndk4
         WX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eixCw1xPj/tb4QlnWiRc+JPy+QFvVa7Xxm9n1sZX7yw=;
        b=ZmZhri0NM6RllTIdediEupluftscL/014VglddT05+m96mOKwy1zcgk0f39zC8KGSz
         LjtRKqcKLH5cw1pZe8EYpl/7/n5nkTZCps58hbE8NvB4y5khww4rJPeUEZ2XkLRNyomn
         SSdNe7c92lGciH/sXf/qmM70d4EWGgBbsewOGzvuoZ6LHrByKccW4kxiSwU5PUorNJIm
         D3vbMll8hnTQQRl/3jwSslC9xJgbxc50qX+UjHGDrda7MByrrymh1FbklN3GBIvPKTHS
         +vX5ECzrJPedO8RTMVFijGvGvZdWXVGsAtju4tGygvXKigEfQ1jl80YGXX5/2YeJsazq
         CQJA==
X-Gm-Message-State: AGi0PuZhClS1bF8+bLRm6FYT/7VVw/KBJJ7VJr2gVVlEp9dvr7QQFBCq
        QVOepQyKLZoNlupD5kmRdeA=
X-Google-Smtp-Source: APiQypKgTTLbS3ZJQ2z0w045ILIZohPJBD9PL9EjSqmAwr7g1vYTEx20P+F48CbAz3x8ZURKxFymig==
X-Received: by 2002:a17:90a:e515:: with SMTP id t21mr16118524pjy.123.1586700283142;
        Sun, 12 Apr 2020 07:04:43 -0700 (PDT)
Received: from localhost.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id r28sm49894pfg.186.2020.04.12.07.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 07:04:42 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     chris@chrisdown.name, hannes@cmpxchg.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>,
        Shakeel Butt <shakeelb@google.com>, stable@vger.kernel.org
Subject: [PATCH] mm, memcg: fix inconsistent oom event behavior
Date:   Sun, 12 Apr 2020 10:04:27 -0400
Message-Id: <20200412140427.6732-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
memory.events") changes the behavior of memcg events, which will
consider subtrees in memory.events. But oom_kill event is a special one
as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
in memory.oom_control. The file memory.oom_control is in both root memcg
and non root memcg, that is different with memory.event as it only in
non-root memcg. That commit is okay for cgroup2, but it is not okay for
cgroup1 as it will cause inconsistent behavior between root memcg and
non-root memcg.
Let's recover the original behavior for cgroup1.

Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8c340e6b347f..a0ae080a67d1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -798,7 +798,8 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
 		atomic_long_inc(&memcg->memory_events[event]);
 		cgroup_file_notify(&memcg->events_file);
 
-		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS ||
+		    !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 			break;
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
-- 
2.18.2


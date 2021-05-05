Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9558373A1C
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhEEMHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232822AbhEEMHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:07:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15A566121F;
        Wed,  5 May 2021 12:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216378;
        bh=Vv89GRzN62drXvs6Is1v6/nS/XkpaahPEDshAg3+LE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0cVfvZCFYPpoB4mBzG6sRF82PdiaAwu5RSiZ3p7KE4F8sImj0NiSpQcMQPEyfj+v
         0ijqzQ4L2+OdNp0euz05Y8eXoyWyGh8yIyIYorKuSM6apqzq+7ZtD5X6EfNY80I5ki
         GgisYTMGjs0xT/bAieiwSctU6QipYwhufdix4zXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/29] tools/cgroup/slabinfo.py: updated to work on current kernel
Date:   Wed,  5 May 2021 14:05:14 +0200
Message-Id: <20210505112326.573340153@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
References: <20210505112326.195493232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 1974c45dd7745e999b9387be3d8fdcb27a5b1721 ]

slabinfo.py script does not work with actual kernel version.

First, it was unable to recognise SLUB susbsytem, and when I specified
it manually it failed again with

  AttributeError: 'struct page' has no member 'obj_cgroups'

.. and then again with

  File "tools/cgroup/memcg_slabinfo.py", line 221, in main
    memcg.kmem_caches.address_of_(),
  AttributeError: 'struct mem_cgroup' has no member 'kmem_caches'

Link: https://lkml.kernel.org/r/cec1a75e-43b4-3d64-2084-d9f98fda037f@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Tested-by: Roman Gushchin <guro@fb.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/cgroup/memcg_slabinfo.py | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/cgroup/memcg_slabinfo.py b/tools/cgroup/memcg_slabinfo.py
index c4225ed63565..1600b17dbb8a 100644
--- a/tools/cgroup/memcg_slabinfo.py
+++ b/tools/cgroup/memcg_slabinfo.py
@@ -128,9 +128,9 @@ def detect_kernel_config():
 
     cfg['nr_nodes'] = prog['nr_online_nodes'].value_()
 
-    if prog.type('struct kmem_cache').members[1][1] == 'flags':
+    if prog.type('struct kmem_cache').members[1].name == 'flags':
         cfg['allocator'] = 'SLUB'
-    elif prog.type('struct kmem_cache').members[1][1] == 'batchcount':
+    elif prog.type('struct kmem_cache').members[1].name == 'batchcount':
         cfg['allocator'] = 'SLAB'
     else:
         err('Can\'t determine the slab allocator')
@@ -193,7 +193,7 @@ def main():
         # look over all slab pages, belonging to non-root memcgs
         # and look for objects belonging to the given memory cgroup
         for page in for_each_slab_page(prog):
-            objcg_vec_raw = page.obj_cgroups.value_()
+            objcg_vec_raw = page.memcg_data.value_()
             if objcg_vec_raw == 0:
                 continue
             cache = page.slab_cache
@@ -202,7 +202,7 @@ def main():
             addr = cache.value_()
             caches[addr] = cache
             # clear the lowest bit to get the true obj_cgroups
-            objcg_vec = Object(prog, page.obj_cgroups.type_,
+            objcg_vec = Object(prog, 'struct obj_cgroup **',
                                value=objcg_vec_raw & ~1)
 
             if addr not in stats:
-- 
2.30.2




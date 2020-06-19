Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B354A2018DC
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436528AbgFSQxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387568AbgFSOg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:36:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F62B21548;
        Fri, 19 Jun 2020 14:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577417;
        bh=SrQEW/WNJmE1lNBh5dzWsckBlLxCIdTnJoWOJiwE1lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmwP8pUerP3x68ZpJam7wdKBeTjw9d5dJH+gIl0E2a3OARwsv37IN6Fr/8eyovZ5A
         vaj2ITdR6qFeZzqBDWI405Mx3OoJXPzc8d75+ya91daQKvBkXb85GZjiODqFDQgN3D
         u5mXCI1uieX1ubLqs5y2xDW7bvYjUF+wsT0m0Fi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 043/101] mm/slub: fix a memory leak in sysfs_slab_add()
Date:   Fri, 19 Jun 2020 16:32:32 +0200
Message-Id: <20200619141616.362871178@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

commit dde3c6b72a16c2db826f54b2d49bdea26c3534a2 upstream.

syzkaller reports for memory leak when kobject_init_and_add() returns an
error in the function sysfs_slab_add() [1]

When this happened, the function kobject_put() is not called for the
corresponding kobject, which potentially leads to memory leak.

This patch fixes the issue by calling kobject_put() even if
kobject_init_and_add() fails.

[1]
  BUG: memory leak
  unreferenced object 0xffff8880a6d4be88 (size 8):
  comm "syz-executor.3", pid 946, jiffies 4295772514 (age 18.396s)
  hex dump (first 8 bytes):
    70 69 64 5f 33 00 ff ff                          pid_3...
  backtrace:
     kstrdup+0x35/0x70 mm/util.c:60
     kstrdup_const+0x3d/0x50 mm/util.c:82
     kvasprintf_const+0x112/0x170 lib/kasprintf.c:48
     kobject_set_name_vargs+0x55/0x130 lib/kobject.c:289
     kobject_add_varg lib/kobject.c:384 [inline]
     kobject_init_and_add+0xd8/0x170 lib/kobject.c:473
     sysfs_slab_add+0x1d8/0x290 mm/slub.c:5811
     __kmem_cache_create+0x50a/0x570 mm/slub.c:4384
     create_cache+0x113/0x1e0 mm/slab_common.c:407
     kmem_cache_create_usercopy+0x1a1/0x260 mm/slab_common.c:505
     kmem_cache_create+0xd/0x10 mm/slab_common.c:564
     create_pid_cachep kernel/pid_namespace.c:54 [inline]
     create_pid_namespace kernel/pid_namespace.c:96 [inline]
     copy_pid_ns+0x77c/0x8f0 kernel/pid_namespace.c:148
     create_new_namespaces+0x26b/0xa30 kernel/nsproxy.c:95
     unshare_nsproxy_namespaces+0xa7/0x1e0 kernel/nsproxy.c:229
     ksys_unshare+0x3d2/0x770 kernel/fork.c:2969
     __do_sys_unshare kernel/fork.c:3037 [inline]
     __se_sys_unshare kernel/fork.c:3035 [inline]
     __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3035
     do_syscall_64+0xa1/0x530 arch/x86/entry/common.c:295

Fixes: 80da026a8e5d ("mm/slub: fix slab double-free in case of duplicate sysfs filename")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Link: http://lkml.kernel.org/r/20200602115033.1054-1-wanghai38@huawei.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5424,8 +5424,10 @@ static int sysfs_slab_add(struct kmem_ca
 
 	s->kobj.kset = cache_kset(s);
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
-	if (err)
+	if (err) {
+		kobject_put(&s->kobj);
 		goto out;
+	}
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
 	if (err)



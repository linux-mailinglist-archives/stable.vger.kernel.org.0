Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12DF2E3DD7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392059AbgL1OUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437756AbgL1OU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1901422573;
        Mon, 28 Dec 2020 14:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165213;
        bh=rKV0l2xULBjUrg/Gg+dr5a6PsKtl/a8O48oMgT0Uwhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqoK8EUm9MxnTE0ibFG9ZyDqRZiVzoNHVR8v0SBFPx3HBHbxCYt+K2MIyujHkQ5rv
         EzdiOEUzY2DL/VaK9grQhpuv8CHoyHaVHpKCZ21oAUvWV1WiuisSdFY+O0uCMSZfWP
         VeO/FauYORnoPmc9CNld4jb0+qdQMC1y4BMCxbis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 453/717] mm/vmalloc: Fix unlock order in s_stop()
Date:   Mon, 28 Dec 2020 13:47:31 +0100
Message-Id: <20201228125042.672572617@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 0a7dd4e901b8a4ee040ba953900d1d7120b34ee5 ]

When multiple locks are acquired, they should be released in reverse
order. For s_start() and s_stop() in mm/vmalloc.c, that is not the
case.

  s_start: mutex_lock(&vmap_purge_lock); spin_lock(&vmap_area_lock);
  s_stop : mutex_unlock(&vmap_purge_lock); spin_unlock(&vmap_area_lock);

This unlock sequence, though allowed, is not optimal. If a waiter is
present, mutex_unlock() will need to go through the slowpath of waking
up the waiter with preemption disabled. Fix that by releasing the
spinlock first before the mutex.

Link: https://lkml.kernel.org/r/20201213180843.16938-1-longman@redhat.com
Fixes: e36176be1c39 ("mm/vmalloc: rework vmap_area_lock")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6ae491a8b210f..75913f685c71e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3448,11 +3448,11 @@ static void *s_next(struct seq_file *m, void *p, loff_t *pos)
 }
 
 static void s_stop(struct seq_file *m, void *p)
-	__releases(&vmap_purge_lock)
 	__releases(&vmap_area_lock)
+	__releases(&vmap_purge_lock)
 {
-	mutex_unlock(&vmap_purge_lock);
 	spin_unlock(&vmap_area_lock);
+	mutex_unlock(&vmap_purge_lock);
 }
 
 static void show_numa_info(struct seq_file *m, struct vm_struct *v)
-- 
2.27.0




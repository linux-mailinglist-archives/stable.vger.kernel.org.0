Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2F62FAA26
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437331AbhART1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:27:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390437AbhARLiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1FFF22B49;
        Mon, 18 Jan 2021 11:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969815;
        bh=r3aX73LD1BAhBOy6fJZGZWqbVLml86YVG1OgwYtQJO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHnf8n0WXaBjHurYb/4My7liygID8TeWN/+KbTh+w5c46hnxebwobuNMbO2cdV+gI
         kLnffmWnsyovsPFieOiKt3L4si4TgYDcTumzjW0Juz+so0+oX51VjBoZ4kEJDwTPJF
         Om+VYC4XnvCYK4x+9qEBlkGHhMTqImdPzRDNo7Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 36/43] mm, slub: consider rest of partial list if acquire_slab() fails
Date:   Mon, 18 Jan 2021 12:34:59 +0100
Message-Id: <20210118113336.690197574@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 8ff60eb052eeba95cfb3efe16b08c9199f8121cf upstream.

acquire_slab() fails if there is contention on the freelist of the page
(probably because some other CPU is concurrently freeing an object from
the page).  In that case, it might make sense to look for a different page
(since there might be more remote frees to the page from other CPUs, and
we don't want contention on struct page).

However, the current code accidentally stops looking at the partial list
completely in that case.  Especially on kernels without CONFIG_NUMA set,
this means that get_partial() fails and new_slab_objects() falls back to
new_slab(), allocating new pages.  This could lead to an unnecessary
increase in memory fragmentation.

Link: https://lkml.kernel.org/r/20201228130853.1871516-1-jannh@google.com
Fixes: 7ced37197196 ("slub: Acquire_slab() avoid loop")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1830,7 +1830,7 @@ static void *get_partial_node(struct kme
 
 		t = acquire_slab(s, n, page, object == NULL, &objects);
 		if (!t)
-			break;
+			continue; /* cmpxchg raced */
 
 		available += objects;
 		if (!object) {



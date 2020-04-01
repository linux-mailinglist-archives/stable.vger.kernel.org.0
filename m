Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12BE19B3BD
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbgDAQcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733300AbgDAQcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:32:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA358212CC;
        Wed,  1 Apr 2020 16:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758743;
        bh=If+2ef+MMU2/Y/HWgpdpuL8hH5GfqGQEDo6IN9aP8sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDhOkNg4qRZDTEyUgHbcRrtmtOcjp8u1OUs8FItfaE1PQn9rdmAhgxMxDoDP07MYP
         +8TVyTMWfHh9NQA4o/l8JljOmqNE6bjnOoUJ/gQtwyY2Tx+3UFk0bbMMKE4yyK/D43
         6zOl8j1lzj+qZkr8SWeeuyxdqSUpLVKKhVsaATSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 23/91] mm: slub: be more careful about the double cmpxchg of freelist
Date:   Wed,  1 Apr 2020 18:17:19 +0200
Message-Id: <20200401161521.226572987@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5076190daded2197f62fe92cf69674488be44175 upstream.

This is just a cleanup addition to Jann's fix to properly update the
transaction ID for the slub slowpath in commit fd4d9c7d0c71 ("mm: slub:
add missing TID bump..").

The transaction ID is what protects us against any concurrent accesses,
but we should really also make sure to make the 'freelist' comparison
itself always use the same freelist value that we then used as the new
next free pointer.

Jann points out that if we do all of this carefully, we could skip the
transaction ID update for all the paths that only remove entries from
the lists, and only update the TID when adding entries (to avoid the ABA
issue with cmpxchg and list handling re-adding a previously seen value).

But this patch just does the "make sure to cmpxchg the same value we
used" rather than then try to be clever.

Acked-by: Jann Horn <jannh@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2788,11 +2788,13 @@ redo:
 	barrier();
 
 	if (likely(page == c->page)) {
-		set_freepointer(s, tail_obj, c->freelist);
+		void **freelist = READ_ONCE(c->freelist);
+
+		set_freepointer(s, tail_obj, freelist);
 
 		if (unlikely(!this_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
-				c->freelist, tid,
+				freelist, tid,
 				head, next_tid(tid)))) {
 
 			note_cmpxchg_failure("slab_free", s, tid);



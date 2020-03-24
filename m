Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224DE190EBA
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgCXNO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:32836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCXNOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:14:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9548A20775;
        Tue, 24 Mar 2020 13:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055665;
        bh=tIof/jlF4W0lxxddBY8yHhd6PhdVlYk1srdtJMcFEyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2l1J6MQY4f+GwOgQlRQi99tuzfVcOabOEKQ7qnrRYDhjPfRKES3KZeCL8tKOwAve8
         ivSa9NH4QPTiQK7OZDZRJVUFE8MBJ5Zq7LlVbdFtrF9aNzDJCs9D88QhQSkIYCz0R4
         5d3AMCGGjazcGxvlw/+XqRZ5scrsfycEH9Ta3aWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 48/65] mm: slub: be more careful about the double cmpxchg of freelist
Date:   Tue, 24 Mar 2020 14:11:09 +0100
Message-Id: <20200324130803.009089028@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
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
@@ -2926,11 +2926,13 @@ redo:
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



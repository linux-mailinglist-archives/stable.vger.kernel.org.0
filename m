Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4478019102E
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgCXN0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbgCXN0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:26:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 664EF206F6;
        Tue, 24 Mar 2020 13:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056361;
        bh=z5sA3TJymaqiXVItPs92sFSUpzo4nw8D7Z8DxuzeGkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLie3Cgpty0zQwIQRrXs78bM0u8QJucH+PSAEOn0ZiW1dhQaej/qOJKv5zuGAnpCl
         JphmONSI8K/U6nXSrH+U6aWOK+wxNkc1yAmzcdbk7khOgBXjFPs+vbdnLJ7t7Khlcl
         Mj3weo/AsOwYwSwh1PciDShyfrAVvZvDG31eam2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 098/119] mm: slub: be more careful about the double cmpxchg of freelist
Date:   Tue, 24 Mar 2020 14:11:23 +0100
Message-Id: <20200324130817.922500997@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
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
@@ -2978,11 +2978,13 @@ redo:
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



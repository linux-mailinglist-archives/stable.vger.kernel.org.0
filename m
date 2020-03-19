Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98CFD18B6FA
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgCSNTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728892AbgCSNTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:19:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DBA2098B;
        Thu, 19 Mar 2020 13:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623944;
        bh=AmjpSPBj4WtZlzlwhFS7i5lLcqju7uJ94qQo2ibr2BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNMm3WHAySLY9kvVsQJWWQymH4O8gtmd9k9gcPvv85AtW2HUfNLnilCXKwPp8z2Iw
         csKlUXpNGEqhGJNlpki4uH4Vt0eOYuvhOqZz4VDCaAzeUDQcI3aQ/BnyIPePguBlof
         Mj6NOqqP+DEWVYQucees9vQpWq0QgDYHcCcG5UeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 98/99] mm: slub: add missing TID bump in kmem_cache_alloc_bulk()
Date:   Thu, 19 Mar 2020 14:04:16 +0100
Message-Id: <20200319124008.208357378@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit fd4d9c7d0c71866ec0c2825189ebd2ce35bd95b8 upstream.

When kmem_cache_alloc_bulk() attempts to allocate N objects from a percpu
freelist of length M, and N > M > 0, it will first remove the M elements
from the percpu freelist, then call ___slab_alloc() to allocate the next
element and repopulate the percpu freelist. ___slab_alloc() can re-enable
IRQs via allocate_slab(), so the TID must be bumped before ___slab_alloc()
to properly commit the freelist head change.

Fix it by unconditionally bumping c->tid when entering the slowpath.

Cc: stable@vger.kernel.org
Fixes: ebe909e0fdb3 ("slub: improve bulk alloc strategy")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3123,6 +3123,15 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 
 		if (unlikely(!object)) {
 			/*
+			 * We may have removed an object from c->freelist using
+			 * the fastpath in the previous iteration; in that case,
+			 * c->tid has not been bumped yet.
+			 * Since ___slab_alloc() may reenable interrupts while
+			 * allocating memory, we should bump c->tid now.
+			 */
+			c->tid = next_tid(c->tid);
+
+			/*
 			 * Invoking slow path likely have side-effect
 			 * of re-populating per CPU c->freelist
 			 */



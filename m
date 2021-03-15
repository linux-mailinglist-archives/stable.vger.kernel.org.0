Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E48E33B73F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhCON7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232465AbhCON65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC6F764F3F;
        Mon, 15 Mar 2021 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816714;
        bh=kIE7+JWYHo6gcimnVLboVMJ0lGJorM7c6yvFGIdYEUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTmQqT2ztL1SO5C0+Cq/KXPZiTOsl6max8/6JAzWSWmZyYtUyGDIELDe/au+oAa3y
         u1BAZRWmqV1M3LR0qZG6SMr1r2ZP41hiegDzRevG4Zv/nsMN42OC+xFPsugNJscV4R
         SHtao8JfWzBfu40J/301Ivog3KpaSkslQ7u5thRU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Jann Horn <jannh@google.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 14/95] Revert "mm, slub: consider rest of partial list if acquire_slab() fails"
Date:   Mon, 15 Mar 2021 14:56:44 +0100
Message-Id: <20210315135740.737668913@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 9b1ea29bc0d7b94d420f96a0f4121403efc3dd85 upstream.

This reverts commit 8ff60eb052eeba95cfb3efe16b08c9199f8121cf.

The kernel test robot reports a huge performance regression due to the
commit, and the reason seems fairly straightforward: when there is
contention on the page list (which is what causes acquire_slab() to
fail), we do _not_ want to just loop and try again, because that will
transfer the contention to the 'n->list_lock' spinlock we hold, and
just make things even worse.

This is admittedly likely a problem only on big machines - the kernel
test robot report comes from a 96-thread dual socket Intel Xeon Gold
6252 setup, but the regression there really is quite noticeable:

   -47.9% regression of stress-ng.rawpkt.ops_per_sec

and the commit that was marked as being fixed (7ced37197196: "slub:
Acquire_slab() avoid loop") actually did the loop exit early very
intentionally (the hint being that "avoid loop" part of that commit
message), exactly to avoid this issue.

The correct thing to do may be to pick some kind of reasonable middle
ground: instead of breaking out of the loop on the very first sign of
contention, or trying over and over and over again, the right thing may
be to re-try _once_, and then give up on the second failure (or pick
your favorite value for "once"..).

Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/lkml/20210301080404.GF12822@xsang-OptiPlex-9020/
Cc: Jann Horn <jannh@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1846,7 +1846,7 @@ static void *get_partial_node(struct kme
 
 		t = acquire_slab(s, n, page, object == NULL, &objects);
 		if (!t)
-			continue; /* cmpxchg raced */
+			break;
 
 		available += objects;
 		if (!object) {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9593FDAEE
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245732AbhIAMg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343873AbhIAMeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:34:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6429B6101B;
        Wed,  1 Sep 2021 12:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499562;
        bh=1qwlMTCwX3PCcmkFnA7S1Z4+zxtyGF4FyrniO142TGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRmK+OIZmRmK7S9qHC3A447dtnXZxPY43EjBVvN8Su0HdIhy9WwBDNxyT6SPu4ISJ
         mVRoVSmGLgHD0veKWNhstdBOtXMHZA1IoDkuTmt7jRi1BDOYmToIOve+JF6hCK4Xe6
         RbTlob+hZwSJ60IsUDpxc3LUqMIjnGbUoriyvBFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Will Deacon <will@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Seiji Nishikawa <snishika@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.4 48/48] audit: move put_tree() to avoid trim_trees refcount underflow and UAF
Date:   Wed,  1 Sep 2021 14:28:38 +0200
Message-Id: <20210901122254.957547573@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

commit 67d69e9d1a6c889d98951c1d74b19332ce0565af upstream.

AUDIT_TRIM is expected to be idempotent, but multiple executions resulted
in a refcount underflow and use-after-free.

git bisect fingered commit fb041bb7c0a9	("locking/refcount: Consolidate
implementations of refcount_t") but this patch with its more thorough
checking that wasn't in the x86 assembly code merely exposed a previously
existing tree refcount imbalance in the case of tree trimming code that
was refactored with prune_one() to remove a tree introduced in
commit 8432c7006297 ("audit: Simplify locking around untag_chunk()")

Move the put_tree() to cover only the prune_one() case.

Passes audit-testsuite and 3 passes of "auditctl -t" with at least one
directory watch.

Cc: Jan Kara <jack@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Seiji Nishikawa <snishika@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 8432c7006297 ("audit: Simplify locking around untag_chunk()")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
[PM: reformatted/cleaned-up the commit description]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -595,7 +595,6 @@ static void prune_tree_chunks(struct aud
 		spin_lock(&hash_lock);
 	}
 	spin_unlock(&hash_lock);
-	put_tree(victim);
 }
 
 /*
@@ -604,6 +603,7 @@ static void prune_tree_chunks(struct aud
 static void prune_one(struct audit_tree *victim)
 {
 	prune_tree_chunks(victim, false);
+	put_tree(victim);
 }
 
 /* trim the uncommitted chunks from tree */



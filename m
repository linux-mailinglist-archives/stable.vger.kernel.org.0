Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0BC1C163D
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbgEANmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729445AbgEANmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:42:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1583208DB;
        Fri,  1 May 2020 13:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340541;
        bh=bj5FfiH9/bwBg7/KDQ9MB5vzY3FhvOzZI71BOOxtLGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnasfQ6A2DKSEPvE7FKzp19xi/dIY+YVK4dk93ZIeA+9PUUo5gSMFQOYf3pV6/lFX
         Eeyc2OYq8nlV2EtsXaSrNpcOsifslzcAkNUbm898P2p2kPZSIuGQChVmDp06iPVNZw
         7/uFogF323NEnOyyUZRlPR6r4bEzoJpNVUKHk4j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.6 014/106] propagate_one(): mnt_set_mountpoint() needs mount_lock
Date:   Fri,  1 May 2020 15:22:47 +0200
Message-Id: <20200501131546.025197036@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit b0d3869ce9eeacbb1bbd541909beeef4126426d5 upstream.

... to protect the modification of mp->m_count done by it.  Most of
the places that modify that thing also have namespace_lock held,
but not all of them can do so, so we really need mount_lock here.
Kudos to Piotr Krysiuk <piotras@gmail.com>, who'd spotted a related
bug in pivot_root(2) (fixed unnoticed in 5.3); search for other
similar turds has caught out this one.

Cc: stable@kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pnode.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -261,14 +261,13 @@ static int propagate_one(struct mount *m
 	child = copy_tree(last_source, last_source->mnt.mnt_root, type);
 	if (IS_ERR(child))
 		return PTR_ERR(child);
+	read_seqlock_excl(&mount_lock);
 	mnt_set_mountpoint(m, mp, child);
+	if (m->mnt_master != dest_master)
+		SET_MNT_MARK(m->mnt_master);
+	read_sequnlock_excl(&mount_lock);
 	last_dest = m;
 	last_source = child;
-	if (m->mnt_master != dest_master) {
-		read_seqlock_excl(&mount_lock);
-		SET_MNT_MARK(m->mnt_master);
-		read_sequnlock_excl(&mount_lock);
-	}
 	hlist_add_head(&child->mnt_hash, list);
 	return count_mounts(m->mnt_ns, child);
 }



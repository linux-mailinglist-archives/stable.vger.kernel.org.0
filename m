Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF0C1DB623
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgETOWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:22:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60896 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726436AbgETOWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:20 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-00034v-5I; Wed, 20 May 2020 15:22:18 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbt-007DNz-No; Wed, 20 May 2020 15:22:17 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        stable@kernel.org, "Piotr Krysiuk" <piotras@gmail.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Date:   Wed, 20 May 2020 15:13:30 +0100
Message-ID: <lsq.1589984008.458461925@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 02/99] propagate_one(): mnt_set_mountpoint() needs
 mount_lock
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/pnode.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -249,14 +249,13 @@ static int propagate_one(struct mount *m
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


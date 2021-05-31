Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1FF3961E0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbhEaOrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233103AbhEaOph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C4F36143D;
        Mon, 31 May 2021 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469320;
        bh=J92z31Ks7LNs9W0RjN69gwEGe59n8IsFFyb+fj2tIz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVu6oo0CnzILWfTPtOthOeV9GRT1q30HcOhEd32q/VBa3rTErC7mbAnMEv1ce+3Op
         ArLw5FhW9kCQ9Q3ZNL/pUJ3EZZJHkdnoExE4zhsFqg1c4U9x3seyM9U4YvxHzNd/hK
         vNzWanwyCLJiDf6n7JGWQOydrthcZ/E1QUEjbUMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 153/296] afs: Fix the nlink handling of dir-over-dir rename
Date:   Mon, 31 May 2021 15:13:28 +0200
Message-Id: <20210531130709.009434618@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit f610a5a29c3cfb7d37bdfa4ef52f72ea51f24a76 upstream.

Fix rename of one directory over another such that the nlink on the deleted
directory is cleared to 0 rather than being decremented to 1.

This was causing the generic/035 xfstest to fail.

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/162194384460.3999479.7605572278074191079.stgit@warthog.procyon.org.uk/ # v1
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/dir.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1842,7 +1842,9 @@ static void afs_rename_edit_dir(struct a
 	new_inode = d_inode(new_dentry);
 	if (new_inode) {
 		spin_lock(&new_inode->i_lock);
-		if (new_inode->i_nlink > 0)
+		if (S_ISDIR(new_inode->i_mode))
+			clear_nlink(new_inode);
+		else if (new_inode->i_nlink > 0)
 			drop_nlink(new_inode);
 		spin_unlock(&new_inode->i_lock);
 	}



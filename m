Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3171A4B95
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 23:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgDJVcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 17:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVcS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E8520753;
        Fri, 10 Apr 2020 21:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586554336;
        bh=WRe7kV3lhUCdTQYUsHgLOqTVX+XkxJ9DIyWyNEGVShg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GGIaX8QG2QAoGFU52jscBeZoES7VPlftAOI3JYbcvTOEGRymeLWqKivgN6ur4+5mS
         rgdB5VQy8xQmmEHcMXZGApJ2fUJpb/Q/ROs7R+OET7jtXPF6mPc+0L9WSYoK3uKgKo
         8VTYLCpe8PObwvXllc/KF+SIf8J+hwIlyumT6mpI=
Date:   Fri, 10 Apr 2020 14:32:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anton@tuxera.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, simon@tuxera.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 01/35] hfsplus: fix crash and filesystem
 corruption when deleting files
Message-ID: <20200410213216.yyMwFshfU%akpm@linux-foundation.org>
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Gander <simon@tuxera.com>
Subject: hfsplus: fix crash and filesystem corruption when deleting files

When removing files containing extended attributes, the hfsplus driver may
remove the wrong entries from the attributes b-tree, causing major
filesystem damage and in some cases even kernel crashes.

To remove a file, all its extended attributes have to be removed as well. 
The driver does this by looking up all keys in the attributes b-tree with
the cnid of the file.  Each of these entries then gets deleted using the
key used for searching, which doesn't contain the attribute's name when it
should.  Since the key doesn't contain the name, the deletion routine will
not find the correct entry and instead remove the one in front of it.  If
parent nodes have to be modified, these become corrupt as well.  This
causes invalid links and unsorted entries that not even macOS's fsck_hfs
is able to fix.

To fix this, modify the search key before an entry is deleted from the
attributes b-tree by copying the found entry's key into the search key,
therefore ensuring that the correct entry gets removed from the tree.

Link: http://lkml.kernel.org/r/20200327155541.1521-1-simon@tuxera.com
Signed-off-by: Simon Gander <simon@tuxera.com>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/attributes.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/hfsplus/attributes.c~hfsplus-fix-crash-and-filesystem-corruption-when-deleting-files
+++ a/fs/hfsplus/attributes.c
@@ -292,6 +292,10 @@ static int __hfsplus_delete_attr(struct
 		return -ENOENT;
 	}
 
+	/* Avoid btree corruption */
+	hfs_bnode_read(fd->bnode, fd->search_key,
+			fd->keyoffset, fd->keylength);
+
 	err = hfs_brec_remove(fd);
 	if (err)
 		return err;
_

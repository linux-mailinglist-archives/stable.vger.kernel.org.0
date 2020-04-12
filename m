Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449711A5D0E
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 08:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgDLGoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 02:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgDLGoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Apr 2020 02:44:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F044720575;
        Sun, 12 Apr 2020 06:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586673869;
        bh=WZOCOWmdMOUFNdUdWiljF2e/ZiKfYKATe6aQtEFz50c=;
        h=Date:From:To:Subject:From;
        b=SDHbBeiDjl1gwjL5WD1oByD/9/NvXv6Vc/E17RdNumyGCbiCwJdMjwA3RIM6WhnaF
         taAa5XIPB2/rq8Ppfbl7vo874xS9gbhePVWaLShl1Bbr40MXIixRyLp/wmK8rFUIat
         hFfAGPepwZbO54lt53oSyRr7u8B5QdMrAsCTEs6w=
Date:   Sat, 11 Apr 2020 23:44:28 -0700
From:   akpm@linux-foundation.org
To:     anton@tuxera.com, mm-commits@vger.kernel.org, simon@tuxera.com,
        stable@vger.kernel.org
Subject:  [merged]
 hfsplus-fix-crash-and-filesystem-corruption-when-deleting-files.patch
 removed from -mm tree
Message-ID: <20200412064428.XK8T3-R3P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hfsplus: fix crash and filesystem corruption when deleting files
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-crash-and-filesystem-corruption-when-deleting-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from simon@tuxera.com are



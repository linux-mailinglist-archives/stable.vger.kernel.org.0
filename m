Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C3E1B3D13
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgDVKLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729206AbgDVKLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:11:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD28F2075A;
        Wed, 22 Apr 2020 10:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550290;
        bh=SoVqO3bK3jHNnFnqoHbBV+IZFxZYUJeXCaLy+Ihncvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvn4vTwuWvVK6NBiQcgDW1fIS0ss+l5+m9+aT8JMtNskukyhLe3q5y82XCLbOVEqY
         ADKKPxgZpWyHGskwOZQ/eQrhlaK1TYnPDCAeYAZdEZjfkuOxRo9wDVS+a9hD7CRntz
         yQXvSZsZj9eV6h27lvcXQJpe+vZjwEUKtejPeRKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Gander <simon@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 085/199] hfsplus: fix crash and filesystem corruption when deleting files
Date:   Wed, 22 Apr 2020 11:56:51 +0200
Message-Id: <20200422095106.605369560@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Gander <simon@tuxera.com>

commit 25efb2ffdf991177e740b2f63e92b4ec7d310a92 upstream.

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

Signed-off-by: Simon Gander <simon@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200327155541.1521-1-simon@tuxera.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hfsplus/attributes.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/hfsplus/attributes.c
+++ b/fs/hfsplus/attributes.c
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



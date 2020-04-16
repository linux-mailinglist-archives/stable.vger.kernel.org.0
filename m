Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490B21AC351
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898286AbgDPNlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897432AbgDPNlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:41:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2BC1214D8;
        Thu, 16 Apr 2020 13:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044471;
        bh=SoVqO3bK3jHNnFnqoHbBV+IZFxZYUJeXCaLy+Ihncvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYXe2YRas108WGyWdSAnRdjKTg6668K5Rvy6s8/ujPwOACFGg4DB247DGBZyvuBr8
         xrGi9dCHk08zDs/yEp3qel4umRNSGBbPZvKZfYtiarxkDeOWkoe08wRZ2ASGEN8qAV
         k32YUwUMzA3plkJSVUtPT25Qd9d6kTxydxqULeZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Gander <simon@tuxera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 231/257] hfsplus: fix crash and filesystem corruption when deleting files
Date:   Thu, 16 Apr 2020 15:24:42 +0200
Message-Id: <20200416131354.568669149@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
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



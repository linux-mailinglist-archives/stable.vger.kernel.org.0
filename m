Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03F42A5127
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgKCUib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729946AbgKCUia (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A35A422277;
        Tue,  3 Nov 2020 20:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435909;
        bh=3qZ/qGorLAh4jigNgfDXPv/1lqkCfejbEgnOtu5QMmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4HY85q9+PIGmkVH/L/bQwVgAg0DS1CnCWWzuMMA5Pdp828rle2vnx6QhxRR68qSU
         3kDyd3iVurqXFsXVy4YvMb/l963/f5T2eMyoQ6nMii9ytkRueyFslrLTRhEQICUkWe
         fmiKAiv9FGUC0RaWad+0rPlQgdCiug9SAGyUmVuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 035/391] afs: Alter dirty range encoding in page->private
Date:   Tue,  3 Nov 2020 21:31:26 +0100
Message-Id: <20201103203350.091158536@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 65dd2d6072d393a3aa14ded8afa9a12f27d9c8ad ]

Currently, page->private on an afs page is used to store the range of
dirtied data within the page, where the range includes the lower bound, but
excludes the upper bound (e.g. 0-1 is a range covering a single byte).

This, however, requires a superfluous bit for the last-byte bound so that
on a 4KiB page, it can say 0-4096 to indicate the whole page, the idea
being that having both numbers the same would indicate an empty range.
This is unnecessary as the PG_private bit is clear if it's an empty range
(as is PG_dirty).

Alter the way the dirty range is encoded in page->private such that the
upper bound is reduced by 1 (e.g. 0-0 is then specified the same single
byte range mentioned above).

Applying this to both bounds frees up two bits, one of which can be used in
a future commit.

This allows the afs filesystem to be compiled on ppc32 with 64K pages;
without this, the following warnings are seen:

../fs/afs/internal.h: In function 'afs_page_dirty_to':
../fs/afs/internal.h:881:15: warning: right shift count >= width of type [-Wshift-count-overflow]
  881 |  return (priv >> __AFS_PAGE_PRIV_SHIFT) & __AFS_PAGE_PRIV_MASK;
      |               ^~
../fs/afs/internal.h: In function 'afs_page_dirty':
../fs/afs/internal.h:886:28: warning: left shift count >= width of type [-Wshift-count-overflow]
  886 |  return ((unsigned long)to << __AFS_PAGE_PRIV_SHIFT) | from;
      |                            ^~

Fixes: 4343d00872e1 ("afs: Get rid of the afs_writeback record")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h | 6 +++---
 fs/afs/write.c    | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 523bf9698ecdc..fc96c090893f7 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -862,7 +862,7 @@ struct afs_vnode_cache_aux {
  * splitting the field into two parts.  However, we need to represent a range
  * 0...PAGE_SIZE inclusive, so we can't support 64K pages on a 32-bit system.
  */
-#if PAGE_SIZE > 32768
+#ifdef CONFIG_64BIT
 #define __AFS_PAGE_PRIV_MASK	0xffffffffUL
 #define __AFS_PAGE_PRIV_SHIFT	32
 #else
@@ -877,12 +877,12 @@ static inline size_t afs_page_dirty_from(unsigned long priv)
 
 static inline size_t afs_page_dirty_to(unsigned long priv)
 {
-	return (priv >> __AFS_PAGE_PRIV_SHIFT) & __AFS_PAGE_PRIV_MASK;
+	return ((priv >> __AFS_PAGE_PRIV_SHIFT) & __AFS_PAGE_PRIV_MASK) + 1;
 }
 
 static inline unsigned long afs_page_dirty(size_t from, size_t to)
 {
-	return ((unsigned long)to << __AFS_PAGE_PRIV_SHIFT) | from;
+	return ((unsigned long)(to - 1) << __AFS_PAGE_PRIV_SHIFT) | from;
 }
 
 #include <trace/events/afs.h>
diff --git a/fs/afs/write.c b/fs/afs/write.c
index ea1768b3c0b56..1a49f5c89342e 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -93,7 +93,7 @@ int afs_write_begin(struct file *file, struct address_space *mapping,
 	/* We want to store information about how much of a page is altered in
 	 * page->private.
 	 */
-	BUILD_BUG_ON(PAGE_SIZE > 32768 && sizeof(page->private) < 8);
+	BUILD_BUG_ON(PAGE_SIZE - 1 > __AFS_PAGE_PRIV_MASK && sizeof(page->private) < 8);
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
-- 
2.27.0




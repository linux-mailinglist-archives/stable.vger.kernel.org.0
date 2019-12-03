Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57567111FF2
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbfLCWkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:40:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfLCWkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53CD42084B;
        Tue,  3 Dec 2019 22:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412841;
        bh=Y3JzWDCNjD/s/xO5SK0WpMAQ7VKjLb8pxh3zBIVmCuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2u2at9q/6m3fqrn0OoLzWP9Bn9oV+yfCyqQkrhTjuLYHvcja4A8DfaX/Kba3VpXn
         OVdAXw5q+TYcma5rGdP1VtMHpBLNKR7nFXtqfkUJIOD6WG9fW4O/2sx3CREImU10Hy
         Ui7kih170GJJb1cutEpLjvC4Tzsimn4GA/df8bfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 036/135] idr: Fix idr_get_next_ul race with idr_remove
Date:   Tue,  3 Dec 2019 23:34:36 +0100
Message-Id: <20191203213013.337775167@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 5a74ac4c4a97bd8b7dba054304d598e2a882fea6 ]

Commit 5c089fd0c734 ("idr: Fix idr_get_next race with idr_remove")
neglected to fix idr_get_next_ul().  As far as I can tell, nobody's
actually using this interface under the RCU read lock, but fix it now
before anybody decides to use it.

Fixes: 5c089fd0c734 ("idr: Fix idr_get_next race with idr_remove")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/idr.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 66a3748924828..c2cf2c52bbde5 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -215,7 +215,7 @@ int idr_for_each(const struct idr *idr,
 EXPORT_SYMBOL(idr_for_each);
 
 /**
- * idr_get_next() - Find next populated entry.
+ * idr_get_next_ul() - Find next populated entry.
  * @idr: IDR handle.
  * @nextid: Pointer to an ID.
  *
@@ -224,7 +224,7 @@ EXPORT_SYMBOL(idr_for_each);
  * to the ID of the found value.  To use in a loop, the value pointed to by
  * nextid must be incremented by the user.
  */
-void *idr_get_next(struct idr *idr, int *nextid)
+void *idr_get_next_ul(struct idr *idr, unsigned long *nextid)
 {
 	struct radix_tree_iter iter;
 	void __rcu **slot;
@@ -245,18 +245,14 @@ void *idr_get_next(struct idr *idr, int *nextid)
 	}
 	if (!slot)
 		return NULL;
-	id = iter.index + base;
-
-	if (WARN_ON_ONCE(id > INT_MAX))
-		return NULL;
 
-	*nextid = id;
+	*nextid = iter.index + base;
 	return entry;
 }
-EXPORT_SYMBOL(idr_get_next);
+EXPORT_SYMBOL(idr_get_next_ul);
 
 /**
- * idr_get_next_ul() - Find next populated entry.
+ * idr_get_next() - Find next populated entry.
  * @idr: IDR handle.
  * @nextid: Pointer to an ID.
  *
@@ -265,22 +261,17 @@ EXPORT_SYMBOL(idr_get_next);
  * to the ID of the found value.  To use in a loop, the value pointed to by
  * nextid must be incremented by the user.
  */
-void *idr_get_next_ul(struct idr *idr, unsigned long *nextid)
+void *idr_get_next(struct idr *idr, int *nextid)
 {
-	struct radix_tree_iter iter;
-	void __rcu **slot;
-	unsigned long base = idr->idr_base;
 	unsigned long id = *nextid;
+	void *entry = idr_get_next_ul(idr, &id);
 
-	id = (id < base) ? 0 : id - base;
-	slot = radix_tree_iter_find(&idr->idr_rt, &iter, id);
-	if (!slot)
+	if (WARN_ON_ONCE(id > INT_MAX))
 		return NULL;
-
-	*nextid = iter.index + base;
-	return rcu_dereference_raw(*slot);
+	*nextid = id;
+	return entry;
 }
-EXPORT_SYMBOL(idr_get_next_ul);
+EXPORT_SYMBOL(idr_get_next);
 
 /**
  * idr_replace() - replace pointer for given ID.
-- 
2.20.1




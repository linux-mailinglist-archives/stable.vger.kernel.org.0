Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0288024A8CD
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 23:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHSV7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 17:59:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44533 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726967AbgHSV7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 17:59:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597874377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=izWdDkgMKqfeEdI+wRRQxcqDovrhEIrqQ+VR8ai8/Zc=;
        b=AB517UjUqAoZEr9EeV9MOkB+w98wnqsl+x23y0+mO570fWK3HxgksxzqTDes4n9kLGeEdg
        NSaUTS3NotaJCAOmU6PBqEawyDch0dX1SFfTMdbV+yWffJFvSqW/OG5X2CZe7zI09G0M6T
        j/ttJMn19Ad5h9BLquMgk+sx/ALTbnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-Fsphs-7oOIGZUYTLiEF1yA-1; Wed, 19 Aug 2020 17:59:32 -0400
X-MC-Unique: Fsphs-7oOIGZUYTLiEF1yA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F5E48030A3;
        Wed, 19 Aug 2020 21:59:31 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 048745C1D0;
        Wed, 19 Aug 2020 21:59:29 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Andreas Fischer <netfilter@d9c.eu>, stable@vger.kernel.org
Subject: [PATCH nf 1/2] nft_set_rbtree: Handle outcomes of tree rotations in overlap detection
Date:   Wed, 19 Aug 2020 23:59:14 +0200
Message-Id: <4336e6851a0d81992990ca1ec05ab83a43b94862.1597873312.git.sbrivio@redhat.com>
In-Reply-To: <cover.1597873312.git.sbrivio@redhat.com>
References: <cover.1597873312.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Checks for partial overlaps on insertion assume that end elements
are always descendant nodes of their corresponding start, because
they are inserted later. However, this is not the case if a
previous delete operation caused a tree rotation as part of
rebalancing.

Taking the issue reported by Andreas Fischer as an example, if we
omit delete operations, the existing procedure works because,
equivalently, we are inserting a start item with value 40 in the
this region of the red-black tree with single-sized intervals:

                                  overlap flag
                   10 (start)
                  /  \            false
                      20 (start)
                     /  \         false
                         30 (start)
                        /  \      false
                            60 (start)
                           /  \   false
                         50 (end)
                        /  \      false
                      20 (end)
                     /  \         false
                         40 (start)

if we now delete interval 30 - 30, the tree can be rearranged in
a way similar to this (note the rotation involving 50 - 50):

                                  overlap flag
                   10 (start)
                  /  \            false
                      20 (start)
                     /  \         false
                         25 (start)
                        /  \      false
                            70 (start)
                           /  \   false
                         50 (end)
                        /  \      true (from rule a1.)
                      50 (start)
                     /  \         true
                   40 (start)

and we traverse interval 50 - 50 from the opposite direction
compared to what was expected.

To deal with those cases, add a start-before-start rule, b4.,
that covers traversal of existing intervals from the right.

We now need to restrict start-after-end rule b3. to cases
where there are no occurring nodes between existing start and
end elements, because addition of rule b4. isn't sufficient to
ensure that the pre-existing end element we encounter while
descending the tree corresponds to a start element of an
interval that we already traversed entirely.

Different types of overlap detection on trees with rotations
resulting from re-balancing will be covered by nft test case
sets/0044interval_overlap_1.

Reported-by: Andreas Fischer <netfilter@d9c.eu>
Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1449
Cc: <stable@vger.kernel.org> # 5.6.x
Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_rbtree.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 4b2834fd17b2..27668f4e44ea 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -238,21 +238,27 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 *
 	 * b1. _ _ __>|  !_ _ __|  (insert end before existing start)
 	 * b2. _ _ ___|  !_ _ _>|  (insert end after existing start)
-	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end)
+	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end, as a leaf)
+	 *            '--' no nodes falling in this range
+	 * b4.          >|_ _   !  (insert start before existing start)
 	 *
 	 * Case a3. resolves to b3.:
 	 * - if the inserted start element is the leftmost, because the '0'
 	 *   element in the tree serves as end element
-	 * - otherwise, if an existing end is found. Note that end elements are
-	 *   always inserted after corresponding start elements.
+	 * - otherwise, if an existing end is found immediately to the left. If
+	 *   there are existing nodes in between, we need to further descend the
+	 *   tree before we can conclude the new start isn't causing an overlap
+	 *
+	 * or to b4., which, preceded by a3., means we already traversed one or
+	 * more existing intervals entirely, from the right.
 	 *
 	 * For a new, rightmost pair of elements, we'll hit cases b3. and b2.,
 	 * in that order.
 	 *
 	 * The flag is also cleared in two special cases:
 	 *
-	 * b4. |__ _ _!|<_ _ _   (insert start right before existing end)
-	 * b5. |__ _ >|!__ _ _   (insert end right after existing start)
+	 * b5. |__ _ _!|<_ _ _   (insert start right before existing end)
+	 * b6. |__ _ >|!__ _ _   (insert end right after existing start)
 	 *
 	 * which always happen as last step and imply that no further
 	 * overlapping is possible.
@@ -272,7 +278,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			if (nft_rbtree_interval_start(new)) {
 				if (nft_rbtree_interval_end(rbe) &&
 				    nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
+				    !nft_set_elem_expired(&rbe->ext) && !*p)
 					overlap = false;
 			} else {
 				overlap = nft_rbtree_interval_end(rbe) &&
@@ -288,10 +294,9 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 					  nft_set_elem_active(&rbe->ext,
 							      genmask) &&
 					  !nft_set_elem_expired(&rbe->ext);
-			} else if (nft_rbtree_interval_end(rbe) &&
-				   nft_set_elem_active(&rbe->ext, genmask) &&
+			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
 				   !nft_set_elem_expired(&rbe->ext)) {
-				overlap = true;
+				overlap = nft_rbtree_interval_end(rbe);
 			}
 		} else {
 			if (nft_rbtree_interval_end(rbe) &&
-- 
2.28.0


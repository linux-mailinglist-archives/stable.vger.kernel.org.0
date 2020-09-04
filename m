Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2999C25DB8A
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgIDOZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 10:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730458AbgIDNeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:34:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC94321556;
        Fri,  4 Sep 2020 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226255;
        bh=HFapN7zvtezMJU2LiF4VaXhhRaky00ItAw3UbeyTDWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzpXfwoXQ+U6j4/hneahUFy7kPQUE0mqzWKwkeM9n0HE559fUWOU3VEgSVsUjBuAx
         ciLtzUwScbKdrZLfCImWBlVCLr7ppAqo5zwFrqzmihyBghj5xNs1ThYoP7KoNGWXLC
         yNKu9hCbBON6othyl/bZQTa9ykpDg18E8/qTbNe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Fischer <netfilter@d9c.eu>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.8 03/17] netfilter: nft_set_rbtree: Handle outcomes of tree rotations in overlap detection
Date:   Fri,  4 Sep 2020 15:30:02 +0200
Message-Id: <20200904120258.147134635@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.983551609@linuxfoundation.org>
References: <20200904120257.983551609@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

commit 226a88de473e475cb9f993682a1c7d0c2b451ad8 upstream.

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_set_rbtree.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -238,21 +238,27 @@ static int __nft_rbtree_insert(const str
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
@@ -272,7 +278,7 @@ static int __nft_rbtree_insert(const str
 			if (nft_rbtree_interval_start(new)) {
 				if (nft_rbtree_interval_end(rbe) &&
 				    nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
+				    !nft_set_elem_expired(&rbe->ext) && !*p)
 					overlap = false;
 			} else {
 				overlap = nft_rbtree_interval_end(rbe) &&
@@ -288,10 +294,9 @@ static int __nft_rbtree_insert(const str
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



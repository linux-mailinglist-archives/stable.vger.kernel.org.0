Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0D026B4E7
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgIOXdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727153AbgIOOgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:36:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BFD6223BF;
        Tue, 15 Sep 2020 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179989;
        bh=g9SHDM3H2JEOEEdifkFbeSNLr4gOLGNQG+IjRWov03Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDhJEkDzbp3DrKIJ/zMLa4ac2LQnNHHDe8KJ1769N2B/3AFqydwof1YHl06KtA/pd
         PfkZtWnd1MvLACZv4mVpbphGmVhz9NTRqrTIdOgDsBWz0gVU9BNm5IgWlVTtK/iVQB
         dKdMitG8cWNazn5sfmzswApeYESKGL/tVu8gyu3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 065/177] netfilter: nft_set_rbtree: Detect partial overlap with start endpoint match
Date:   Tue, 15 Sep 2020 16:12:16 +0200
Message-Id: <20200915140656.749292563@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 0726763043dc10dd4c12481f050b1a5ef8f15410 ]

Getting creative with nft and omitting the interval_overlap()
check from the set_overlap() function, without omitting
set_overlap() altogether, led to the observation of a partial
overlap that wasn't detected, and would actually result in
replacement of the end element of an existing interval.

This is due to the fact that we'll return -EEXIST on a matching,
pre-existing start element, instead of -ENOTEMPTY, and the error
is cleared by API if NLM_F_EXCL is not given. At this point, we
can insert a matching start, and duplicate the end element as long
as we don't end up into other intervals.

For instance, inserting interval 0 - 2 with an existing 0 - 3
interval would result in a single 0 - 2 interval, and a dangling
'3' end element. This is because nft will proceed after inserting
the '0' start element as no error is reported, and no further
conflicting intervals are detected on insertion of the end element.

This needs a different approach as it's a local condition that can
be detected by looking for duplicate ends coming from left and
right, separately. Track those and directly report -ENOTEMPTY on
duplicated end elements for a matching start.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index b85ce6f0c0a6f..f317ad80cd6bc 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -218,11 +218,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_set_ext **ext)
 {
+	bool overlap = false, dup_end_left = false, dup_end_right = false;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *parent, **p;
-	bool overlap = false;
 	int d;
 
 	/* Detect overlaps as we descend the tree. Set the flag in these cases:
@@ -262,6 +262,20 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 *
 	 * which always happen as last step and imply that no further
 	 * overlapping is possible.
+	 *
+	 * Another special case comes from the fact that start elements matching
+	 * an already existing start element are allowed: insertion is not
+	 * performed but we return -EEXIST in that case, and the error will be
+	 * cleared by the caller if NLM_F_EXCL is not present in the request.
+	 * This way, request for insertion of an exact overlap isn't reported as
+	 * error to userspace if not desired.
+	 *
+	 * However, if the existing start matches a pre-existing start, but the
+	 * end element doesn't match the corresponding pre-existing end element,
+	 * we need to report a partial overlap. This is a local condition that
+	 * can be noticed without need for a tracking flag, by checking for a
+	 * local duplicated end for a corresponding start, from left and right,
+	 * separately.
 	 */
 
 	parent = NULL;
@@ -281,19 +295,35 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				    !nft_set_elem_expired(&rbe->ext) && !*p)
 					overlap = false;
 			} else {
+				if (dup_end_left && !*p)
+					return -ENOTEMPTY;
+
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
 							      genmask) &&
 					  !nft_set_elem_expired(&rbe->ext);
+
+				if (overlap) {
+					dup_end_right = true;
+					continue;
+				}
 			}
 		} else if (d > 0) {
 			p = &parent->rb_right;
 
 			if (nft_rbtree_interval_end(new)) {
+				if (dup_end_right && !*p)
+					return -ENOTEMPTY;
+
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
 							      genmask) &&
 					  !nft_set_elem_expired(&rbe->ext);
+
+				if (overlap) {
+					dup_end_left = true;
+					continue;
+				}
 			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
 				   !nft_set_elem_expired(&rbe->ext)) {
 				overlap = nft_rbtree_interval_end(rbe);
@@ -321,6 +351,8 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				p = &parent->rb_left;
 			}
 		}
+
+		dup_end_left = dup_end_right = false;
 	}
 
 	if (overlap)
-- 
2.25.1




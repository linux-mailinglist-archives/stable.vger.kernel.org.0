Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989C21B3FB5
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbgDVKkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730143AbgDVKVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:21:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DCD02168B;
        Wed, 22 Apr 2020 10:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550871;
        bh=TMC+9tWDsQ38FwH4z1iUXe3pVK+rAiUdtnxJ3vLWwfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQWnAZMbaYm0QvVs+5e6ihux5YcaB9i5RHA2MjfHMazjQHTKUJ8wwGHWonTQiYLJe
         q5gv6bRRil1rtzRZ3d1ZDYjxSk6S7ROM4jIZa24/Ep0AXmerzwM6GzriSrYnTA7DzP
         z6r/ouw+UPRZAp7LKhzMIbJdL6YX6hUutPh57w9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH 5.6 001/166] netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion
Date:   Wed, 22 Apr 2020 11:55:28 +0200
Message-Id: <20200422095048.103244876@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

commit 72239f2795fab9a58633bd0399698ff7581534a3 upstream.

Case a1. for overlap detection in __nft_rbtree_insert() is not a valid
one: start-after-start is not needed to detect any type of interval
overlap and it actually results in a false positive if, while
descending the tree, this is the only step we hit after starting from
the root.

This introduced a regression, as reported by Pablo, in Python tests
cases ip/ip.t and ip/numgen.t:

  ip/ip.t: ERROR: line 124: add rule ip test-ip4 input ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter: This rule should not have failed.
  ip/numgen.t: ERROR: line 7: add rule ip test-ip4 pre dnat to numgen inc mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200}: This rule should not have failed.

Drop case a1. and renumber others, so that they are a bit clearer. In
order for these diagrams to be readily understandable, a bigger rework
is probably needed, such as an ASCII art of the actual rbtree (instead
of a flattened version).

Shell script test sets/0044interval_overlap_0 should cover all
possible cases for false negatives, so I consider that test case still
sufficient after this change.

v2: Fix comments for cases a3. and b3.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_set_rbtree.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -218,27 +218,26 @@ static int __nft_rbtree_insert(const str
 
 	/* Detect overlaps as we descend the tree. Set the flag in these cases:
 	 *
-	 * a1. |__ _ _?  >|__ _ _  (insert start after existing start)
-	 * a2. _ _ __>|  ?_ _ __|  (insert end before existing end)
-	 * a3. _ _ ___|  ?_ _ _>|  (insert end after existing end)
-	 * a4. >|__ _ _   _ _ __|  (insert start before existing end)
+	 * a1. _ _ __>|  ?_ _ __|  (insert end before existing end)
+	 * a2. _ _ ___|  ?_ _ _>|  (insert end after existing end)
+	 * a3. _ _ ___? >|_ _ __|  (insert start before existing end)
 	 *
 	 * and clear it later on, as we eventually reach the points indicated by
 	 * '?' above, in the cases described below. We'll always meet these
 	 * later, locally, due to tree ordering, and overlaps for the intervals
 	 * that are the closest together are always evaluated last.
 	 *
-	 * b1. |__ _ _!  >|__ _ _  (insert start after existing end)
-	 * b2. _ _ __>|  !_ _ __|  (insert end before existing start)
-	 * b3. !_____>|            (insert end after existing start)
+	 * b1. _ _ __>|  !_ _ __|  (insert end before existing start)
+	 * b2. _ _ ___|  !_ _ _>|  (insert end after existing start)
+	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end)
 	 *
-	 * Case a4. resolves to b1.:
+	 * Case a3. resolves to b3.:
 	 * - if the inserted start element is the leftmost, because the '0'
 	 *   element in the tree serves as end element
 	 * - otherwise, if an existing end is found. Note that end elements are
 	 *   always inserted after corresponding start elements.
 	 *
-	 * For a new, rightmost pair of elements, we'll hit cases b1. and b3.,
+	 * For a new, rightmost pair of elements, we'll hit cases b3. and b2.,
 	 * in that order.
 	 *
 	 * The flag is also cleared in two special cases:
@@ -262,9 +261,9 @@ static int __nft_rbtree_insert(const str
 			p = &parent->rb_left;
 
 			if (nft_rbtree_interval_start(new)) {
-				overlap = nft_rbtree_interval_start(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask);
+				if (nft_rbtree_interval_end(rbe) &&
+				    nft_set_elem_active(&rbe->ext, genmask))
+					overlap = false;
 			} else {
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A191EC5E3
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 01:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgFBXun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 19:50:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39569 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726589AbgFBXun (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 19:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591141841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6k/L7Ky2MPqVYpdcNM6oaE28a/AueQhDgfNjPbMou6A=;
        b=gYJ2CEvdWi78rIFsh/uTHauWXfnyF1ANWTd6fN6dpVJEQ/4svwebxbNI2C72CPMbiWrCzU
        7Ni1CvN6zhMgHt/SLqBczGsNAe3/IxcBsf01B/wxVFsRcFffOm7UJPeePAT1TKBaGInbQR
        nXwv/lBmJZ/g53WpRBPxvNvF3xSULyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226--Z2gAWyHP72pM0ZihbM52w-1; Tue, 02 Jun 2020 19:50:37 -0400
X-MC-Unique: -Z2gAWyHP72pM0ZihbM52w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9E38801503;
        Tue,  2 Jun 2020 23:50:35 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A77F210013D2;
        Tue,  2 Jun 2020 23:50:34 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Mike Dillinger <miked@softtalker.com>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH nf] nft_set_rbtree: Don't account for expired elements on insertion
Date:   Wed,  3 Jun 2020 01:50:11 +0200
Message-Id: <924e80c7b563cc6522a241b123c955c18983edb1.1591141588.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While checking the validity of insertion in __nft_rbtree_insert(),
we currently ignore conflicting elements and intervals only if they
are not active within the next generation.

However, if we consider expired elements and intervals as
potentially conflicting and overlapping, we'll return error for
entries that should be added instead. This is particularly visible
with garbage collection intervals that are comparable with the
element timeout itself, as reported by Mike Dillinger.

Other than the simple issue of denying insertion of valid entries,
this might also result in insertion of a single element (opening or
closing) out of a given interval. With single entries (that are
inserted as intervals of size 1), this leads in turn to the creation
of new intervals. For example:

  # nft add element t s { 192.0.2.1 }
  # nft list ruleset
  [...]
     elements = { 192.0.2.1-255.255.255.255 }

Always ignore expired elements active in the next generation, while
checking for conflicts.

It might be more convenient to introduce a new macro that covers
both inactive and expired items, as this type of check also appears
quite frequently in other set back-ends. This is however beyond the
scope of this fix and can be deferred to a separate patch.

Other than the overlap detection cases introduced by commit
7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps
on insertion"), we also have to cover the original conflict check
dealing with conflicts between two intervals of size 1, which was
introduced before support for timeout was introduced. This won't
return an error to the user as -EEXIST is masked by nft if
NLM_F_EXCL is not given, but would result in a silent failure
adding the entry.

Reported-by: Mike Dillinger <miked@softtalker.com>
Cc: <stable@vger.kernel.org> # 5.6.x
Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_rbtree.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 62f416bc0579..b6aad3fc46c3 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -271,12 +271,14 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 
 			if (nft_rbtree_interval_start(new)) {
 				if (nft_rbtree_interval_end(rbe) &&
-				    nft_set_elem_active(&rbe->ext, genmask))
+				    nft_set_elem_active(&rbe->ext, genmask) &&
+				    !nft_set_elem_expired(&rbe->ext))
 					overlap = false;
 			} else {
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
-							      genmask);
+							      genmask) &&
+					  !nft_set_elem_expired(&rbe->ext);
 			}
 		} else if (d > 0) {
 			p = &parent->rb_right;
@@ -284,9 +286,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			if (nft_rbtree_interval_end(new)) {
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
-							      genmask);
+							      genmask) &&
+					  !nft_set_elem_expired(&rbe->ext);
 			} else if (nft_rbtree_interval_end(rbe) &&
-				   nft_set_elem_active(&rbe->ext, genmask)) {
+				   nft_set_elem_active(&rbe->ext, genmask) &&
+				   !nft_set_elem_expired(&rbe->ext)) {
 				overlap = true;
 			}
 		} else {
@@ -294,15 +298,18 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			    nft_rbtree_interval_start(new)) {
 				p = &parent->rb_left;
 
-				if (nft_set_elem_active(&rbe->ext, genmask))
+				if (nft_set_elem_active(&rbe->ext, genmask) &&
+				    !nft_set_elem_expired(&rbe->ext))
 					overlap = false;
 			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
 				p = &parent->rb_right;
 
-				if (nft_set_elem_active(&rbe->ext, genmask))
+				if (nft_set_elem_active(&rbe->ext, genmask) &&
+				    !nft_set_elem_expired(&rbe->ext))
 					overlap = false;
-			} else if (nft_set_elem_active(&rbe->ext, genmask)) {
+			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
+				   !nft_set_elem_expired(&rbe->ext)) {
 				*ext = &rbe->ext;
 				return -EEXIST;
 			} else {
-- 
2.26.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BED35BD9F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhDLIwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238740AbhDLIul (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CEE561244;
        Mon, 12 Apr 2021 08:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217424;
        bh=4yMZBZg09kXmZI4rkxQUzw1AjZ2thnr7Fu0KvTSZ1YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8yLQZ5oYwBlBywuZ+khWHOY/ZLJqXlRBVXgo0l8PKL7ksd5SHiHs1SP+OBQ2F/Vu
         Z0oc7Er/hU+Mn7LPvqoGB+3+P5C0MhQpvtvXeYb9RW7AD3/jY10neqL3TbpuTbvsmU
         tX2WvsauWotpfTnQ0z/43JKHasKpy0ISePXSPq3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 010/188] selinux: make nslot handling in avtab more robust
Date:   Mon, 12 Apr 2021 10:38:44 +0200
Message-Id: <20210412084014.003364822@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 442dc00f82a9727dc0c48c44f792c168f593c6df upstream.

1. Make sure all fileds are initialized in avtab_init().
2. Slightly refactor avtab_alloc() to use the above fact.
3. Use h->nslot == 0 as a sentinel in the access functions to prevent
   dereferencing h->htable when it's not allocated.

Cc: stable@vger.kernel.org
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/avtab.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/security/selinux/ss/avtab.c
+++ b/security/selinux/ss/avtab.c
@@ -109,7 +109,7 @@ static int avtab_insert(struct avtab *h,
 	struct avtab_node *prev, *cur, *newnode;
 	u16 specified = key->specified & ~(AVTAB_ENABLED|AVTAB_ENABLED_OLD);
 
-	if (!h)
+	if (!h || !h->nslot)
 		return -EINVAL;
 
 	hvalue = avtab_hash(key, h->mask);
@@ -154,7 +154,7 @@ avtab_insert_nonunique(struct avtab *h,
 	struct avtab_node *prev, *cur;
 	u16 specified = key->specified & ~(AVTAB_ENABLED|AVTAB_ENABLED_OLD);
 
-	if (!h)
+	if (!h || !h->nslot)
 		return NULL;
 	hvalue = avtab_hash(key, h->mask);
 	for (prev = NULL, cur = h->htable[hvalue];
@@ -184,7 +184,7 @@ struct avtab_datum *avtab_search(struct
 	struct avtab_node *cur;
 	u16 specified = key->specified & ~(AVTAB_ENABLED|AVTAB_ENABLED_OLD);
 
-	if (!h)
+	if (!h || !h->nslot)
 		return NULL;
 
 	hvalue = avtab_hash(key, h->mask);
@@ -220,7 +220,7 @@ avtab_search_node(struct avtab *h, struc
 	struct avtab_node *cur;
 	u16 specified = key->specified & ~(AVTAB_ENABLED|AVTAB_ENABLED_OLD);
 
-	if (!h)
+	if (!h || !h->nslot)
 		return NULL;
 
 	hvalue = avtab_hash(key, h->mask);
@@ -295,6 +295,7 @@ void avtab_destroy(struct avtab *h)
 	}
 	kvfree(h->htable);
 	h->htable = NULL;
+	h->nel = 0;
 	h->nslot = 0;
 	h->mask = 0;
 }
@@ -303,14 +304,15 @@ void avtab_init(struct avtab *h)
 {
 	h->htable = NULL;
 	h->nel = 0;
+	h->nslot = 0;
+	h->mask = 0;
 }
 
 int avtab_alloc(struct avtab *h, u32 nrules)
 {
-	u32 mask = 0;
 	u32 shift = 0;
 	u32 work = nrules;
-	u32 nslot = 0;
+	u32 nslot;
 
 	if (nrules == 0)
 		goto avtab_alloc_out;
@@ -324,16 +326,15 @@ int avtab_alloc(struct avtab *h, u32 nru
 	nslot = 1 << shift;
 	if (nslot > MAX_AVTAB_HASH_BUCKETS)
 		nslot = MAX_AVTAB_HASH_BUCKETS;
-	mask = nslot - 1;
 
 	h->htable = kvcalloc(nslot, sizeof(void *), GFP_KERNEL);
 	if (!h->htable)
 		return -ENOMEM;
 
- avtab_alloc_out:
-	h->nel = 0;
 	h->nslot = nslot;
-	h->mask = mask;
+	h->mask = nslot - 1;
+
+avtab_alloc_out:
 	pr_debug("SELinux: %d avtab hash slots, %d rules.\n",
 	       h->nslot, nrules);
 	return 0;



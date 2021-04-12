Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F51E35BF6B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238802AbhDLJGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239060AbhDLJCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 885F86127C;
        Mon, 12 Apr 2021 09:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218063;
        bh=x6E4TYrgcigrbiUwGlIFjCzFJXizusV0EoPNiDuunRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iV/mj5pWzeBmIg68qWHROBci+PkXRHJ2Y+TWQnUfgNKtKUcGMduIqPw/kmxregpRE
         pFeL/CUCad1mPIXWfv0Cm+z7s/0QO3oAjoACegDVxeqd7iS61mYkmMqNjpcRFgiZ32
         CUg1XO6ie5CfSHMuguvo0W55ALx68QjNzFGvsv98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.11 012/210] selinux: fix cond_list corruption when changing booleans
Date:   Mon, 12 Apr 2021 10:38:37 +0200
Message-Id: <20210412084016.419635282@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit d8f5f0ea5b86300390b026b6c6e7836b7150814a upstream.

Currently, duplicate_policydb_cond_list() first copies the whole
conditional avtab and then tries to link to the correct entries in
cond_dup_av_list() using avtab_search(). However, since the conditional
avtab may contain multiple entries with the same key, this approach
often fails to find the right entry, potentially leading to wrong rules
being activated/deactivated when booleans are changed.

To fix this, instead start with an empty conditional avtab and add the
individual entries one-by-one while building the new av_lists. This
approach leads to the correct result, since each entry is present in the
av_lists exactly once.

The issue can be reproduced with Fedora policy as follows:

    # sesearch -s ftpd_t -t public_content_rw_t -c dir -p create -A
    allow ftpd_t non_security_file_type:dir { add_name create getattr ioctl link lock open read remove_name rename reparent rmdir search setattr unlink watch watch_reads write }; [ ftpd_full_access ]:True
    allow ftpd_t public_content_rw_t:dir { add_name create link remove_name rename reparent rmdir setattr unlink watch watch_reads write }; [ ftpd_anon_write ]:True
    # setsebool ftpd_anon_write=off ftpd_connect_all_unreserved=off ftpd_connect_db=off ftpd_full_access=off

On fixed kernels, the sesearch output is the same after the setsebool
command:

    # sesearch -s ftpd_t -t public_content_rw_t -c dir -p create -A
    allow ftpd_t non_security_file_type:dir { add_name create getattr ioctl link lock open read remove_name rename reparent rmdir search setattr unlink watch watch_reads write }; [ ftpd_full_access ]:True
    allow ftpd_t public_content_rw_t:dir { add_name create link remove_name rename reparent rmdir setattr unlink watch watch_reads write }; [ ftpd_anon_write ]:True

While on the broken kernels, it will be different:

    # sesearch -s ftpd_t -t public_content_rw_t -c dir -p create -A
    allow ftpd_t non_security_file_type:dir { add_name create getattr ioctl link lock open read remove_name rename reparent rmdir search setattr unlink watch watch_reads write }; [ ftpd_full_access ]:True
    allow ftpd_t non_security_file_type:dir { add_name create getattr ioctl link lock open read remove_name rename reparent rmdir search setattr unlink watch watch_reads write }; [ ftpd_full_access ]:True
    allow ftpd_t non_security_file_type:dir { add_name create getattr ioctl link lock open read remove_name rename reparent rmdir search setattr unlink watch watch_reads write }; [ ftpd_full_access ]:True

While there, also simplify the computation of nslots. This changes the
nslots values for nrules 2 or 3 to just two slots instead of 4, which
makes the sequence more consistent.

Cc: stable@vger.kernel.org
Fixes: c7c556f1e81b ("selinux: refactor changing booleans")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/avtab.c       |   86 +++++++++++---------------------------
 security/selinux/ss/avtab.h       |    2 
 security/selinux/ss/conditional.c |   12 ++---
 3 files changed, 32 insertions(+), 68 deletions(-)

--- a/security/selinux/ss/avtab.c
+++ b/security/selinux/ss/avtab.c
@@ -308,24 +308,10 @@ void avtab_init(struct avtab *h)
 	h->mask = 0;
 }
 
-int avtab_alloc(struct avtab *h, u32 nrules)
+static int avtab_alloc_common(struct avtab *h, u32 nslot)
 {
-	u32 shift = 0;
-	u32 work = nrules;
-	u32 nslot;
-
-	if (nrules == 0)
-		goto avtab_alloc_out;
-
-	while (work) {
-		work  = work >> 1;
-		shift++;
-	}
-	if (shift > 2)
-		shift = shift - 2;
-	nslot = 1 << shift;
-	if (nslot > MAX_AVTAB_HASH_BUCKETS)
-		nslot = MAX_AVTAB_HASH_BUCKETS;
+	if (!nslot)
+		return 0;
 
 	h->htable = kvcalloc(nslot, sizeof(void *), GFP_KERNEL);
 	if (!h->htable)
@@ -333,59 +319,37 @@ int avtab_alloc(struct avtab *h, u32 nru
 
 	h->nslot = nslot;
 	h->mask = nslot - 1;
-
-avtab_alloc_out:
-	pr_debug("SELinux: %d avtab hash slots, %d rules.\n",
-	       h->nslot, nrules);
 	return 0;
 }
 
-int avtab_duplicate(struct avtab *new, struct avtab *orig)
+int avtab_alloc(struct avtab *h, u32 nrules)
 {
-	int i;
-	struct avtab_node *node, *tmp, *tail;
-
-	memset(new, 0, sizeof(*new));
+	int rc;
+	u32 nslot = 0;
 
-	new->htable = kvcalloc(orig->nslot, sizeof(void *), GFP_KERNEL);
-	if (!new->htable)
-		return -ENOMEM;
-	new->nslot = orig->nslot;
-	new->mask = orig->mask;
-
-	for (i = 0; i < orig->nslot; i++) {
-		tail = NULL;
-		for (node = orig->htable[i]; node; node = node->next) {
-			tmp = kmem_cache_zalloc(avtab_node_cachep, GFP_KERNEL);
-			if (!tmp)
-				goto error;
-			tmp->key = node->key;
-			if (tmp->key.specified & AVTAB_XPERMS) {
-				tmp->datum.u.xperms =
-					kmem_cache_zalloc(avtab_xperms_cachep,
-							GFP_KERNEL);
-				if (!tmp->datum.u.xperms) {
-					kmem_cache_free(avtab_node_cachep, tmp);
-					goto error;
-				}
-				tmp->datum.u.xperms = node->datum.u.xperms;
-			} else
-				tmp->datum.u.data = node->datum.u.data;
-
-			if (tail)
-				tail->next = tmp;
-			else
-				new->htable[i] = tmp;
-
-			tail = tmp;
-			new->nel++;
+	if (nrules != 0) {
+		u32 shift = 1;
+		u32 work = nrules >> 3;
+		while (work) {
+			work >>= 1;
+			shift++;
 		}
+		nslot = 1 << shift;
+		if (nslot > MAX_AVTAB_HASH_BUCKETS)
+			nslot = MAX_AVTAB_HASH_BUCKETS;
+
+		rc = avtab_alloc_common(h, nslot);
+		if (rc)
+			return rc;
 	}
 
+	pr_debug("SELinux: %d avtab hash slots, %d rules.\n", nslot, nrules);
 	return 0;
-error:
-	avtab_destroy(new);
-	return -ENOMEM;
+}
+
+int avtab_alloc_dup(struct avtab *new, const struct avtab *orig)
+{
+	return avtab_alloc_common(new, orig->nslot);
 }
 
 void avtab_hash_eval(struct avtab *h, char *tag)
--- a/security/selinux/ss/avtab.h
+++ b/security/selinux/ss/avtab.h
@@ -89,7 +89,7 @@ struct avtab {
 
 void avtab_init(struct avtab *h);
 int avtab_alloc(struct avtab *, u32);
-int avtab_duplicate(struct avtab *new, struct avtab *orig);
+int avtab_alloc_dup(struct avtab *new, const struct avtab *orig);
 struct avtab_datum *avtab_search(struct avtab *h, struct avtab_key *k);
 void avtab_destroy(struct avtab *h);
 void avtab_hash_eval(struct avtab *h, char *tag);
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -605,7 +605,6 @@ static int cond_dup_av_list(struct cond_
 			struct cond_av_list *orig,
 			struct avtab *avtab)
 {
-	struct avtab_node *avnode;
 	u32 i;
 
 	memset(new, 0, sizeof(*new));
@@ -615,10 +614,11 @@ static int cond_dup_av_list(struct cond_
 		return -ENOMEM;
 
 	for (i = 0; i < orig->len; i++) {
-		avnode = avtab_search_node(avtab, &orig->nodes[i]->key);
-		if (WARN_ON(!avnode))
-			return -EINVAL;
-		new->nodes[i] = avnode;
+		new->nodes[i] = avtab_insert_nonunique(avtab,
+						       &orig->nodes[i]->key,
+						       &orig->nodes[i]->datum);
+		if (!new->nodes[i])
+			return -ENOMEM;
 		new->len++;
 	}
 
@@ -630,7 +630,7 @@ static int duplicate_policydb_cond_list(
 {
 	int rc, i, j;
 
-	rc = avtab_duplicate(&newp->te_cond_avtab, &origp->te_cond_avtab);
+	rc = avtab_alloc_dup(&newp->te_cond_avtab, &origp->te_cond_avtab);
 	if (rc)
 		return rc;
 



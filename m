Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD9823595
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391195AbfETMgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391190AbfETMgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:36:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 465CA20815;
        Mon, 20 May 2019 12:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355759;
        bh=wbaBD7Oip04UaAK0STTWIKYnZmAitCvYALj8ZhSDriY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQ1N9jPRcHYwQ8QWQIV4eY5WZKVBi2EumJ6qLFwy69QZpq9zArrhWNOVrVowR8Kr5
         j9tCo2v7Ea3QHPNUBm8iPjIELhdquqNz9l8dT7YI2IC6cyviAyZWz7EsGr6SrcLCF/
         JGloRZ9aiGBvIqrh9+9o5QxoKArIhJ8kmc+A+Pr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.1 114/128] jbd2: fix potential double free
Date:   Mon, 20 May 2019 14:15:01 +0200
Message-Id: <20190520115256.562611416@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@gmail.com>

commit 0d52154bb0a700abb459a2cbce0a30fc2549b67e upstream.

When failing from creating cache jbd2_inode_cache, we will destroy the
previously created cache jbd2_handle_cache twice.  This patch fixes
this by moving each cache initialization/destruction to its own
separate, individual function.

Signed-off-by: Chengguang Xu <cgxu519@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/journal.c     |   49 +++++++++++++++++++++++++++++++------------------
 fs/jbd2/revoke.c      |   32 ++++++++++++++++++++------------
 fs/jbd2/transaction.c |    8 +++++---
 include/linux/jbd2.h  |    8 +++++---
 4 files changed, 61 insertions(+), 36 deletions(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2375,22 +2375,19 @@ static struct kmem_cache *jbd2_journal_h
 static atomic_t nr_journal_heads = ATOMIC_INIT(0);
 #endif
 
-static int jbd2_journal_init_journal_head_cache(void)
+static int __init jbd2_journal_init_journal_head_cache(void)
 {
-	int retval;
-
-	J_ASSERT(jbd2_journal_head_cache == NULL);
+	J_ASSERT(!jbd2_journal_head_cache);
 	jbd2_journal_head_cache = kmem_cache_create("jbd2_journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				SLAB_TEMPORARY | SLAB_TYPESAFE_BY_RCU,
 				NULL);		/* ctor */
-	retval = 0;
 	if (!jbd2_journal_head_cache) {
-		retval = -ENOMEM;
 		printk(KERN_EMERG "JBD2: no memory for journal_head cache\n");
+		return -ENOMEM;
 	}
-	return retval;
+	return 0;
 }
 
 static void jbd2_journal_destroy_journal_head_cache(void)
@@ -2636,28 +2633,38 @@ static void __exit jbd2_remove_jbd_stats
 
 struct kmem_cache *jbd2_handle_cache, *jbd2_inode_cache;
 
+static int __init jbd2_journal_init_inode_cache(void)
+{
+	J_ASSERT(!jbd2_inode_cache);
+	jbd2_inode_cache = KMEM_CACHE(jbd2_inode, 0);
+	if (!jbd2_inode_cache) {
+		pr_emerg("JBD2: failed to create inode cache\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 static int __init jbd2_journal_init_handle_cache(void)
 {
+	J_ASSERT(!jbd2_handle_cache);
 	jbd2_handle_cache = KMEM_CACHE(jbd2_journal_handle, SLAB_TEMPORARY);
-	if (jbd2_handle_cache == NULL) {
+	if (!jbd2_handle_cache) {
 		printk(KERN_EMERG "JBD2: failed to create handle cache\n");
 		return -ENOMEM;
 	}
-	jbd2_inode_cache = KMEM_CACHE(jbd2_inode, 0);
-	if (jbd2_inode_cache == NULL) {
-		printk(KERN_EMERG "JBD2: failed to create inode cache\n");
-		kmem_cache_destroy(jbd2_handle_cache);
-		return -ENOMEM;
-	}
 	return 0;
 }
 
+static void jbd2_journal_destroy_inode_cache(void)
+{
+	kmem_cache_destroy(jbd2_inode_cache);
+	jbd2_inode_cache = NULL;
+}
+
 static void jbd2_journal_destroy_handle_cache(void)
 {
 	kmem_cache_destroy(jbd2_handle_cache);
 	jbd2_handle_cache = NULL;
-	kmem_cache_destroy(jbd2_inode_cache);
-	jbd2_inode_cache = NULL;
 }
 
 /*
@@ -2668,21 +2675,27 @@ static int __init journal_init_caches(vo
 {
 	int ret;
 
-	ret = jbd2_journal_init_revoke_caches();
+	ret = jbd2_journal_init_revoke_record_cache();
+	if (ret == 0)
+		ret = jbd2_journal_init_revoke_table_cache();
 	if (ret == 0)
 		ret = jbd2_journal_init_journal_head_cache();
 	if (ret == 0)
 		ret = jbd2_journal_init_handle_cache();
 	if (ret == 0)
+		ret = jbd2_journal_init_inode_cache();
+	if (ret == 0)
 		ret = jbd2_journal_init_transaction_cache();
 	return ret;
 }
 
 static void jbd2_journal_destroy_caches(void)
 {
-	jbd2_journal_destroy_revoke_caches();
+	jbd2_journal_destroy_revoke_record_cache();
+	jbd2_journal_destroy_revoke_table_cache();
 	jbd2_journal_destroy_journal_head_cache();
 	jbd2_journal_destroy_handle_cache();
+	jbd2_journal_destroy_inode_cache();
 	jbd2_journal_destroy_transaction_cache();
 	jbd2_journal_destroy_slabs();
 }
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -178,33 +178,41 @@ static struct jbd2_revoke_record_s *find
 	return NULL;
 }
 
-void jbd2_journal_destroy_revoke_caches(void)
+void jbd2_journal_destroy_revoke_record_cache(void)
 {
 	kmem_cache_destroy(jbd2_revoke_record_cache);
 	jbd2_revoke_record_cache = NULL;
+}
+
+void jbd2_journal_destroy_revoke_table_cache(void)
+{
 	kmem_cache_destroy(jbd2_revoke_table_cache);
 	jbd2_revoke_table_cache = NULL;
 }
 
-int __init jbd2_journal_init_revoke_caches(void)
+int __init jbd2_journal_init_revoke_record_cache(void)
 {
 	J_ASSERT(!jbd2_revoke_record_cache);
-	J_ASSERT(!jbd2_revoke_table_cache);
-
 	jbd2_revoke_record_cache = KMEM_CACHE(jbd2_revoke_record_s,
 					SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY);
-	if (!jbd2_revoke_record_cache)
-		goto record_cache_failure;
 
+	if (!jbd2_revoke_record_cache) {
+		pr_emerg("JBD2: failed to create revoke_record cache\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+int __init jbd2_journal_init_revoke_table_cache(void)
+{
+	J_ASSERT(!jbd2_revoke_table_cache);
 	jbd2_revoke_table_cache = KMEM_CACHE(jbd2_revoke_table_s,
 					     SLAB_TEMPORARY);
-	if (!jbd2_revoke_table_cache)
-		goto table_cache_failure;
-	return 0;
-table_cache_failure:
-	jbd2_journal_destroy_revoke_caches();
-record_cache_failure:
+	if (!jbd2_revoke_table_cache) {
+		pr_emerg("JBD2: failed to create revoke_table cache\n");
 		return -ENOMEM;
+	}
+	return 0;
 }
 
 static struct jbd2_revoke_table_s *jbd2_journal_init_revoke_table(int hash_size)
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -42,9 +42,11 @@ int __init jbd2_journal_init_transaction
 					0,
 					SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					NULL);
-	if (transaction_cache)
-		return 0;
-	return -ENOMEM;
+	if (!transaction_cache) {
+		pr_emerg("JBD2: failed to create transaction cache\n");
+		return -ENOMEM;
+	}
+	return 0;
 }
 
 void jbd2_journal_destroy_transaction_cache(void)
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1318,7 +1318,7 @@ extern void		__wait_on_journal (journal_
 
 /* Transaction cache support */
 extern void jbd2_journal_destroy_transaction_cache(void);
-extern int  jbd2_journal_init_transaction_cache(void);
+extern int __init jbd2_journal_init_transaction_cache(void);
 extern void jbd2_journal_free_transaction(transaction_t *);
 
 /*
@@ -1446,8 +1446,10 @@ static inline void jbd2_free_inode(struc
 /* Primary revoke support */
 #define JOURNAL_REVOKE_DEFAULT_HASH 256
 extern int	   jbd2_journal_init_revoke(journal_t *, int);
-extern void	   jbd2_journal_destroy_revoke_caches(void);
-extern int	   jbd2_journal_init_revoke_caches(void);
+extern void	   jbd2_journal_destroy_revoke_record_cache(void);
+extern void	   jbd2_journal_destroy_revoke_table_cache(void);
+extern int __init jbd2_journal_init_revoke_record_cache(void);
+extern int __init jbd2_journal_init_revoke_table_cache(void);
 
 extern void	   jbd2_journal_destroy_revoke(journal_t *);
 extern int	   jbd2_journal_revoke (handle_t *, unsigned long long, struct buffer_head *);



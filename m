Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B25230CB
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 11:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbfETJ4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 05:56:20 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56839 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfETJ4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 05:56:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id ACB5322E6B;
        Mon, 20 May 2019 05:56:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 20 May 2019 05:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1Em/rz
        A2c5wQmyFP7MtlN9O3iCy/qBhd9XVVtgumAeY=; b=z2D6dvJYpi8/ptgQD/7JF0
        6mfcC7FlCshQDVmXGYaAmZF6Owki5/+SVi/LYC2lenbRGqrGG7POxTV6mnG0t2pm
        w6I7IxD3xKyLklmpMO1SQqFvwdKfHDCat+a4o/mTnTbxC727WgP6T6G8AJwYVYjd
        MZIxKFS33XiAalnPQxeq50dRdCB8cskQ62p5VdXdpRPHV7yilyPffhB2edahjKBi
        q8rWjZd5FdWwp0VlSZmMMapYWTe0RkJQUxsk/rh7gAcX/SPPXSnSmdo+V/I/X9Tx
        6N2eM9hsOGYCigLL7LFuWFg7gI0yvhN/tcGt795WDoEWesORdp4XvlPPF5fidyHg
        ==
X-ME-Sender: <xms:w3niXAQGx6bHJMGjKG2aJ_fapmMtBRo4es4wMrLkf9uBz390HULFbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:w3niXP0thgJnZFSjgJlBFLG0X-vDZNMAQUCSZ8sxkHy5c6P1zV_dyw>
    <xmx:w3niXH4qGt8aZ0OZpmoOVPu9YpiZf6E6D3ewjAuoUVS9EnDl2kmlhA>
    <xmx:w3niXOs2IvbCwWJPqT5ND1NtXDf8utgQHw4XnpvWZvYqsfsMxUcn8Q>
    <xmx:w3niXOGKTyugjJ5Kr920eHfDWdDzYTqbRabPfW8laFEtVEkrSK_4nw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 222828005B;
        Mon, 20 May 2019 05:56:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] jbd2: fix potential double free" failed to apply to 4.9-stable tree
To:     cgxu519@gmail.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 11:56:16 +0200
Message-ID: <15583461764164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0d52154bb0a700abb459a2cbce0a30fc2549b67e Mon Sep 17 00:00:00 2001
From: Chengguang Xu <cgxu519@gmail.com>
Date: Fri, 10 May 2019 21:15:47 -0400
Subject: [PATCH] jbd2: fix potential double free

When failing from creating cache jbd2_inode_cache, we will destroy the
previously created cache jbd2_handle_cache twice.  This patch fixes
this by moving each cache initialization/destruction to its own
separate, individual function.

Signed-off-by: Chengguang Xu <cgxu519@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 37e16d969925..43df0c943229 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2375,22 +2375,19 @@ static struct kmem_cache *jbd2_journal_head_cache;
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
@@ -2636,28 +2633,38 @@ static void __exit jbd2_remove_jbd_stats_proc_entry(void)
 
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
@@ -2668,11 +2675,15 @@ static int __init journal_init_caches(void)
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
+	if (ret == 0)
+		ret = jbd2_journal_init_inode_cache();
 	if (ret == 0)
 		ret = jbd2_journal_init_transaction_cache();
 	return ret;
@@ -2680,9 +2691,11 @@ static int __init journal_init_caches(void)
 
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
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index a1143e57a718..69b9bc329964 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -178,33 +178,41 @@ static struct jbd2_revoke_record_s *find_revoke_record(journal_t *journal,
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
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index f940d31c2adc..8ca4fddc705f 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -42,9 +42,11 @@ int __init jbd2_journal_init_transaction_cache(void)
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
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 0f919d5fe84f..2cf6e04b08fc 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1318,7 +1318,7 @@ extern void		__wait_on_journal (journal_t *);
 
 /* Transaction cache support */
 extern void jbd2_journal_destroy_transaction_cache(void);
-extern int  jbd2_journal_init_transaction_cache(void);
+extern int __init jbd2_journal_init_transaction_cache(void);
 extern void jbd2_journal_free_transaction(transaction_t *);
 
 /*
@@ -1446,8 +1446,10 @@ static inline void jbd2_free_inode(struct jbd2_inode *jinode)
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


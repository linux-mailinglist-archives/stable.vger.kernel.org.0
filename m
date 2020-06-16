Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83DE1FB8EE
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgFPP77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732482AbgFPPxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:53:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C25D208D5;
        Tue, 16 Jun 2020 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322791;
        bh=hGX29h/XEmSvwgUH6YsyVe/7+5yKRFxO/MI5vqy7xRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrnJ/+vMR3pG7u50rvNA+Ci3PLBYaUCL9EZHvJtzQlz8ok+93rUY/6i45dA4dCCsK
         buGgPjo85EY/jbffobwlyveQtGH7zcrh0He8wc7JS4bLja3GnQ6XLCJ8vJ6z+1stGR
         gTsZ4lkLbJ0IizCkkVhcW+bwtgWrqL18ImSA198w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 106/161] dccp: Fix possible memleak in dccp_init and dccp_fini
Date:   Tue, 16 Jun 2020 17:34:56 +0200
Message-Id: <20200616153111.408318496@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit c96b6acc8f89a4a7f6258dfe1d077654c11415be ]

There are some memory leaks in dccp_init() and dccp_fini().

In dccp_fini() and the error handling path in dccp_init(), free lhash2
is missing. Add inet_hashinfo2_free_mod() to do it.

If inet_hashinfo2_init_mod() failed in dccp_init(),
percpu_counter_destroy() should be called to destroy dccp_orphan_count.
It need to goto out_free_percpu when inet_hashinfo2_init_mod() failed.

Fixes: c92c81df93df ("net: dccp: fix kernel crash on module load")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_hashtables.h |    6 ++++++
 net/dccp/proto.c              |    7 +++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -185,6 +185,12 @@ static inline spinlock_t *inet_ehash_loc
 
 int inet_ehash_locks_alloc(struct inet_hashinfo *hashinfo);
 
+static inline void inet_hashinfo2_free_mod(struct inet_hashinfo *h)
+{
+	kfree(h->lhash2);
+	h->lhash2 = NULL;
+}
+
 static inline void inet_ehash_locks_free(struct inet_hashinfo *hashinfo)
 {
 	kvfree(hashinfo->ehash_locks);
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1139,14 +1139,14 @@ static int __init dccp_init(void)
 	inet_hashinfo_init(&dccp_hashinfo);
 	rc = inet_hashinfo2_init_mod(&dccp_hashinfo);
 	if (rc)
-		goto out_fail;
+		goto out_free_percpu;
 	rc = -ENOBUFS;
 	dccp_hashinfo.bind_bucket_cachep =
 		kmem_cache_create("dccp_bind_bucket",
 				  sizeof(struct inet_bind_bucket), 0,
 				  SLAB_HWCACHE_ALIGN, NULL);
 	if (!dccp_hashinfo.bind_bucket_cachep)
-		goto out_free_percpu;
+		goto out_free_hashinfo2;
 
 	/*
 	 * Size and allocate the main established and bind bucket
@@ -1242,6 +1242,8 @@ out_free_dccp_ehash:
 	free_pages((unsigned long)dccp_hashinfo.ehash, ehash_order);
 out_free_bind_bucket_cachep:
 	kmem_cache_destroy(dccp_hashinfo.bind_bucket_cachep);
+out_free_hashinfo2:
+	inet_hashinfo2_free_mod(&dccp_hashinfo);
 out_free_percpu:
 	percpu_counter_destroy(&dccp_orphan_count);
 out_fail:
@@ -1265,6 +1267,7 @@ static void __exit dccp_fini(void)
 	kmem_cache_destroy(dccp_hashinfo.bind_bucket_cachep);
 	dccp_ackvec_exit();
 	dccp_sysctl_exit();
+	inet_hashinfo2_free_mod(&dccp_hashinfo);
 	percpu_counter_destroy(&dccp_orphan_count);
 }
 



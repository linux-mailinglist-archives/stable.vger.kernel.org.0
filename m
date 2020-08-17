Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE630246B89
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387976AbgHQP6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730791AbgHQP5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:57:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EF9B21744;
        Mon, 17 Aug 2020 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679862;
        bh=fj7OTwg1Q9qwuTeOWnL//T7iD24j2iceMgT8eXMLeE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=harGuBlWLqTd9pcxARxsNcWeF81xBqpPBG7eCF2pL1SuOiObdHHjT42VGkTjYSXeK
         hv+rFp7TiVrcpd/KkUdAevTIHtzaAktKpyH8HJf1XAcPPHmaBBFh4gPshKXq2W+t5V
         qKyCaVuux8N6h3f2/1LhsdOuS9v3q2kAWCyS+EJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 319/393] net: Fix potential memory leak in proto_register()
Date:   Mon, 17 Aug 2020 17:16:09 +0200
Message-Id: <20200817143835.078988445@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 0f5907af39137f8183ed536aaa00f322d7365130 ]

If we failed to assign proto idx, we free the twsk_slab_name but forget to
free the twsk_slab. Add a helper function tw_prot_cleanup() to free these
together and also use this helper function in proto_unregister().

Fixes: b45ce32135d1 ("sock: fix potential memory leak in proto_register()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3354,6 +3354,16 @@ static void sock_inuse_add(struct net *n
 }
 #endif
 
+static void tw_prot_cleanup(struct timewait_sock_ops *twsk_prot)
+{
+	if (!twsk_prot)
+		return;
+	kfree(twsk_prot->twsk_slab_name);
+	twsk_prot->twsk_slab_name = NULL;
+	kmem_cache_destroy(twsk_prot->twsk_slab);
+	twsk_prot->twsk_slab = NULL;
+}
+
 static void req_prot_cleanup(struct request_sock_ops *rsk_prot)
 {
 	if (!rsk_prot)
@@ -3424,7 +3434,7 @@ int proto_register(struct proto *prot, i
 						  prot->slab_flags,
 						  NULL);
 			if (prot->twsk_prot->twsk_slab == NULL)
-				goto out_free_timewait_sock_slab_name;
+				goto out_free_timewait_sock_slab;
 		}
 	}
 
@@ -3432,15 +3442,15 @@ int proto_register(struct proto *prot, i
 	ret = assign_proto_idx(prot);
 	if (ret) {
 		mutex_unlock(&proto_list_mutex);
-		goto out_free_timewait_sock_slab_name;
+		goto out_free_timewait_sock_slab;
 	}
 	list_add(&prot->node, &proto_list);
 	mutex_unlock(&proto_list_mutex);
 	return ret;
 
-out_free_timewait_sock_slab_name:
+out_free_timewait_sock_slab:
 	if (alloc_slab && prot->twsk_prot)
-		kfree(prot->twsk_prot->twsk_slab_name);
+		tw_prot_cleanup(prot->twsk_prot);
 out_free_request_sock_slab:
 	if (alloc_slab) {
 		req_prot_cleanup(prot->rsk_prot);
@@ -3464,12 +3474,7 @@ void proto_unregister(struct proto *prot
 	prot->slab = NULL;
 
 	req_prot_cleanup(prot->rsk_prot);
-
-	if (prot->twsk_prot != NULL && prot->twsk_prot->twsk_slab != NULL) {
-		kmem_cache_destroy(prot->twsk_prot->twsk_slab);
-		kfree(prot->twsk_prot->twsk_slab_name);
-		prot->twsk_prot->twsk_slab = NULL;
-	}
+	tw_prot_cleanup(prot->twsk_prot);
 }
 EXPORT_SYMBOL(proto_unregister);
 



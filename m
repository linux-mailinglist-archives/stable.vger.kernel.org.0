Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E912247521
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404191AbgHQTT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387404AbgHQPhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:37:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BEA622DD6;
        Mon, 17 Aug 2020 15:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678636;
        bh=bYZSsDbdKIVHwZyGePACRao7ZG9/BLMU1o3jf/HNoGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AETwqkhBo7CGpTDXZl89UgX3LXXXlsUu+ZXnUoAz+rdOoFuB67ewn6xleqajkPFhY
         CeSyNBeUNTKx/m7X17dryjbSw0FZfZZh4LpxkhB/ZNU/b9vmWacE+BltOIuHvJxh2K
         ihRhaRGHtZHl0v+P+NbjyEyMK+6qw1TwY4GbkV2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 385/464] net: Fix potential memory leak in proto_register()
Date:   Mon, 17 Aug 2020 17:15:38 +0200
Message-Id: <20200817143852.221924572@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
@@ -3443,6 +3443,16 @@ static void sock_inuse_add(struct net *n
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
@@ -3513,7 +3523,7 @@ int proto_register(struct proto *prot, i
 						  prot->slab_flags,
 						  NULL);
 			if (prot->twsk_prot->twsk_slab == NULL)
-				goto out_free_timewait_sock_slab_name;
+				goto out_free_timewait_sock_slab;
 		}
 	}
 
@@ -3521,15 +3531,15 @@ int proto_register(struct proto *prot, i
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
@@ -3553,12 +3563,7 @@ void proto_unregister(struct proto *prot
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
 



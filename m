Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35ED2A1652
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgJaLoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbgJaLoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:44:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3540E205F4;
        Sat, 31 Oct 2020 11:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144660;
        bh=Ze60y2mI3LTiXlkco5PSOa3oUKSgq0I/299naj4iKYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jiqvVL9vfD4Hi4ATgG2lg/VDvqNNnV6kINP1MfqugHVVws3ROGH2R4R+TklY19YB
         jFKooZ7vAchweiRjm/mVx66L3irTFeAsMecxkiKsiWRj4UCAwRpnjM8nP6Jv2/4ynP
         BVALCgJYYUv8SiifwowvhmuWDZJP3zu2NTvdUMXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 33/74] chelsio/chtls: fix memory leaks in CPL handlers
Date:   Sat, 31 Oct 2020 12:36:15 +0100
Message-Id: <20201031113501.630753224@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit 6daa1da4e262b0cd52ef0acc1989ff22b5540264 ]

CPL handler functions chtls_pass_open_rpl() and
chtls_close_listsrv_rpl() should return CPL_RET_BUF_DONE
so that caller function will do skb free to avoid leak.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Link: https://lore.kernel.org/r/20201025194228.31271-1-vinay.yadav@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -772,14 +772,13 @@ static int chtls_pass_open_rpl(struct ch
 	if (rpl->status != CPL_ERR_NONE) {
 		pr_info("Unexpected PASS_OPEN_RPL status %u for STID %u\n",
 			rpl->status, stid);
-		return CPL_RET_BUF_DONE;
+	} else {
+		cxgb4_free_stid(cdev->tids, stid, listen_ctx->lsk->sk_family);
+		sock_put(listen_ctx->lsk);
+		kfree(listen_ctx);
+		module_put(THIS_MODULE);
 	}
-	cxgb4_free_stid(cdev->tids, stid, listen_ctx->lsk->sk_family);
-	sock_put(listen_ctx->lsk);
-	kfree(listen_ctx);
-	module_put(THIS_MODULE);
-
-	return 0;
+	return CPL_RET_BUF_DONE;
 }
 
 static int chtls_close_listsrv_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
@@ -796,15 +795,13 @@ static int chtls_close_listsrv_rpl(struc
 	if (rpl->status != CPL_ERR_NONE) {
 		pr_info("Unexpected CLOSE_LISTSRV_RPL status %u for STID %u\n",
 			rpl->status, stid);
-		return CPL_RET_BUF_DONE;
+	} else {
+		cxgb4_free_stid(cdev->tids, stid, listen_ctx->lsk->sk_family);
+		sock_put(listen_ctx->lsk);
+		kfree(listen_ctx);
+		module_put(THIS_MODULE);
 	}
-
-	cxgb4_free_stid(cdev->tids, stid, listen_ctx->lsk->sk_family);
-	sock_put(listen_ctx->lsk);
-	kfree(listen_ctx);
-	module_put(THIS_MODULE);
-
-	return 0;
+	return CPL_RET_BUF_DONE;
 }
 
 static void chtls_purge_wr_queue(struct sock *sk)



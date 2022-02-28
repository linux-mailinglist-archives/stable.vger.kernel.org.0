Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3DC4C73FB
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbiB1Rjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbiB1Riw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:38:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE868F609;
        Mon, 28 Feb 2022 09:34:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27B29B815BE;
        Mon, 28 Feb 2022 17:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB1AC340F0;
        Mon, 28 Feb 2022 17:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069638;
        bh=2KB33yasltd30ZmQPOUidFoxcAPmgj0nafDIvmwvRMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6ZGzQmHh6EOwt3f71bHBTyrSIrljxmuyOIzbz0PDSxaXf710gPHZNkTCUzMWWhVM
         vt6TR+g2mDsqk0EMJsaML5eELmLkoNOxIWewSi3GpQgdFVZnKS+Tbpc41yLqVYwkn/
         PgA+21v6bBKHV3Zk3FoKoVO/ahBxdGFNvZ566BRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 38/80] netfilter: nf_tables: fix memory leak during stateful obj update
Date:   Mon, 28 Feb 2022 18:24:19 +0100
Message-Id: <20220228172316.104997082@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit dad3bdeef45f81a6e90204bcc85360bb76eccec7 upstream.

stateful objects can be updated from the control plane.
The transaction logic allocates a temporary object for this purpose.

The ->init function was called for this object, so plain kfree() leaks
resources. We must call ->destroy function of the object.

nft_obj_destroy does this, but it also decrements the module refcount,
but the update path doesn't increment it.

To avoid special-casing the update object release, do module_get for
the update case too and release it via nft_obj_destroy().

Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
Cc: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5924,12 +5924,15 @@ static int nf_tables_updobj(const struct
 {
 	struct nft_object *newobj;
 	struct nft_trans *trans;
-	int err;
+	int err = -ENOMEM;
+
+	if (!try_module_get(type->owner))
+		return -ENOENT;
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
 				sizeof(struct nft_trans_obj));
 	if (!trans)
-		return -ENOMEM;
+		goto err_trans;
 
 	newobj = nft_obj_init(ctx, type, attr);
 	if (IS_ERR(newobj)) {
@@ -5946,6 +5949,8 @@ static int nf_tables_updobj(const struct
 
 err_free_trans:
 	kfree(trans);
+err_trans:
+	module_put(type->owner);
 	return err;
 }
 
@@ -7555,7 +7560,7 @@ static void nft_obj_commit_update(struct
 	if (obj->ops->update)
 		obj->ops->update(obj, newobj);
 
-	kfree(newobj);
+	nft_obj_destroy(&trans->ctx, newobj);
 }
 
 static void nft_commit_release(struct nft_trans *trans)
@@ -8202,7 +8207,7 @@ static int __nf_tables_abort(struct net
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
-				kfree(nft_trans_obj_newobj(trans));
+				nft_obj_destroy(&trans->ctx, nft_trans_obj_newobj(trans));
 				nft_trans_destroy(trans);
 			} else {
 				trans->ctx.table->use--;



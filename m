Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4996C59DA4E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352243AbiHWKHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352729AbiHWKGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:06:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F217CB55;
        Tue, 23 Aug 2022 01:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FFCE6123D;
        Tue, 23 Aug 2022 08:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDF8C433C1;
        Tue, 23 Aug 2022 08:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244753;
        bh=VVOGpGuRObIIU3JAdx4GBxXudbBcNeXZlSAeDAsUEUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wA/8wU2a0uicnU3BFQaHTaXvbFn7m0skK9md7Wd7+Wsp+EyLLC+kjRSHUDNO9fj2B
         Rij64nZvIzDYTLJeBQqnvU+dUyjTpI44Rr7Uf/XtT+Z/byi3z/GTJ32g2r5/7xBFmf
         sTXzkoasmr4mGR1sneU3Eq+rNiA3yLhEMbClcqFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 185/229] NFSv4: Fix races in the legacy idmapper upcall
Date:   Tue, 23 Aug 2022 10:25:46 +0200
Message-Id: <20220823080100.222924440@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 51fd2eb52c0ca8275a906eed81878ef50ae94eb0 upstream.

nfs_idmap_instantiate() will cause the process that is waiting in
request_key_with_auxdata() to wake up and exit. If there is a second
process waiting for the idmap->idmap_mutex, then it may wake up and
start a new call to request_key_with_auxdata(). If the call to
idmap_pipe_downcall() from the first process has not yet finished
calling nfs_idmap_complete_pipe_upcall_locked(), then we may end up
triggering the WARN_ON_ONCE() in nfs_idmap_prepare_pipe_upcall().

The fix is to ensure that we clear idmap->idmap_upcall_data before
calling nfs_idmap_instantiate().

Fixes: e9ab41b620e4 ("NFSv4: Clean up the legacy idmapper upcall")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4idmap.c |   46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

--- a/fs/nfs/nfs4idmap.c
+++ b/fs/nfs/nfs4idmap.c
@@ -543,22 +543,20 @@ nfs_idmap_prepare_pipe_upcall(struct idm
 	return true;
 }
 
-static void
-nfs_idmap_complete_pipe_upcall_locked(struct idmap *idmap, int ret)
+static void nfs_idmap_complete_pipe_upcall(struct idmap_legacy_upcalldata *data,
+					   int ret)
 {
-	struct key *authkey = idmap->idmap_upcall_data->authkey;
-
-	kfree(idmap->idmap_upcall_data);
-	idmap->idmap_upcall_data = NULL;
-	complete_request_key(authkey, ret);
-	key_put(authkey);
+	complete_request_key(data->authkey, ret);
+	key_put(data->authkey);
+	kfree(data);
 }
 
-static void
-nfs_idmap_abort_pipe_upcall(struct idmap *idmap, int ret)
+static void nfs_idmap_abort_pipe_upcall(struct idmap *idmap,
+					struct idmap_legacy_upcalldata *data,
+					int ret)
 {
-	if (idmap->idmap_upcall_data != NULL)
-		nfs_idmap_complete_pipe_upcall_locked(idmap, ret);
+	if (cmpxchg(&idmap->idmap_upcall_data, data, NULL) == data)
+		nfs_idmap_complete_pipe_upcall(data, ret);
 }
 
 static int nfs_idmap_legacy_upcall(struct key *authkey, void *aux)
@@ -595,7 +593,7 @@ static int nfs_idmap_legacy_upcall(struc
 
 	ret = rpc_queue_upcall(idmap->idmap_pipe, msg);
 	if (ret < 0)
-		nfs_idmap_abort_pipe_upcall(idmap, ret);
+		nfs_idmap_abort_pipe_upcall(idmap, data, ret);
 
 	return ret;
 out2:
@@ -651,6 +649,7 @@ idmap_pipe_downcall(struct file *filp, c
 	struct request_key_auth *rka;
 	struct rpc_inode *rpci = RPC_I(file_inode(filp));
 	struct idmap *idmap = (struct idmap *)rpci->private;
+	struct idmap_legacy_upcalldata *data;
 	struct key *authkey;
 	struct idmap_msg im;
 	size_t namelen_in;
@@ -660,10 +659,11 @@ idmap_pipe_downcall(struct file *filp, c
 	 * will have been woken up and someone else may now have used
 	 * idmap_key_cons - so after this point we may no longer touch it.
 	 */
-	if (idmap->idmap_upcall_data == NULL)
+	data = xchg(&idmap->idmap_upcall_data, NULL);
+	if (data == NULL)
 		goto out_noupcall;
 
-	authkey = idmap->idmap_upcall_data->authkey;
+	authkey = data->authkey;
 	rka = get_request_key_auth(authkey);
 
 	if (mlen != sizeof(im)) {
@@ -685,18 +685,17 @@ idmap_pipe_downcall(struct file *filp, c
 	if (namelen_in == 0 || namelen_in == IDMAP_NAMESZ) {
 		ret = -EINVAL;
 		goto out;
-}
+	}
 
-	ret = nfs_idmap_read_and_verify_message(&im,
-			&idmap->idmap_upcall_data->idmap_msg,
-			rka->target_key, authkey);
+	ret = nfs_idmap_read_and_verify_message(&im, &data->idmap_msg,
+						rka->target_key, authkey);
 	if (ret >= 0) {
 		key_set_timeout(rka->target_key, nfs_idmap_cache_timeout);
 		ret = mlen;
 	}
 
 out:
-	nfs_idmap_complete_pipe_upcall_locked(idmap, ret);
+	nfs_idmap_complete_pipe_upcall(data, ret);
 out_noupcall:
 	return ret;
 }
@@ -710,7 +709,7 @@ idmap_pipe_destroy_msg(struct rpc_pipe_m
 	struct idmap *idmap = data->idmap;
 
 	if (msg->errno)
-		nfs_idmap_abort_pipe_upcall(idmap, msg->errno);
+		nfs_idmap_abort_pipe_upcall(idmap, data, msg->errno);
 }
 
 static void
@@ -718,8 +717,11 @@ idmap_release_pipe(struct inode *inode)
 {
 	struct rpc_inode *rpci = RPC_I(inode);
 	struct idmap *idmap = (struct idmap *)rpci->private;
+	struct idmap_legacy_upcalldata *data;
 
-	nfs_idmap_abort_pipe_upcall(idmap, -EPIPE);
+	data = xchg(&idmap->idmap_upcall_data, NULL);
+	if (data)
+		nfs_idmap_complete_pipe_upcall(data, -EPIPE);
 }
 
 int nfs_map_name_to_uid(const struct nfs_server *server, const char *name, size_t namelen, kuid_t *uid)



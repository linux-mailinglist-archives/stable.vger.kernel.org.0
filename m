Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C454BE503
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345092AbiBUIv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:51:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345095AbiBUIvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:51:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC34F132;
        Mon, 21 Feb 2022 00:51:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9087BB80EAA;
        Mon, 21 Feb 2022 08:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B958AC340F5;
        Mon, 21 Feb 2022 08:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433488;
        bh=cPrAsdAmXvt/iJsjtbMVLHpcB1qHV3cAWgflQkk1CR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEVZLHsqTM86nKz1ssd5Ts/+LjuChARkPQXxC6yBP4fKB15EoOKH+FcXgeZptgqI3
         ewKpW+0kIMngIOMbxscthmtRi4q/8SvbtFVbO1yo2w+raRCnwNOrmUsCSRHED9EgGA
         SiT4poFu/Vdoo1cygwk+kV9B5Ng0agWhMR1CXCqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 17/33] vsock: correct removal of socket from the list
Date:   Mon, 21 Feb 2022 09:49:10 +0100
Message-Id: <20220221084909.334642970@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
References: <20220221084908.568970525@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Sunil Muthuswamy <sunilmut@microsoft.com>

commit d5afa82c977ea06f7119058fa0eb8519ea501031 upstream.

The current vsock code for removal of socket from the list is both
subject to race and inefficient. It takes the lock, checks whether
the socket is in the list, drops the lock and if the socket was on the
list, deletes it from the list. This is subject to race because as soon
as the lock is dropped once it is checked for presence, that condition
cannot be relied upon for any decision. It is also inefficient because
if the socket is present in the list, it takes the lock twice.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |   38 +++++++-------------------------------
 1 file changed, 7 insertions(+), 31 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -279,7 +279,8 @@ EXPORT_SYMBOL_GPL(vsock_insert_connected
 void vsock_remove_bound(struct vsock_sock *vsk)
 {
 	spin_lock_bh(&vsock_table_lock);
-	__vsock_remove_bound(vsk);
+	if (__vsock_in_bound_table(vsk))
+		__vsock_remove_bound(vsk);
 	spin_unlock_bh(&vsock_table_lock);
 }
 EXPORT_SYMBOL_GPL(vsock_remove_bound);
@@ -287,7 +288,8 @@ EXPORT_SYMBOL_GPL(vsock_remove_bound);
 void vsock_remove_connected(struct vsock_sock *vsk)
 {
 	spin_lock_bh(&vsock_table_lock);
-	__vsock_remove_connected(vsk);
+	if (__vsock_in_connected_table(vsk))
+		__vsock_remove_connected(vsk);
 	spin_unlock_bh(&vsock_table_lock);
 }
 EXPORT_SYMBOL_GPL(vsock_remove_connected);
@@ -323,35 +325,10 @@ struct sock *vsock_find_connected_socket
 }
 EXPORT_SYMBOL_GPL(vsock_find_connected_socket);
 
-static bool vsock_in_bound_table(struct vsock_sock *vsk)
-{
-	bool ret;
-
-	spin_lock_bh(&vsock_table_lock);
-	ret = __vsock_in_bound_table(vsk);
-	spin_unlock_bh(&vsock_table_lock);
-
-	return ret;
-}
-
-static bool vsock_in_connected_table(struct vsock_sock *vsk)
-{
-	bool ret;
-
-	spin_lock_bh(&vsock_table_lock);
-	ret = __vsock_in_connected_table(vsk);
-	spin_unlock_bh(&vsock_table_lock);
-
-	return ret;
-}
-
 void vsock_remove_sock(struct vsock_sock *vsk)
 {
-	if (vsock_in_bound_table(vsk))
-		vsock_remove_bound(vsk);
-
-	if (vsock_in_connected_table(vsk))
-		vsock_remove_connected(vsk);
+	vsock_remove_bound(vsk);
+	vsock_remove_connected(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_remove_sock);
 
@@ -482,8 +459,7 @@ static void vsock_pending_work(struct wo
 	 * incoming packets can't find this socket, and to reduce the reference
 	 * count.
 	 */
-	if (vsock_in_connected_table(vsk))
-		vsock_remove_connected(vsk);
+	vsock_remove_connected(vsk);
 
 	sk->sk_state = SS_FREE;
 



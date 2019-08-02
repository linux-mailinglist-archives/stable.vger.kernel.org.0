Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F887F3B5
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406644AbfHBJ7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406611AbfHBJzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:55:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1DF22064A;
        Fri,  2 Aug 2019 09:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739753;
        bh=d0xyB4QEqG0WBfb3xGvbgzZAb+ysRIBs40y9kyOAwy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrUDq6qchpsea6K6uAEK1PC337bOksWCerCwHa84W8n+9yWjRawpT495QnZA0QHxA
         QdajqI+6OwFfTOIctVhrw0XNYI66puuV4ntTFoAOJD/E36UiGiMaUUBMSavl/4CMeK
         AbZkQ6VEub93iTRZE32tsyN0RJb/XYLFXekAnwSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 02/32] vsock: correct removal of socket from the list
Date:   Fri,  2 Aug 2019 11:39:36 +0200
Message-Id: <20190802092102.545376053@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
@@ -281,7 +281,8 @@ EXPORT_SYMBOL_GPL(vsock_insert_connected
 void vsock_remove_bound(struct vsock_sock *vsk)
 {
 	spin_lock_bh(&vsock_table_lock);
-	__vsock_remove_bound(vsk);
+	if (__vsock_in_bound_table(vsk))
+		__vsock_remove_bound(vsk);
 	spin_unlock_bh(&vsock_table_lock);
 }
 EXPORT_SYMBOL_GPL(vsock_remove_bound);
@@ -289,7 +290,8 @@ EXPORT_SYMBOL_GPL(vsock_remove_bound);
 void vsock_remove_connected(struct vsock_sock *vsk)
 {
 	spin_lock_bh(&vsock_table_lock);
-	__vsock_remove_connected(vsk);
+	if (__vsock_in_connected_table(vsk))
+		__vsock_remove_connected(vsk);
 	spin_unlock_bh(&vsock_table_lock);
 }
 EXPORT_SYMBOL_GPL(vsock_remove_connected);
@@ -325,35 +327,10 @@ struct sock *vsock_find_connected_socket
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
 
@@ -484,8 +461,7 @@ static void vsock_pending_work(struct wo
 	 * incoming packets can't find this socket, and to reduce the reference
 	 * count.
 	 */
-	if (vsock_in_connected_table(vsk))
-		vsock_remove_connected(vsk);
+	vsock_remove_connected(vsk);
 
 	sk->sk_state = TCP_CLOSE;
 



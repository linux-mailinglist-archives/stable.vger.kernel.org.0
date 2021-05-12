Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC91537C6A6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhELPw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236981AbhELPrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:47:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB0E561CA4;
        Wed, 12 May 2021 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833049;
        bh=4v+57ALotc0jddEyJgOvqYM/19XqGRsU/uGtEdBhB/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1OBh3oyCYjEjQ12AYWSw1WLUhwTjDh7/XYrPTlDLPm80JGC+lIA9kLTOCOIxpwCI
         41uMXDJ7yRR9TqNCpVA5EAJIIm3hKymaL2ZNspi1qk16XW/5HoT2yhgKjgIfxEKmv+
         ibDNH2tIoKO3JjnpWiz30PwZnznHxfwJmrz+Kblk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+959223586843e69a2674@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 529/530] Revert "net/sctp: fix race condition in sctp_destroy_sock"
Date:   Wed, 12 May 2021 16:50:39 +0200
Message-Id: <20210512144837.127134158@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 01bfe5e8e428b475982a98a46cca5755726f3f7f upstream.

This reverts commit b166a20b07382b8bc1dcee2a448715c9c2c81b5b.

This one has to be reverted as it introduced a dead lock, as
syzbot reported:

       CPU0                    CPU1
       ----                    ----
  lock(&net->sctp.addr_wq_lock);
                               lock(slock-AF_INET6);
                               lock(&net->sctp.addr_wq_lock);
  lock(slock-AF_INET6);

CPU0 is the thread of sctp_addr_wq_timeout_handler(), and CPU1
is that of sctp_close().

The original issue this commit fixed will be fixed in the next
patch.

Reported-by: syzbot+959223586843e69a2674@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1520,9 +1520,11 @@ static void sctp_close(struct sock *sk,
 
 	/* Supposedly, no process has access to the socket, but
 	 * the net layers still may.
+	 * Also, sctp_destroy_sock() needs to be called with addr_wq_lock
+	 * held and that should be grabbed before socket lock.
 	 */
-	local_bh_disable();
-	bh_lock_sock(sk);
+	spin_lock_bh(&net->sctp.addr_wq_lock);
+	bh_lock_sock_nested(sk);
 
 	/* Hold the sock, since sk_common_release() will put sock_put()
 	 * and we have just a little more cleanup.
@@ -1531,7 +1533,7 @@ static void sctp_close(struct sock *sk,
 	sk_common_release(sk);
 
 	bh_unlock_sock(sk);
-	local_bh_enable();
+	spin_unlock_bh(&net->sctp.addr_wq_lock);
 
 	sock_put(sk);
 
@@ -4937,6 +4939,9 @@ static int sctp_init_sock(struct sock *s
 	sk_sockets_allocated_inc(sk);
 	sock_prot_inuse_add(net, sk->sk_prot, 1);
 
+	/* Nothing can fail after this block, otherwise
+	 * sctp_destroy_sock() will be called without addr_wq_lock held
+	 */
 	if (net->sctp.default_auto_asconf) {
 		spin_lock(&sock_net(sk)->sctp.addr_wq_lock);
 		list_add_tail(&sp->auto_asconf_list,
@@ -4971,9 +4976,7 @@ static void sctp_destroy_sock(struct soc
 
 	if (sp->do_auto_asconf) {
 		sp->do_auto_asconf = 0;
-		spin_lock_bh(&sock_net(sk)->sctp.addr_wq_lock);
 		list_del(&sp->auto_asconf_list);
-		spin_unlock_bh(&sock_net(sk)->sctp.addr_wq_lock);
 	}
 	sctp_endpoint_free(sp->ep);
 	local_bh_disable();



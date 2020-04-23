Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0491B67C2
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgDWXJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:09:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50854 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728647AbgDWXG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvk-0004xX-C2; Fri, 24 Apr 2020 00:06:52 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvf-00E72P-P3; Fri, 24 Apr 2020 00:06:47 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>,
        syzbot+f2a62d07a5198c819c7b@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 24 Apr 2020 00:07:32 +0100
Message-ID: <lsq.1587683028.378990711@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 225/245] vhost: Check docket sk_family instead of
 call getname
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eugenio Pérez <eperezma@redhat.com>

commit 42d84c8490f9f0931786f1623191fcab397c3d64 upstream.

Doing so, we save one call to get data we already have in the struct.

Also, since there is no guarantee that getname use sockaddr_ll
parameter beyond its size, we add a little bit of security here.
It should do not do beyond MAX_ADDR_LEN, but syzbot found that
ax25_getname writes more (72 bytes, the size of full_sockaddr_ax25,
versus 20 + 32 bytes of sockaddr_ll + MAX_ADDR_LEN in syzbot repro).

Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
Reported-by: syzbot+f2a62d07a5198c819c7b@syzkaller.appspotmail.com
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: Also delete "uaddr_len" variable]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -843,11 +843,7 @@ static int vhost_net_release(struct inod
 
 static struct socket *get_raw_socket(int fd)
 {
-	struct {
-		struct sockaddr_ll sa;
-		char  buf[MAX_ADDR_LEN];
-	} uaddr;
-	int uaddr_len = sizeof uaddr, r;
+	int r;
 	struct socket *sock = sockfd_lookup(fd, &r);
 
 	if (!sock)
@@ -859,12 +855,7 @@ static struct socket *get_raw_socket(int
 		goto err;
 	}
 
-	r = sock->ops->getname(sock, (struct sockaddr *)&uaddr.sa,
-			       &uaddr_len, 0);
-	if (r)
-		goto err;
-
-	if (uaddr.sa.sll_family != AF_PACKET) {
+	if (sock->sk->sk_family != AF_PACKET) {
 		r = -EPFNOSUPPORT;
 		goto err;
 	}


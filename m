Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CE52A53A0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbgKCVCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387699AbgKCVCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:02:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00CED206B5;
        Tue,  3 Nov 2020 21:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437372;
        bh=F+MgyJy3M9UZmGV3BHb6dggJrNM6JemLtPXVNdjfttk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xz3jZFg89wWpNuqq2/yjHQ9qcrQTUf7ckC/pUdrQC07HfwvQMnzP4h2yw2b4RaWTK
         9jmM/iY2pV5Rrv+yqIRRhKfNp8UYWBvKl1Nd8q7Wor0G3wcFUeyTJUaNqN8oRshbw8
         yG9dkprKC8nTFhatudu8R/YayJmzMOj8jQfTtJVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Fujiwara <fujiwara.masahiro@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 010/191] gtp: fix an use-before-init in gtp_newlink()
Date:   Tue,  3 Nov 2020 21:35:02 +0100
Message-Id: <20201103203234.006055498@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Fujiwara <fujiwara.masahiro@gmail.com>

[ Upstream commit 51467431200b91682b89d31317e35dcbca1469ce ]

*_pdp_find() from gtp_encap_recv() would trigger a crash when a peer
sends GTP packets while creating new GTP device.

RIP: 0010:gtp1_pdp_find.isra.0+0x68/0x90 [gtp]
<SNIP>
Call Trace:
 <IRQ>
 gtp_encap_recv+0xc2/0x2e0 [gtp]
 ? gtp1_pdp_find.isra.0+0x90/0x90 [gtp]
 udp_queue_rcv_one_skb+0x1fe/0x530
 udp_queue_rcv_skb+0x40/0x1b0
 udp_unicast_rcv_skb.isra.0+0x78/0x90
 __udp4_lib_rcv+0x5af/0xc70
 udp_rcv+0x1a/0x20
 ip_protocol_deliver_rcu+0xc5/0x1b0
 ip_local_deliver_finish+0x48/0x50
 ip_local_deliver+0xe5/0xf0
 ? ip_protocol_deliver_rcu+0x1b0/0x1b0

gtp_encap_enable() should be called after gtp_hastable_new() otherwise
*_pdp_find() will access the uninitialized hash table.

Fixes: 1e3a3abd8b28 ("gtp: make GTP sockets in gtp_newlink optional")
Signed-off-by: Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
Link: https://lore.kernel.org/r/20201027114846.3924-1-fujiwara.masahiro@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -667,10 +667,6 @@ static int gtp_newlink(struct net *src_n
 
 	gtp = netdev_priv(dev);
 
-	err = gtp_encap_enable(gtp, data);
-	if (err < 0)
-		return err;
-
 	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
 		hashsize = 1024;
 	} else {
@@ -681,12 +677,16 @@ static int gtp_newlink(struct net *src_n
 
 	err = gtp_hashtable_new(gtp, hashsize);
 	if (err < 0)
-		goto out_encap;
+		return err;
+
+	err = gtp_encap_enable(gtp, data);
+	if (err < 0)
+		goto out_hashtable;
 
 	err = register_netdevice(dev);
 	if (err < 0) {
 		netdev_dbg(dev, "failed to register new netdev %d\n", err);
-		goto out_hashtable;
+		goto out_encap;
 	}
 
 	gn = net_generic(dev_net(dev), gtp_net_id);
@@ -697,11 +697,11 @@ static int gtp_newlink(struct net *src_n
 
 	return 0;
 
+out_encap:
+	gtp_encap_disable(gtp);
 out_hashtable:
 	kfree(gtp->addr_hash);
 	kfree(gtp->tid_hash);
-out_encap:
-	gtp_encap_disable(gtp);
 	return err;
 }
 



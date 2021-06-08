Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C893A0247
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbhFHTCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237401AbhFHTAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B07CA6144C;
        Tue,  8 Jun 2021 18:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177830;
        bh=OiJ8InZe1zfbwKimXOsHeqZpnG2u2FCzoVBR8jR4wEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f12HVXdDA3PWSqGsFfXNqDF15uYEeXQzDGQvY/HDL6eiQWixU0x1NkN5HMg8+l7Oi
         Rlj/1b64nKpZ1IhDbCBEeBDOR3hTIaWsls/LPjioTJDB7PXaC6RclN3LfYx5ScQOVD
         K/Wgc5o8egmLvvF8w/ZLiIBHj6g5Yvs90841ygTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Matthew Wilcox <willy@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 081/137] wireguard: peer: allocate in kmem_cache
Date:   Tue,  8 Jun 2021 20:27:01 +0200
Message-Id: <20210608175945.104045105@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit a4e9f8e3287c9eb6bf70df982870980dd3341863 upstream.

With deployments having upwards of 600k peers now, this somewhat heavy
structure could benefit from more fine-grained allocations.
Specifically, instead of using a 2048-byte slab for a 1544-byte object,
we can now use 1544-byte objects directly, thus saving almost 25%
per-peer, or with 600k peers, that's a savings of 303 MiB. This also
makes wireguard's memory usage more transparent in tools like slabtop
and /proc/slabinfo.

Fixes: 8b5553ace83c ("wireguard: queueing: get rid of per-peer ring buffers")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/main.c |    7 +++++++
 drivers/net/wireguard/peer.c |   21 +++++++++++++++++----
 drivers/net/wireguard/peer.h |    3 +++
 3 files changed, 27 insertions(+), 4 deletions(-)

--- a/drivers/net/wireguard/main.c
+++ b/drivers/net/wireguard/main.c
@@ -28,6 +28,10 @@ static int __init mod_init(void)
 #endif
 	wg_noise_init();
 
+	ret = wg_peer_init();
+	if (ret < 0)
+		goto err_peer;
+
 	ret = wg_device_init();
 	if (ret < 0)
 		goto err_device;
@@ -44,6 +48,8 @@ static int __init mod_init(void)
 err_netlink:
 	wg_device_uninit();
 err_device:
+	wg_peer_uninit();
+err_peer:
 	return ret;
 }
 
@@ -51,6 +57,7 @@ static void __exit mod_exit(void)
 {
 	wg_genetlink_uninit();
 	wg_device_uninit();
+	wg_peer_uninit();
 }
 
 module_init(mod_init);
--- a/drivers/net/wireguard/peer.c
+++ b/drivers/net/wireguard/peer.c
@@ -15,6 +15,7 @@
 #include <linux/rcupdate.h>
 #include <linux/list.h>
 
+static struct kmem_cache *peer_cache;
 static atomic64_t peer_counter = ATOMIC64_INIT(0);
 
 struct wg_peer *wg_peer_create(struct wg_device *wg,
@@ -29,10 +30,10 @@ struct wg_peer *wg_peer_create(struct wg
 	if (wg->num_peers >= MAX_PEERS_PER_DEVICE)
 		return ERR_PTR(ret);
 
-	peer = kzalloc(sizeof(*peer), GFP_KERNEL);
+	peer = kmem_cache_zalloc(peer_cache, GFP_KERNEL);
 	if (unlikely(!peer))
 		return ERR_PTR(ret);
-	if (dst_cache_init(&peer->endpoint_cache, GFP_KERNEL))
+	if (unlikely(dst_cache_init(&peer->endpoint_cache, GFP_KERNEL)))
 		goto err;
 
 	peer->device = wg;
@@ -64,7 +65,7 @@ struct wg_peer *wg_peer_create(struct wg
 	return peer;
 
 err:
-	kfree(peer);
+	kmem_cache_free(peer_cache, peer);
 	return ERR_PTR(ret);
 }
 
@@ -193,7 +194,8 @@ static void rcu_release(struct rcu_head
 	/* The final zeroing takes care of clearing any remaining handshake key
 	 * material and other potentially sensitive information.
 	 */
-	kfree_sensitive(peer);
+	memzero_explicit(peer, sizeof(*peer));
+	kmem_cache_free(peer_cache, peer);
 }
 
 static void kref_release(struct kref *refcount)
@@ -225,3 +227,14 @@ void wg_peer_put(struct wg_peer *peer)
 		return;
 	kref_put(&peer->refcount, kref_release);
 }
+
+int __init wg_peer_init(void)
+{
+	peer_cache = KMEM_CACHE(wg_peer, 0);
+	return peer_cache ? 0 : -ENOMEM;
+}
+
+void wg_peer_uninit(void)
+{
+	kmem_cache_destroy(peer_cache);
+}
--- a/drivers/net/wireguard/peer.h
+++ b/drivers/net/wireguard/peer.h
@@ -80,4 +80,7 @@ void wg_peer_put(struct wg_peer *peer);
 void wg_peer_remove(struct wg_peer *peer);
 void wg_peer_remove_all(struct wg_device *wg);
 
+int wg_peer_init(void);
+void wg_peer_uninit(void);
+
 #endif /* _WG_PEER_H */



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304A63A032D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhFHTNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236904AbhFHTLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22DAF61461;
        Tue,  8 Jun 2021 18:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178149;
        bh=Xd8sKBW52rGJ+PBUBAVrXHiFQyeJpduTKPcd2uOIiJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAJOU7iSjknaCjlqvXIUxBUQ3XWY5xiPnaRzLIwG6+HPsNcYbDmvrYHKogJq4iggB
         sDQC/kTahG01i5EVHF79Tso+Fxd4HquB0AezoP9tjWRbyXQHgy+NBEkBq72wcQXBnx
         tV1mY77tgyL9KZz7W74CuqsLW7P0fwF7UPdxcnoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 096/161] wireguard: use synchronize_net rather than synchronize_rcu
Date:   Tue,  8 Jun 2021 20:27:06 +0200
Message-Id: <20210608175948.698136203@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 24b70eeeb4f46c09487f8155239ebfb1f875774a upstream.

Many of the synchronization points are sometimes called under the rtnl
lock, which means we should use synchronize_net rather than
synchronize_rcu. Under the hood, this expands to using the expedited
flavor of function in the event that rtnl is held, in order to not stall
other concurrent changes.

This fixes some very, very long delays when removing multiple peers at
once, which would cause some operations to take several minutes.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/peer.c   |    6 +++---
 drivers/net/wireguard/socket.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireguard/peer.c
+++ b/drivers/net/wireguard/peer.c
@@ -89,7 +89,7 @@ static void peer_make_dead(struct wg_pee
 	/* Mark as dead, so that we don't allow jumping contexts after. */
 	WRITE_ONCE(peer->is_dead, true);
 
-	/* The caller must now synchronize_rcu() for this to take effect. */
+	/* The caller must now synchronize_net() for this to take effect. */
 }
 
 static void peer_remove_after_dead(struct wg_peer *peer)
@@ -161,7 +161,7 @@ void wg_peer_remove(struct wg_peer *peer
 	lockdep_assert_held(&peer->device->device_update_lock);
 
 	peer_make_dead(peer);
-	synchronize_rcu();
+	synchronize_net();
 	peer_remove_after_dead(peer);
 }
 
@@ -179,7 +179,7 @@ void wg_peer_remove_all(struct wg_device
 		peer_make_dead(peer);
 		list_add_tail(&peer->peer_list, &dead_peers);
 	}
-	synchronize_rcu();
+	synchronize_net();
 	list_for_each_entry_safe(peer, temp, &dead_peers, peer_list)
 		peer_remove_after_dead(peer);
 }
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -430,7 +430,7 @@ void wg_socket_reinit(struct wg_device *
 	if (new4)
 		wg->incoming_port = ntohs(inet_sk(new4)->inet_sport);
 	mutex_unlock(&wg->socket_update_lock);
-	synchronize_rcu();
+	synchronize_net();
 	sock_free(old4);
 	sock_free(old6);
 }



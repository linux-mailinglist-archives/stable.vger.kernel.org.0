Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B949288D3D
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfHJUn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:43:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54542 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726730AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00053e-LR; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003l3-UX; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Vlad Yasevich" <vyasevich@gmail.com>,
        "Vladislav Yasevich" <vyasevic@redhat.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.265297102@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 147/157] Revert "drivers/net, ipv6: Select IPv6
 fragment idents for virtio UFO packets"
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

commit 72f6510745592c87f612f62ae4f16bb002934df4 upstream.

This reverts commit 5188cd44c55db3e92cd9e77a40b5baa7ed4340f7.

Now that GSO layer can track if fragment id has been selected
and can allocate one if necessary, we don't need to do this in
tap and macvtap.  This reverts most of the code and only keeps
the new ipv6 fragment id generation function that is still needed.

Fixes: 3d0ad09412ff (drivers/net: Disable UFO through virtio)
Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/macvtap.c | 3 ---
 drivers/net/tun.c     | 6 +-----
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -16,7 +16,6 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 
-#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
@@ -571,8 +570,6 @@ static int macvtap_skb_from_vnet_hdr(str
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			gso_type = SKB_GSO_UDP;
-			if (skb->protocol == htons(ETH_P_IPV6))
-				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			return -EINVAL;
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -65,7 +65,6 @@
 #include <linux/nsproxy.h>
 #include <linux/virtio_net.h>
 #include <linux/rcupdate.h>
-#include <net/ipv6.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/rtnetlink.h>
@@ -1143,8 +1142,6 @@ static ssize_t tun_get_user(struct tun_s
 		break;
 	}
 
-	skb_reset_network_header(skb);
-
 	if (gso.gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		pr_debug("GSO!\n");
 		switch (gso.gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
@@ -1156,8 +1153,6 @@ static ssize_t tun_get_user(struct tun_s
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
-			if (skb->protocol == htons(ETH_P_IPV6))
-				ipv6_proxy_select_ident(skb);
 			break;
 		default:
 			tun->dev->stats.rx_frame_errors++;
@@ -1187,6 +1182,7 @@ static ssize_t tun_get_user(struct tun_s
 		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
 	}
 
+	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb, 0);
 
 	rxhash = skb_get_hash(skb);


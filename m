Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253EA28B79E
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389562AbgJLNo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731551AbgJLNmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:42:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94F5B22227;
        Mon, 12 Oct 2020 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510157;
        bh=A1jcSsf8w89XJvJHo4za3hRNOQ9EBXCrildb1koHq1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uH2bKUdEmrtNpSBwWeh/Y50zaBZZ0OKBWKdeAsUCPouiya8SVxaeV2X1jCGcWJd86
         AA9zwLeP1rNYjBXfyxlvYVQExEz1Eto4Em+ZtIpXEgaEwFqMfQk6VWWG0bgNw6ytuV
         G1Wx7rN+fTv+vyiXXqgiy8MgKL60Ou5oIByBUMek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 64/85] virtio-net: dont disable guest csum when disable LRO
Date:   Mon, 12 Oct 2020 15:27:27 +0200
Message-Id: <20201012132635.922502288@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

[ Upstream commit 1a03b8a35a957f9f38ecb8a97443b7380bbf6a8b ]

Open vSwitch and Linux bridge will disable LRO of the interface
when this interface added to them. Now when disable the LRO, the
virtio-net csum is disable too. That drops the forwarding performance.

Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 030d30603c295..99e1a7bc06886 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_CSUM
 };
 
+#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
+				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
+				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
+				(1ULL << VIRTIO_NET_F_GUEST_UFO))
+
 struct virtnet_stat_desc {
 	char desc[ETH_GSTRING_LEN];
 	size_t offset;
@@ -2572,7 +2577,8 @@ static int virtnet_set_features(struct net_device *dev,
 		if (features & NETIF_F_LRO)
 			offloads = vi->guest_offloads_capable;
 		else
-			offloads = 0;
+			offloads = vi->guest_offloads_capable &
+				   ~GUEST_OFFLOAD_LRO_MASK;
 
 		err = virtnet_set_guest_offloads(vi, offloads);
 		if (err)
-- 
2.25.1




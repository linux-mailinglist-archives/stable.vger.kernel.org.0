Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7380545BEA0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343910AbhKXMt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:49:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243823AbhKXMqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:46:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89D2660F5D;
        Wed, 24 Nov 2021 12:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756845;
        bh=zvwwkz4a1864rySuag+u4+xUFnM3OUaTwLo+NVyf6so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j41lNLJcvsYX5iyThmK9EaplmiaYpEnPsUIUS3RaGWGuCLbZNE/u7ODwlQu+7/trZ
         UydK/50dDk/Z6RR2trwXct1yVQBv9oOruc/cA7/Qcc2TUCHfobHZHHIxlSUaXUscqO
         s0OK2/wD09UY5FGxeAvK+pBiyeH7MffMfI+7+kiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Davies <jonathan.davies@nutanix.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 227/251] net: virtio_net_hdr_to_skb: count transport header in UFO
Date:   Wed, 24 Nov 2021 12:57:49 +0100
Message-Id: <20211124115718.178184981@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Davies <jonathan.davies@nutanix.com>

[ Upstream commit cf9acc90c80ecbee00334aa85d92f4e74014bcff ]

virtio_net_hdr_to_skb does not set the skb's gso_size and gso_type
correctly for UFO packets received via virtio-net that are a little over
the GSO size. This can lead to problems elsewhere in the networking
stack, e.g. ovs_vport_send dropping over-sized packets if gso_size is
not set.

This is due to the comparison

  if (skb->len - p_off > gso_size)

not properly accounting for the transport layer header.

p_off includes the size of the transport layer header (thlen), so
skb->len - p_off is the size of the TCP/UDP payload.

gso_size is read from the virtio-net header. For UFO, fragmentation
happens at the IP level so does not need to include the UDP header.

Hence the calculation could be comparing a TCP/UDP payload length with
an IP payload length, causing legitimate virtio-net packets to have
lack gso_type/gso_size information.

Example: a UDP packet with payload size 1473 has IP payload size 1481.
If the guest used UFO, it is not fragmented and the virtio-net header's
flags indicate that it is a GSO frame (VIRTIO_NET_HDR_GSO_UDP), with
gso_size = 1480 for an MTU of 1500.  skb->len will be 1515 and p_off
will be 42, so skb->len - p_off = 1473.  Hence the comparison fails, and
shinfo->gso_size and gso_type are not set as they should be.

Instead, add the UDP header length before comparing to gso_size when
using UFO. In this way, it is the size of the IP payload that is
compared to gso_size.

Fixes: 6dd912f82680 ("net: check untrusted gso_size at kernel entry")
Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_net.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index ca68826d84495..162761f72c142 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -118,10 +118,15 @@ retry:
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
+		unsigned int nh_off = p_off;
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
+		/* UFO may not include transport header in gso_size. */
+		if (gso_type & SKB_GSO_UDP)
+			nh_off -= thlen;
+
 		/* Too small packets are not really GSO ones. */
-		if (skb->len - p_off > gso_size) {
+		if (skb->len - nh_off > gso_size) {
 			shinfo->gso_size = gso_size;
 			shinfo->gso_type = gso_type;
 
-- 
2.33.0




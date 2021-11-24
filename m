Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E240245C17B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344574AbhKXNTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:19:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344482AbhKXNRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:17:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF8ED61AD2;
        Wed, 24 Nov 2021 12:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757894;
        bh=Pr1QA4m7BfgSC4xLBsZg+Lzl88qRi32rFeaykM3CsiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmG5Sd7jSOps0CVcz7arf+e+tu0NgG7G/wuQ/Afwn7Rgqa7UWMUmesaNav32Ug9OX
         v2zbymj0EFcoK99HlLXxuXkz0wjoPbRkFQKCUU4s6bDu4Jn+fjdDvvpHdAnK77L1hk
         GCs9erJbuUhV8vqUPPf+imeJdLcCgX1thV6vLBJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Davies <jonathan.davies@nutanix.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 294/323] net: virtio_net_hdr_to_skb: count transport header in UFO
Date:   Wed, 24 Nov 2021 12:58:04 +0100
Message-Id: <20211124115728.833416243@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 8f48264f5dab3..e7330a9a7d7dc 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -120,10 +120,15 @@ retry:
 
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




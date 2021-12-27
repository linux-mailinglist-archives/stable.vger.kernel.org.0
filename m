Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7D747FF91
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbhL0Pii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:38:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37220 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238575AbhL0PhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:37:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF94610A6;
        Mon, 27 Dec 2021 15:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BC4C36AE7;
        Mon, 27 Dec 2021 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619424;
        bh=XTFuv+3trPRcX4iSAIMdG+6Y6HGP2IN8vMVxAYg76Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEOGzvyDrCW2+raJGl9qTqvCVyD0AAHFGEOLWruwrJSjoJivgSH0e0G6NaYAJ4E72
         jEVtR2QFEg+hrq4Jz4Kbs5S2YLC3OvnTUvOmkyfX7/ykhY/KRXJq3MMdW3zQCH8V3Q
         4eLI0QhtH025/t+he5p47h0nZWUvhqouGaR5n0Sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/76] net: skip virtio_net_hdr_set_proto if protocol already set
Date:   Mon, 27 Dec 2021 16:30:34 +0100
Message-Id: <20211227151325.356196087@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 1ed1d592113959f00cc552c3b9f47ca2d157768f ]

virtio_net_hdr_set_proto infers skb->protocol from the virtio_net_hdr
gso_type, to avoid packets getting dropped for lack of a proto type.

Its protocol choice is a guess, especially in the case of UFO, where
the single VIRTIO_NET_HDR_GSO_UDP label covers both UFOv4 and UFOv6.

Skip this best effort if the field is already initialized. Whether
explicitly from userspace, or implicitly based on an earlier call to
dev_parse_header_protocol (which is more robust, but was introduced
after this patch).

Fixes: 9d2f67e43b73 ("net/packet: fix packet drop as of virtio gso")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20211220145027.2784293-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_net.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 22dd48c825600..a960de68ac69e 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -25,6 +25,9 @@ static inline bool virtio_net_hdr_match_proto(__be16 protocol, __u8 gso_type)
 static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 					   const struct virtio_net_hdr *hdr)
 {
+	if (skb->protocol)
+		return 0;
+
 	switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
 	case VIRTIO_NET_HDR_GSO_TCPV4:
 	case VIRTIO_NET_HDR_GSO_UDP:
-- 
2.34.1




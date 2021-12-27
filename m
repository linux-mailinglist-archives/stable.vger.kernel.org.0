Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334F947FF48
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhL0Pgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:36:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35146 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238269AbhL0PeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:34:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BC9D61073;
        Mon, 27 Dec 2021 15:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A01C36AEA;
        Mon, 27 Dec 2021 15:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619261;
        bh=XTFuv+3trPRcX4iSAIMdG+6Y6HGP2IN8vMVxAYg76Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moHryx6W1xVU+t3f6vGCjdzw5UYX+KZBfd2yIC7M+DQKr4xG0vc+AMCUDBTaF1WYh
         V9yee2Vt3caWa/FK/nzjuKXZUz3U5nWsJ9dO7+Bkgz95TOKCsP3mON9DZmBLftXPHZ
         1nXPlQK49p6ErgQdFDAadiIFELDSOtJzAj6Zrtco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/47] net: skip virtio_net_hdr_set_proto if protocol already set
Date:   Mon, 27 Dec 2021 16:30:46 +0100
Message-Id: <20211227151321.139250343@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
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




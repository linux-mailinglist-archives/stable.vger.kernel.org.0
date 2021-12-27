Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C7147FE85
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhL0P3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:29:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34674 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237561AbhL0P3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:29:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF0E1B810C3;
        Mon, 27 Dec 2021 15:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CDBC36AE7;
        Mon, 27 Dec 2021 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618971;
        bh=GY53WkC3GlerRJsLHDC9VaLjERQ4URDtHWY3OAUzc5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qp+6fxNaIHGBdPTckw7uXONOzBLRKkABp4zsdRNB14VFyLVMQL/lpmOG8y5/0GS1Q
         g6xQlesCSIk0+DoX6D0YZZ0+Cm5xltmyZYeyB8Qev/U/FmkTaJbDNI5VwdGxm2tll8
         ogKvq6Bg0owCzGtsnpEUfkZQtGDbumd4H6fpCQ4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/29] net: skip virtio_net_hdr_set_proto if protocol already set
Date:   Mon, 27 Dec 2021 16:27:19 +0100
Message-Id: <20211227151318.776404083@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
References: <20211227151318.475251079@linuxfoundation.org>
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
index f5876f7a2ab24..db8ab0fac81a2 100644
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




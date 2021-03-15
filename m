Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AD133B620
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhCON5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhCON4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B3664F01;
        Mon, 15 Mar 2021 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816604;
        bh=mvbavpRwyDZocyv8ldOUoDiqHwnZizG1ECvHExjijLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4/eGxQFHtGvMcwdBcn/RF4aaK1ZDNbRhDb9PwnDTj6m0GhIbhWwIOGbTq61nU5Pd
         Mqkw5H5SFd0y/tCnrEkWpDp27B3Zj2oXZpmnm8tiU7/aR13tGC7onZEDko/GtX2xXZ
         TjQkN6ZfMGIk0TfZgsi1JNiIuPxAtfxeNA/L4bog=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Balazs Nemeth <bnemeth@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 008/290] net: check if protocol extracted by virtio_net_hdr_set_proto is correct
Date:   Mon, 15 Mar 2021 14:51:41 +0100
Message-Id: <20210315135542.220384976@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Balazs Nemeth <bnemeth@redhat.com>

commit 924a9bc362a5223cd448ca08c3dde21235adc310 upstream.

For gso packets, virtio_net_hdr_set_proto sets the protocol (if it isn't
set) based on the type in the virtio net hdr, but the skb could contain
anything since it could come from packet_snd through a raw socket. If
there is a mismatch between what virtio_net_hdr_set_proto sets and
the actual protocol, then the skb could be handled incorrectly later
on.

An example where this poses an issue is with the subsequent call to
skb_flow_dissect_flow_keys_basic which relies on skb->protocol being set
correctly. A specially crafted packet could fool
skb_flow_dissect_flow_keys_basic preventing EINVAL to be returned.

Avoid blindly trusting the information provided by the virtio net header
by checking that the protocol in the packet actually matches the
protocol set by virtio_net_hdr_set_proto. Note that since the protocol
is only checked if skb->dev implements header_ops->parse_protocol,
packets from devices without the implementation are not checked at this
stage.

Fixes: 9274124f023b ("net: stricter validation of untrusted gso packets")
Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/virtio_net.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -79,8 +79,13 @@ static inline int virtio_net_hdr_to_skb(
 		if (gso_type && skb->network_header) {
 			struct flow_keys_basic keys;
 
-			if (!skb->protocol)
+			if (!skb->protocol) {
+				__be16 protocol = dev_parse_header_protocol(skb);
+
 				virtio_net_hdr_set_proto(skb, hdr);
+				if (protocol && protocol != skb->protocol)
+					return -EINVAL;
+			}
 retry:
 			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
 							      NULL, 0, 0, 0,



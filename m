Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599F333B63D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhCON52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231228AbhCON44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D48964EF3;
        Mon, 15 Mar 2021 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816616;
        bh=mvbavpRwyDZocyv8ldOUoDiqHwnZizG1ECvHExjijLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZzQZuJfDRYqfwaRuYg31jgO4iMh9oxi51Exif0tnRN5oGfYHXcUyV9jot306GSjF
         81EIqokXTb1jwTn78FKKtVOLyxfomiaHy/9Pkad0vWBCafhPcjMNHQpDXjb9ui8A1A
         YAA90yte+maxbr2Xy5vHzuNRS3hfZ/LHwagtzBH0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Balazs Nemeth <bnemeth@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 006/168] net: check if protocol extracted by virtio_net_hdr_set_proto is correct
Date:   Mon, 15 Mar 2021 14:53:58 +0100
Message-Id: <20210315135550.546718379@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
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



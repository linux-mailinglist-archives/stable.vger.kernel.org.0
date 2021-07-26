Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F4B3D5DF4
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbhGZPEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235991AbhGZPE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 673D460F58;
        Mon, 26 Jul 2021 15:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314297;
        bh=DGfMhS/QxUCb1nUGcjN26KHROobYUPCysiMp5HZkqLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuWpKjsv6pp2/I0hK29B29NLF+zvo2u5MCKJhl4EcrXE9OwuqvmTE+afHlMQ5MfhR
         WFAzRt7FByZxg+vbEfKrEt0H03uoZw+EOJY8clRZW2MuA3SsC/Wry74fYCEuGJMJR/
         wILd0q+rb0pos0DbAwzFlYr3TzHcrz06OERgc81c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 21/60] net: validate lwtstate->data before returning from skb_tunnel_info()
Date:   Mon, 26 Jul 2021 17:38:35 +0200
Message-Id: <20210726153825.537393055@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit 67a9c94317402b826fc3db32afc8f39336803d97 upstream.

skb_tunnel_info() returns pointer of lwtstate->data as ip_tunnel_info
type without validation. lwtstate->data can have various types such as
mpls_iptunnel_encap, etc and these are not compatible.
So skb_tunnel_info() should validate before returning that pointer.

Splat looks like:
BUG: KASAN: slab-out-of-bounds in vxlan_get_route+0x418/0x4b0 [vxlan]
Read of size 2 at addr ffff888106ec2698 by task ping/811

CPU: 1 PID: 811 Comm: ping Not tainted 5.13.0+ #1195
Call Trace:
 dump_stack_lvl+0x56/0x7b
 print_address_description.constprop.8.cold.13+0x13/0x2ee
 ? vxlan_get_route+0x418/0x4b0 [vxlan]
 ? vxlan_get_route+0x418/0x4b0 [vxlan]
 kasan_report.cold.14+0x83/0xdf
 ? vxlan_get_route+0x418/0x4b0 [vxlan]
 vxlan_get_route+0x418/0x4b0 [vxlan]
 [ ... ]
 vxlan_xmit_one+0x148b/0x32b0 [vxlan]
 [ ... ]
 vxlan_xmit+0x25c5/0x4780 [vxlan]
 [ ... ]
 dev_hard_start_xmit+0x1ae/0x6e0
 __dev_queue_xmit+0x1f39/0x31a0
 [ ... ]
 neigh_xmit+0x2f9/0x940
 mpls_xmit+0x911/0x1600 [mpls_iptunnel]
 lwtunnel_xmit+0x18f/0x450
 ip_finish_output2+0x867/0x2040
 [ ... ]

Fixes: 61adedf3e3f1 ("route: move lwtunnel state to dst_entry")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst_metadata.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -31,7 +31,9 @@ static inline struct ip_tunnel_info *skb
 		return &md_dst->u.tun_info;
 
 	dst = skb_dst(skb);
-	if (dst && dst->lwtstate)
+	if (dst && dst->lwtstate &&
+	    (dst->lwtstate->type == LWTUNNEL_ENCAP_IP ||
+	     dst->lwtstate->type == LWTUNNEL_ENCAP_IP6))
 		return lwt_tun_info(dst->lwtstate);
 
 	return NULL;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888861EAB60
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731757AbgFASQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731754AbgFASQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B20320776;
        Mon,  1 Jun 2020 18:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035413;
        bh=dUG1Ak5XxgkCPUsPDSxotQhuzW0jzCC4BzCrfzxmx3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FeVC21IZ7b3JG7/wmC5uP++ktry5KYazoN4QgVSYD2xVLeR54shV/qfq1GgUiWhr
         l+SjvFDIeMROgaK2FaEWKtkfeNdBn+zam23KkKzx/kBtuW6FZffaWIrZMR3xnriuRT
         tEbFW/WlfSqBiHXJN+Xz2usCj7mdP9x4G5n6UKPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.6 148/177] xfrm: call xfrm_output_gso when inner_protocol is set in xfrm_output
Date:   Mon,  1 Jun 2020 19:54:46 +0200
Message-Id: <20200601174100.780862436@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit a204aef9fd77dce1efd9066ca4e44eede99cd858 upstream.

An use-after-free crash can be triggered when sending big packets over
vxlan over esp with esp offload enabled:

  [] BUG: KASAN: use-after-free in ipv6_gso_pull_exthdrs.part.8+0x32c/0x4e0
  [] Call Trace:
  []  dump_stack+0x75/0xa0
  []  kasan_report+0x37/0x50
  []  ipv6_gso_pull_exthdrs.part.8+0x32c/0x4e0
  []  ipv6_gso_segment+0x2c8/0x13c0
  []  skb_mac_gso_segment+0x1cb/0x420
  []  skb_udp_tunnel_segment+0x6b5/0x1c90
  []  inet_gso_segment+0x440/0x1380
  []  skb_mac_gso_segment+0x1cb/0x420
  []  esp4_gso_segment+0xae8/0x1709 [esp4_offload]
  []  inet_gso_segment+0x440/0x1380
  []  skb_mac_gso_segment+0x1cb/0x420
  []  __skb_gso_segment+0x2d7/0x5f0
  []  validate_xmit_skb+0x527/0xb10
  []  __dev_queue_xmit+0x10f8/0x2320 <---
  []  ip_finish_output2+0xa2e/0x1b50
  []  ip_output+0x1a8/0x2f0
  []  xfrm_output_resume+0x110e/0x15f0
  []  __xfrm4_output+0xe1/0x1b0
  []  xfrm4_output+0xa0/0x200
  []  iptunnel_xmit+0x5a7/0x920
  []  vxlan_xmit_one+0x1658/0x37a0 [vxlan]
  []  vxlan_xmit+0x5e4/0x3ec8 [vxlan]
  []  dev_hard_start_xmit+0x125/0x540
  []  __dev_queue_xmit+0x17bd/0x2320  <---
  []  ip6_finish_output2+0xb20/0x1b80
  []  ip6_output+0x1b3/0x390
  []  ip6_xmit+0xb82/0x17e0
  []  inet6_csk_xmit+0x225/0x3d0
  []  __tcp_transmit_skb+0x1763/0x3520
  []  tcp_write_xmit+0xd64/0x5fe0
  []  __tcp_push_pending_frames+0x8c/0x320
  []  tcp_sendmsg_locked+0x2245/0x3500
  []  tcp_sendmsg+0x27/0x40

As on the tx path of vxlan over esp, skb->inner_network_header would be
set on vxlan_xmit() and xfrm4_tunnel_encap_add(), and the later one can
overwrite the former one. It causes skb_udp_tunnel_segment() to use a
wrong skb->inner_network_header, then the issue occurs.

This patch is to fix it by calling xfrm_output_gso() instead when the
inner_protocol is set, in which gso_segment of inner_protocol will be
done first.

While at it, also improve some code around.

Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_output.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -583,18 +583,20 @@ int xfrm_output(struct sock *sk, struct
 		xfrm_state_hold(x);
 
 		if (skb_is_gso(skb)) {
-			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;
+			if (skb->inner_protocol)
+				return xfrm_output_gso(net, sk, skb);
 
-			return xfrm_output2(net, sk, skb);
+			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;
+			goto out;
 		}
 
 		if (x->xso.dev && x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM)
 			goto out;
+	} else {
+		if (skb_is_gso(skb))
+			return xfrm_output_gso(net, sk, skb);
 	}
 
-	if (skb_is_gso(skb))
-		return xfrm_output_gso(net, sk, skb);
-
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		err = skb_checksum_help(skb);
 		if (err) {



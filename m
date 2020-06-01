Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C7C1EAAA8
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgFASKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730486AbgFASKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:10:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864C52068D;
        Mon,  1 Jun 2020 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035011;
        bh=UKca6Vmt0hmdfqCKi6/7uixcWxyqVdBAMMZHI2WyIZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IV1cZC0FShJFHCjrjys1RJe05FZaDQNuFTuTNklnYcBueW9WUFcEacLDG665/ulcA
         LW2T5BWWIw/gLci4oafn5ahkV5L3vtgq5iO71jYAGFZavESqccdNHhYODU8UBNzz6v
         AXtDQq4hRQtroDipMq6SoK2qm6oGkXL1RretgPOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 113/142] xfrm: do pskb_pull properly in __xfrm_transport_prep
Date:   Mon,  1 Jun 2020 19:54:31 +0200
Message-Id: <20200601174049.610662064@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 06a0afcfe2f551ff755849ea2549b0d8409fd9a0 upstream.

For transport mode, when ipv6 nexthdr is set, the packet format might
be like:

    ----------------------------------------------------
    |        | dest |     |     |      |  ESP    | ESP |
    | IP6 hdr| opts.| ESP | TCP | Data | Trailer | ICV |
    ----------------------------------------------------

and in __xfrm_transport_prep():

  pskb_pull(skb, skb->mac_len + sizeof(ip6hdr) + x->props.header_len);

it will pull the data pointer to the wrong position, as it missed the
nexthdrs/dest opts.

This patch is to fix it by using:

  pskb_pull(skb, skb_transport_offset(skb) + x->props.header_len);

as we can be sure transport_header points to ESP header at that moment.

It also fixes a panic when packets with ipv6 nexthdr are sent over
esp6 transport mode:

  [  100.473845] kernel BUG at net/core/skbuff.c:4325!
  [  100.478517] RIP: 0010:__skb_to_sgvec+0x252/0x260
  [  100.494355] Call Trace:
  [  100.494829]  skb_to_sgvec+0x11/0x40
  [  100.495492]  esp6_output_tail+0x12e/0x550 [esp6]
  [  100.496358]  esp6_xmit+0x1d5/0x260 [esp6_offload]
  [  100.498029]  validate_xmit_xfrm+0x22f/0x2e0
  [  100.499604]  __dev_queue_xmit+0x589/0x910
  [  100.502928]  ip6_finish_output2+0x2a5/0x5a0
  [  100.503718]  ip6_output+0x6c/0x120
  [  100.505198]  xfrm_output_resume+0x4bf/0x530
  [  100.508683]  xfrm6_output+0x3a/0xc0
  [  100.513446]  inet6_csk_xmit+0xa1/0xf0
  [  100.517335]  tcp_sendmsg+0x27/0x40
  [  100.517977]  sock_sendmsg+0x3e/0x60
  [  100.518648]  __sys_sendto+0xee/0x160

Fixes: c35fe4106b92 ("xfrm: Add mode handlers for IPsec on layer 2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_device.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -25,12 +25,10 @@ static void __xfrm_transport_prep(struct
 	struct xfrm_offload *xo = xfrm_offload(skb);
 
 	skb_reset_mac_len(skb);
-	pskb_pull(skb, skb->mac_len + hsize + x->props.header_len);
-
-	if (xo->flags & XFRM_GSO_SEGMENT) {
-		skb_reset_transport_header(skb);
+	if (xo->flags & XFRM_GSO_SEGMENT)
 		skb->transport_header -= x->props.header_len;
-	}
+
+	pskb_pull(skb, skb_transport_offset(skb) + x->props.header_len);
 }
 
 static void __xfrm_mode_tunnel_prep(struct xfrm_state *x, struct sk_buff *skb,



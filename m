Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB51433B6DF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhCON67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232013AbhCON6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 875EC64F19;
        Mon, 15 Mar 2021 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816683;
        bh=w/d4SMwBuBwagClHAKxcuT073SRkKb5PzzY7h68hNqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0IHcGOGuTr0q5HKVA1DGthr7F/ATHcoSt8SwweX304R7Bj0ZUX625xe1n4bLzQTqZ
         I0mU3r/3YWWFdmYZ3+wrXSA8eRv6d8U3H2tUcL2i3abysFaT30Dx975LXQeeN5i9nk
         lbcl9/kPOKqp62PVvwxi2k7I/BoA4ruPoBrYdBO4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>,
        Willem de Bruijn <willemb@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 004/120] net: Fix gro aggregation for udp encaps with zero csum
Date:   Mon, 15 Mar 2021 14:55:55 +0100
Message-Id: <20210315135720.152935021@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Daniel Borkmann <daniel@iogearbox.net>

commit 89e5c58fc1e2857ccdaae506fb8bc5fed57ee063 upstream.

We noticed a GRO issue for UDP-based encaps such as vxlan/geneve when the
csum for the UDP header itself is 0. In that case, GRO aggregation does
not take place on the phys dev, but instead is deferred to the vxlan/geneve
driver (see trace below).

The reason is essentially that GRO aggregation bails out in udp_gro_receive()
for such case when drivers marked the skb with CHECKSUM_UNNECESSARY (ice, i40e,
others) where for non-zero csums 2abb7cdc0dc8 ("udp: Add support for doing
checksum unnecessary conversion") promotes those skbs to CHECKSUM_COMPLETE
and napi context has csum_valid set. This is however not the case for zero
UDP csum (here: csum_cnt is still 0 and csum_valid continues to be false).

At the same time 57c67ff4bd92 ("udp: additional GRO support") added matches
on !uh->check ^ !uh2->check as part to determine candidates for aggregation,
so it certainly is expected to handle zero csums in udp_gro_receive(). The
purpose of the check added via 662880f44203 ("net: Allow GRO to use and set
levels of checksum unnecessary") seems to catch bad csum and stop aggregation
right away.

One way to fix aggregation in the zero case is to only perform the !csum_valid
check in udp_gro_receive() if uh->check is infact non-zero.

Before:

  [...]
  swapper     0 [008]   731.946506: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100400 len=1500   (1)
  swapper     0 [008]   731.946507: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100200 len=1500
  swapper     0 [008]   731.946507: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101100 len=1500
  swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101700 len=1500
  swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101b00 len=1500
  swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100600 len=1500
  swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100f00 len=1500
  swapper     0 [008]   731.946509: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100a00 len=1500
  swapper     0 [008]   731.946516: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100500 len=1500
  swapper     0 [008]   731.946516: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100700 len=1500
  swapper     0 [008]   731.946516: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101d00 len=1500   (2)
  swapper     0 [008]   731.946517: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101000 len=1500
  swapper     0 [008]   731.946517: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101c00 len=1500
  swapper     0 [008]   731.946517: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101400 len=1500
  swapper     0 [008]   731.946518: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100e00 len=1500
  swapper     0 [008]   731.946518: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101600 len=1500
  swapper     0 [008]   731.946521: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100800 len=774
  swapper     0 [008]   731.946530: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff966497100400 len=14032 (1)
  swapper     0 [008]   731.946530: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff966497101d00 len=9112  (2)
  [...]

  # netperf -H 10.55.10.4 -t TCP_STREAM -l 20
  MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.55.10.4 () port 0 AF_INET : demo
  Recv   Send    Send
  Socket Socket  Message  Elapsed
  Size   Size    Size     Time     Throughput
  bytes  bytes   bytes    secs.    10^6bits/sec

   87380  16384  16384    20.01    13129.24

After:

  [...]
  swapper     0 [026]   521.862641: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff93ab0d479000 len=11286 (1)
  swapper     0 [026]   521.862643: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff93ab0d479000 len=11236 (1)
  swapper     0 [026]   521.862650: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff93ab0d478500 len=2898  (2)
  swapper     0 [026]   521.862650: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff93ab0d479f00 len=8490  (3)
  swapper     0 [026]   521.862653: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff93ab0d478500 len=2848  (2)
  swapper     0 [026]   521.862653: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff93ab0d479f00 len=8440  (3)
  [...]

  # netperf -H 10.55.10.4 -t TCP_STREAM -l 20
  MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.55.10.4 () port 0 AF_INET : demo
  Recv   Send    Send
  Socket Socket  Message  Elapsed
  Size   Size    Size     Time     Throughput
  bytes  bytes   bytes    secs.    10^6bits/sec

   87380  16384  16384    20.01    24576.53

Fixes: 57c67ff4bd92 ("udp: additional GRO support")
Fixes: 662880f44203 ("net: Allow GRO to use and set levels of checksum unnecessary")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tom Herbert <tom@herbertland.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20210226212248.8300-1-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -359,7 +359,7 @@ struct sk_buff *udp_gro_receive(struct l
 	struct sock *sk;
 
 	if (NAPI_GRO_CB(skb)->encap_mark ||
-	    (skb->ip_summed != CHECKSUM_PARTIAL &&
+	    (uh->check && skb->ip_summed != CHECKSUM_PARTIAL &&
 	     NAPI_GRO_CB(skb)->csum_cnt == 0 &&
 	     !NAPI_GRO_CB(skb)->csum_valid))
 		goto out;



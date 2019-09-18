Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0481EB5C5F
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbfIRGZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbfIRGZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC0B921920;
        Wed, 18 Sep 2019 06:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787948;
        bh=pjvi5e0JD3oQ6w9n9LpfofgHo6x1NQIQAj2rtjbJ3U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ss39CC5DDXSCfeKeMivtaEhb7n1Sb3yNWkPPLhr6LEdOeEWwrdFrlqDGtL3P933fJ
         yoaOvAJMR/F8A8ijmBpE/X3427Q9tu5DX+d1GPPZJC+0qxOceS3h4LqfMfPhEM24OV
         met6tnEhVAXqUzPZ99uIJyBb9n2wKyF6OU8UzESg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 08/85] net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list
Date:   Wed, 18 Sep 2019 08:18:26 +0200
Message-Id: <20190918061234.392649861@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shmulik Ladkani <shmulik@metanetworks.com>

[ Upstream commit 3dcbdb134f329842a38f0e6797191b885ab00a00 ]

Historically, support for frag_list packets entering skb_segment() was
limited to frag_list members terminating on exact same gso_size
boundaries. This is verified with a BUG_ON since commit 89319d3801d1
("net: Add frag_list support to skb_segment"), quote:

    As such we require all frag_list members terminate on exact MSS
    boundaries.  This is checked using BUG_ON.
    As there should only be one producer in the kernel of such packets,
    namely GRO, this requirement should not be difficult to maintain.

However, since commit 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper"),
the "exact MSS boundaries" assumption no longer holds:
An eBPF program using bpf_skb_change_proto() DOES modify 'gso_size', but
leaves the frag_list members as originally merged by GRO with the
original 'gso_size'. Example of such programs are bpf-based NAT46 or
NAT64.

This lead to a kernel BUG_ON for flows involving:
 - GRO generating a frag_list skb
 - bpf program performing bpf_skb_change_proto() or bpf_skb_adjust_room()
 - skb_segment() of the skb

See example BUG_ON reports in [0].

In commit 13acc94eff12 ("net: permit skb_segment on head_frag frag_list skb"),
skb_segment() was modified to support the "gso_size mangling" case of
a frag_list GRO'ed skb, but *only* for frag_list members having
head_frag==true (having a page-fragment head).

Alas, GRO packets having frag_list members with a linear kmalloced head
(head_frag==false) still hit the BUG_ON.

This commit adds support to skb_segment() for a 'head_skb' packet having
a frag_list whose members are *non* head_frag, with gso_size mangled, by
disabling SG and thus falling-back to copying the data from the given
'head_skb' into the generated segmented skbs - as suggested by Willem de
Bruijn [1].

Since this approach involves the penalty of skb_copy_and_csum_bits()
when building the segments, care was taken in order to enable this
solution only when required:
 - untrusted gso_size, by testing SKB_GSO_DODGY is set
   (SKB_GSO_DODGY is set by any gso_size mangling functions in
    net/core/filter.c)
 - the frag_list is non empty, its item is a non head_frag, *and* the
   headlen of the given 'head_skb' does not match the gso_size.

[0]
https://lore.kernel.org/netdev/20190826170724.25ff616f@pixies/
https://lore.kernel.org/netdev/9265b93f-253d-6b8c-f2b8-4b54eff1835c@fb.com/

[1]
https://lore.kernel.org/netdev/CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com/

Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3531,6 +3531,25 @@ struct sk_buff *skb_segment(struct sk_bu
 	int pos;
 	int dummy;
 
+	if (list_skb && !list_skb->head_frag && skb_headlen(list_skb) &&
+	    (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
+		/* gso_size is untrusted, and we have a frag_list with a linear
+		 * non head_frag head.
+		 *
+		 * (we assume checking the first list_skb member suffices;
+		 * i.e if either of the list_skb members have non head_frag
+		 * head, then the first one has too).
+		 *
+		 * If head_skb's headlen does not fit requested gso_size, it
+		 * means that the frag_list members do NOT terminate on exact
+		 * gso_size boundaries. Hence we cannot perform skb_frag_t page
+		 * sharing. Therefore we must fallback to copying the frag_list
+		 * skbs; we do so by disabling SG.
+		 */
+		if (mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb))
+			features &= ~NETIF_F_SG;
+	}
+
 	__skb_push(head_skb, doffset);
 	proto = skb_network_protocol(head_skb, &dummy);
 	if (unlikely(!proto))



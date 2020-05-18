Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4561D867E
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgERRqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730138AbgERRqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:46:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0E9220835;
        Mon, 18 May 2020 17:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824011;
        bh=fhNrhicOFpTPi5d4hyZ4np9bnClrHaWnKQSRWxqvbFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GffhKS8V8P/qOwo5xBHYmYs+ZUSRXW6NIcsWsfdr+vg5LNSI+mileHYH8N1IqqTX
         cgGlqRy444AQWmIpNLZKvt6/PGsmK8vdISHyQ9e8T8awRhNLpL4RdZY3o+x+VuSyta
         rFHlxcLhnrxLpZ12xj/5hOD9OXrz3nYWjrYXbOOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 034/114] netfilter: nat: never update the UDP checksum when its 0
Date:   Mon, 18 May 2020 19:36:06 +0200
Message-Id: <20200518173509.806344582@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

commit ea64d8d6c675c0bb712689b13810301de9d8f77a upstream.

If the UDP header of a local VXLAN endpoint is NAT-ed, and the VXLAN
device has disabled UDP checksums and enabled Tx checksum offloading,
then the skb passed to udp_manip_pkt() has hdr->check == 0 (outer
checksum disabled) and skb->ip_summed == CHECKSUM_PARTIAL (inner packet
checksum offloaded).

Because of the ->ip_summed value, udp_manip_pkt() tries to update the
outer checksum with the new address and port, leading to an invalid
checksum sent on the wire, as the original null checksum obviously
didn't take the old address and port into account.

So, we can't take ->ip_summed into account in udp_manip_pkt(), as it
might not refer to the checksum we're acting on. Instead, we can base
the decision to update the UDP checksum entirely on the value of
hdr->check, because it's null if and only if checksum is disabled:

  * A fully computed checksum can't be 0, since a 0 checksum is
    represented by the CSUM_MANGLED_0 value instead.

  * A partial checksum can't be 0, since the pseudo-header always adds
    at least one non-zero value (the UDP protocol type 0x11) and adding
    more values to the sum can't make it wrap to 0 as the carry is then
    added to the wrapped number.

  * A disabled checksum uses the special value 0.

The problem seems to be there from day one, although it was probably
not visible before UDP tunnels were implemented.

Fixes: 5b1158e909ec ("[NETFILTER]: Add NAT support for nf_conntrack")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_nat_proto_udp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -66,15 +66,14 @@ static bool udp_manip_pkt(struct sk_buff
 			  enum nf_nat_manip_type maniptype)
 {
 	struct udphdr *hdr;
-	bool do_csum;
 
 	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct udphdr *)(skb->data + hdroff);
-	do_csum = hdr->check || skb->ip_summed == CHECKSUM_PARTIAL;
+	__udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple, maniptype,
+			!!hdr->check);
 
-	__udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple, maniptype, do_csum);
 	return true;
 }
 



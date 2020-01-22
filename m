Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F83814558B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgAVNW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:22:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729684AbgAVNW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:22:57 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 316B2205F4;
        Wed, 22 Jan 2020 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699376;
        bh=R8KT5YGmVyoPusaE0r+tLHjj6hxgkWh7X1mbviexcg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNsVAo2hMbxVB3FT9DWmR7D1sfM+LU2Db6GVWo6Oas0A4e9gEgkGpWXIaL7DaADGg
         r+V9N+S9/AtsyAppz5TXS6n2sZ+toMU8hFxkekwxPUmgT33/v/EOxVqkrBD53FPfZc
         zpRtoFXPAWW87P5JQhiH6xfea4qrmC6YjIjXjT2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 126/222] netfilter: nat: fix ICMP header corruption on ICMP errors
Date:   Wed, 22 Jan 2020 10:28:32 +0100
Message-Id: <20200122092842.772441253@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

commit 61177e911dad660df86a4553eb01c95ece2f6a82 upstream.

Commit 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
made nf_nat_icmp_reply_translation() use icmp_manip_pkt() as the l4
manipulation function for the outer packet on ICMP errors.

However, icmp_manip_pkt() assumes the packet has an 'id' field which
is not correct for all types of ICMP messages.

This is not correct for ICMP error packets, and leads to bogus bytes
being written the ICMP header, which can be wrongfully regarded as
'length' bytes by RFC 4884 compliant receivers.

Fix by assigning the 'id' field only for ICMP messages that have this
semantic.

Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Fixes: 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_nat_proto.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -233,6 +233,19 @@ icmp_manip_pkt(struct sk_buff *skb,
 		return false;
 
 	hdr = (struct icmphdr *)(skb->data + hdroff);
+	switch (hdr->type) {
+	case ICMP_ECHO:
+	case ICMP_ECHOREPLY:
+	case ICMP_TIMESTAMP:
+	case ICMP_TIMESTAMPREPLY:
+	case ICMP_INFO_REQUEST:
+	case ICMP_INFO_REPLY:
+	case ICMP_ADDRESS:
+	case ICMP_ADDRESSREPLY:
+		break;
+	default:
+		return true;
+	}
 	inet_proto_csum_replace2(&hdr->checksum, skb,
 				 hdr->un.echo.id, tuple->src.u.icmp.id, false);
 	hdr->un.echo.id = tuple->src.u.icmp.id;



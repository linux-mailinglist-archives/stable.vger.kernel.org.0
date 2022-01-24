Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F1B498F2A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbiAXTvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58832 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354971AbiAXTjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:39:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2937B811F9;
        Mon, 24 Jan 2022 19:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC917C340E5;
        Mon, 24 Jan 2022 19:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053183;
        bh=CK8CAGzGy8qPTGEr4D6PkQuiYvHfHcCmfKy/o/TGUVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g433rv54Lkl4y4ZKCr8WauNaX4q2w8dOxSJa4PSJ5z3mdkwFXMnubUvma3Wz4Anik
         cneYWhFHrrFpzFyEobXGvGarz0TXVgQE9FUKXH9+yMOcYeSiJjGaMYETwijIOxWu89
         62iViTFL3Pi3cDzCPADi8HSI8pM1fpQiALMG84Bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 302/320] gre: Dont accidentally set RTO_ONLINK in gre_fill_metadata_dst()
Date:   Mon, 24 Jan 2022 19:44:46 +0100
Message-Id: <20220124184004.225139699@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

commit f7716b318568b22fbf0e3be99279a979e217cf71 upstream.

Mask the ECN bits before initialising ->flowi4_tos. The tunnel key may
have the last ECN bit set, which will interfere with the route lookup
process as ip_route_output_key_hash() interpretes this bit specially
(to restrict the route scope).

Found by code inspection, compile tested only.

Fixes: 962924fa2b7a ("ip_gre: Refactor collect metatdata mode tunnel xmit to ip_md_tunnel_xmit")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -577,8 +577,9 @@ static int gre_fill_metadata_dst(struct
 
 	key = &info->key;
 	ip_tunnel_init_flow(&fl4, IPPROTO_GRE, key->u.ipv4.dst, key->u.ipv4.src,
-			    tunnel_id_to_key32(key->tun_id), key->tos, 0,
-			    skb->mark, skb_get_hash(skb));
+			    tunnel_id_to_key32(key->tun_id),
+			    key->tos & ~INET_ECN_MASK, 0, skb->mark,
+			    skb_get_hash(skb));
 	rt = ip_route_output_key(dev_net(dev), &fl4);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);



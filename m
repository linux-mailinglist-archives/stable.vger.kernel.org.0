Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C063E4999AE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455962AbiAXVg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390833AbiAXVM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:12:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22627C02980A;
        Mon, 24 Jan 2022 12:09:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B834F60916;
        Mon, 24 Jan 2022 20:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CDEC340E5;
        Mon, 24 Jan 2022 20:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054984;
        bh=M8qBtgq4qnULWEmvL4y24IHRUUiDZqfTZBrg8l7jr4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bj+w5kLZbwakC5gbTVZfw5u8orir+1b2SCCwEMmRCuH+Z+HWzUmUDfOivk79xVqWU
         pt7vKeXEcPpmNybsroqteQxxc2P0/gTP2aura6PJBzmPs0AX1U9g9kKdOKM9+01Tl9
         jUflmHXFt5QW8PtgxsbyTbq2xp1j6VZ+2Tng4WPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 537/563] gre: Dont accidentally set RTO_ONLINK in gre_fill_metadata_dst()
Date:   Mon, 24 Jan 2022 19:45:02 +0100
Message-Id: <20220124184043.010103713@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -599,8 +599,9 @@ static int gre_fill_metadata_dst(struct
 
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



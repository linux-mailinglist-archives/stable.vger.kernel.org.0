Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E19E499BA1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575216AbiAXVvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59280 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458117AbiAXVmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ADE76146A;
        Mon, 24 Jan 2022 21:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1618C340E4;
        Mon, 24 Jan 2022 21:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060565;
        bh=HMgHsusz66jvKUn2q1i3T3oRyyk+TIy9VI2jBQLzg/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsXUEg5Z5zTxBRQhKox9l0VoJyq3XKxX+Z/oPLkfO3PovbqouYYvFY8AkaMJkuJkj
         6b5Z0jRIokp+BR7+SGPyYqPEuy6rpGZTShd50p5NWrKNVyC8yx6bo31DsY4EkIkxe+
         uEyvXh1Mfff6aEE+KfxcqMugX1btaCUQfLk6Eesc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 0991/1039] gre: Dont accidentally set RTO_ONLINK in gre_fill_metadata_dst()
Date:   Mon, 24 Jan 2022 19:46:20 +0100
Message-Id: <20220124184158.599754506@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -604,8 +604,9 @@ static int gre_fill_metadata_dst(struct
 
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



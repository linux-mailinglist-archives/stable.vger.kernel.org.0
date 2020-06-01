Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E155B1EAEE0
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgFAS5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728965AbgFAR7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:59:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D69002074B;
        Mon,  1 Jun 2020 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034378;
        bh=cYxn46v7Fp+VUDknXWc2HELPE8i0Sn7JqZLgXwySOm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZ2YOW9HS9aBnRFt6I2ow0P6KavStr1Er+zBDKv3MXJFw6HYbIsNnHVDZIaw1mEhd
         EqQvHhEwmEKTfMRhy1kL5/4u1IW+tX7NnCaDe3lOwAL4Mc+gA4SBxtBhcfwcIarDgg
         TfQYklJBMfBTkCwTHb2AYg/+7f0bmoYpq2QcSjsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Braun <michael-dev@fami-braun.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.9 50/61] netfilter: nft_reject_bridge: enable reject with bridge vlan
Date:   Mon,  1 Jun 2020 19:53:57 +0200
Message-Id: <20200601174020.710706353@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Braun <michael-dev@fami-braun.de>

commit e9c284ec4b41c827f4369973d2792992849e4fa5 upstream.

Currently, using the bridge reject target with tagged packets
results in untagged packets being sent back.

Fix this by mirroring the vlan id as well.

Fixes: 85f5b3086a04 ("netfilter: bridge: add reject support")
Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bridge/netfilter/nft_reject_bridge.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -34,6 +34,12 @@ static void nft_reject_br_push_etherhdr(
 	ether_addr_copy(eth->h_dest, eth_hdr(oldskb)->h_source);
 	eth->h_proto = eth_hdr(oldskb)->h_proto;
 	skb_pull(nskb, ETH_HLEN);
+
+	if (skb_vlan_tag_present(oldskb)) {
+		u16 vid = skb_vlan_tag_get(oldskb);
+
+		__vlan_hwaccel_put_tag(nskb, oldskb->vlan_proto, vid);
+	}
 }
 
 static int nft_bridge_iphdr_validate(struct sk_buff *skb)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520401EAAB0
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgFASKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730993AbgFASK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:10:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44D1A207BB;
        Mon,  1 Jun 2020 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035028;
        bh=Syz0oJeLENcBeZiJymoRK63ZsyGJDQbC94aTQ556b6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNhPwIanmK5N7XWTWTy39Pok9nguvKuVNH+vnrnHhJLsaWX1Y/Y9375KhReOGrKxU
         F8n4rrATQPh9u7n/DevVqOUShOZ1+G/ahuGp19ZCYASmLBoQXxk8BH4ZNpq83JseoP
         SKqDCZZYzVVDU59DtoUkGIMfkK5UJmSxXoO0yqbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Braun <michael-dev@fami-braun.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 121/142] netfilter: nft_reject_bridge: enable reject with bridge vlan
Date:   Mon,  1 Jun 2020 19:54:39 +0200
Message-Id: <20200601174050.333572615@linuxfoundation.org>
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
@@ -31,6 +31,12 @@ static void nft_reject_br_push_etherhdr(
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



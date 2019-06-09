Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B373A934
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388825AbfFIRFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388423AbfFIRFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2B0206C3;
        Sun,  9 Jun 2019 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099932;
        bh=agtC4ZKvCXiD09LkBMOirdyQMeA1+xMR2WblZ6cln/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzuPRQ5AJ/yXofeY7PP955+uY+22mwbtZVGC1otRz22wgfKaBSY7iLVayW2G1b9fG
         vawXLPQQvYWhgC7/KlPFDeafWFpo+FgTeN5BhAKkA2uRthUHqDtkF/kRozodYsxkF3
         dJ/O981aMd+FOwRjts1rW/Dcrmklu5sCc14amI+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Axtens <dja@axtens.net>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 217/241] bnx2x: disable GSO where gso_size is too big for hardware
Date:   Sun,  9 Jun 2019 18:42:39 +0200
Message-Id: <20190609164154.935768309@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

commit 8914a595110a6eca69a5e275b323f5d09e18f4f9 upstream.

If a bnx2x card is passed a GSO packet with a gso_size larger than
~9700 bytes, it will cause a firmware error that will bring the card
down:

bnx2x: [bnx2x_attn_int_deasserted3:4323(enP24p1s0f0)]MC assert!
bnx2x: [bnx2x_mc_assert:720(enP24p1s0f0)]XSTORM_ASSERT_LIST_INDEX 0x2
bnx2x: [bnx2x_mc_assert:736(enP24p1s0f0)]XSTORM_ASSERT_INDEX 0x0 = 0x00000000 0x25e43e47 0x00463e01 0x00010052
bnx2x: [bnx2x_mc_assert:750(enP24p1s0f0)]Chip Revision: everest3, FW Version: 7_13_1
... (dump of values continues) ...

Detect when the mac length of a GSO packet is greater than the maximum
packet size (9700 bytes) and disable GSO.

Signed-off-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12824,6 +12824,24 @@ static netdev_features_t bnx2x_features_
 					      struct net_device *dev,
 					      netdev_features_t features)
 {
+	/*
+	 * A skb with gso_size + header length > 9700 will cause a
+	 * firmware panic. Drop GSO support.
+	 *
+	 * Eventually the upper layer should not pass these packets down.
+	 *
+	 * For speed, if the gso_size is <= 9000, assume there will
+	 * not be 700 bytes of headers and pass it through. Only do a
+	 * full (slow) validation if the gso_size is > 9000.
+	 *
+	 * (Due to the way SKB_BY_FRAGS works this will also do a full
+	 * validation in that case.)
+	 */
+	if (unlikely(skb_is_gso(skb) &&
+		     (skb_shinfo(skb)->gso_size > 9000) &&
+		     !skb_gso_validate_mac_len(skb, 9700)))
+		features &= ~NETIF_F_GSO_MASK;
+
 	features = vlan_features_check(skb, features);
 	return vxlan_features_check(skb, features);
 }



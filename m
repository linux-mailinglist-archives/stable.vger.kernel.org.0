Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8942B6461
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732843AbgKQNq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732465AbgKQNhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF410207BC;
        Tue, 17 Nov 2020 13:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620231;
        bh=Bo6lZWNbdN0XvnUOgMmstIab24GXFOSeNseYs0p7vpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJ2horVWYjQT4SramI7tcktxj0BCWwqpnZKg//j9/kmhGe1ylOmlQQk9CABhtTUJ7
         ZF2O/2XVxsrPYHiNjp1pZDP6bJerd0LJ3lcJHRY5Vw00YcWc+xD6FrA8BZ/w2hAkWW
         67ZXWnDVMCkcWjD+OOGmR2J+VRoQFiq+WPrtzkY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 149/255] r8169: disable hw csum for short packets on all chip versions
Date:   Tue, 17 Nov 2020 14:04:49 +0100
Message-Id: <20201117122146.216001243@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 847f0a2bfd2fe16d6afa537816b313b71f32e139 ]

RTL8125B has same or similar short packet hw padding bug as RTL8168evl.
The main workaround has been extended accordingly, however we have to
disable also hw checksumming for short packets on affected new chip
versions. Instead of checking for an affected chip version let's
simply disable hw checksumming for short packets in general.

v2:
- remove the version checks and disable short packet hw csum in general
- reflect this in commit title and message

Fixes: 0439297be951 ("r8169: add support for RTL8125B")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/7fbb35f0-e244-ef65-aa55-3872d7d38698@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ed918c12bc5e9..515d9116dfadf 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4325,18 +4325,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_ALL_TSO;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		if (skb->len < ETH_ZLEN) {
-			switch (tp->mac_version) {
-			case RTL_GIGA_MAC_VER_11:
-			case RTL_GIGA_MAC_VER_12:
-			case RTL_GIGA_MAC_VER_17:
-			case RTL_GIGA_MAC_VER_34:
-				features &= ~NETIF_F_CSUM_MASK;
-				break;
-			default:
-				break;
-			}
-		}
+		/* work around hw bug on some chip versions */
+		if (skb->len < ETH_ZLEN)
+			features &= ~NETIF_F_CSUM_MASK;
 
 		if (transport_offset > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-- 
2.27.0




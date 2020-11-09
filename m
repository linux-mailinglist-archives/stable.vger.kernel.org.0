Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADE22ABAFC
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730838AbgKINRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387593AbgKINR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 119CD20663;
        Mon,  9 Nov 2020 13:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927847;
        bh=QDFkm0gxOacetAyrSz9fzEFKHw5t+Ijq/wIQJ+oKyTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMxROdqjMfGcqNjtgQECufvDYwUvOhl9NstuxU2FipP3YRAKOxVL2DtOJYna5ZJ1D
         TT47rtv+yGiifZPHc3V/jkkMq0sXcFc5b2GIFDfJ+pL5I35mkg7QaunsIu6EdO8u4J
         lJeLv3Z35dYZKMET8iRbgVKu4Mv+zurn8BdWeSvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Plotnikov <wgh@torlan.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 042/133] r8169: work around short packet hw bug on RTL8125
Date:   Mon,  9 Nov 2020 13:55:04 +0100
Message-Id: <20201109125032.736665606@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 2aaf09a0e7842b3ac7be6e0b8fb1888b3daeb3b3 ]

Network problems with RTL8125B have been reported [0] and with help
from Realtek it turned out that this chip version has a hw problem
with short packets (similar to RTL8168evl). Having said that activate
the same workaround as for RTL8168evl.
Realtek suggested to activate the workaround for RTL8125A too, even
though they're not 100% sure yet which RTL8125 versions are affected.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=209839

Fixes: 0439297be951 ("r8169: add support for RTL8125B")
Reported-by: Maxim Plotnikov <wgh@torlan.ru>
Tested-by: Maxim Plotnikov <wgh@torlan.ru>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/8002c31a-60b9-58f1-f0dd-8fd07239917f@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4062,9 +4062,17 @@ err_out:
 	return -EIO;
 }
 
-static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp, struct sk_buff *skb)
+static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
 {
-	return skb->len < ETH_ZLEN && tp->mac_version == RTL_GIGA_MAC_VER_34;
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_60:
+	case RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_63:
+		return true;
+	default:
+		return false;
+	}
 }
 
 static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
@@ -4136,7 +4144,7 @@ static bool rtl8169_tso_csum_v2(struct r
 
 		opts[1] |= transport_offset << TCPHO_SHIFT;
 	} else {
-		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
+		if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
 			return !eth_skb_pad(skb);
 	}
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020563137B4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhBHP3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233708AbhBHPZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 011D964EB4;
        Mon,  8 Feb 2021 15:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797306;
        bh=wA9KRhJVZTzHR+gvrGKRdjbLEmUZgcnlTvuHyd/FLhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWnrtAt++K7gnl9h58fl5swtT195fL0Vnk6yfofU5FQQh8jO7BdwTkCM2rBKJo4ir
         Xzp3woBemmTJUsguE8lMS1/4dNrHrAmOVOuwC3AR6OVUtpUz8MtG2C4lQGcSs59eSc
         LWy50RgzJEQt9KTG0sjOCBQIXDVP6cgcTO6jN5mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xplo <xplo.bn@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/120] r8169: work around RTL8125 UDP hw bug
Date:   Mon,  8 Feb 2021 16:00:19 +0100
Message-Id: <20210208145819.668308931@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 8d520b4de3edca4f4fb242b5ddc659b6a9b9e65e ]

It was reported that on RTL8125 network breaks under heavy UDP load,
e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
and provided me with a test version of the r8125 driver including a
workaround. Tests confirmed that the workaround fixes the issue.
I modified the original version of the workaround to meet mainline
code style.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=209839

v2:
- rebased to net
v3:
- make rtl_skb_is_udp() more robust and use skb_header_pointer()
  to access the ip(v6) header
v4:
- remove dependency on ptp_classify.h
- replace magic number with offsetof(struct udphdr, len)

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Tested-by: xplo <xplo.bn@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/6e453d49-1801-e6de-d5f7-d7e6c7526c8f@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 71 +++++++++++++++++++++--
 1 file changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 762cabf16157b..64b77d415a525 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4082,17 +4082,72 @@ err_out:
 	return -EIO;
 }
 
-static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
+static bool rtl_skb_is_udp(struct sk_buff *skb)
+{
+	int no = skb_network_offset(skb);
+	struct ipv6hdr *i6h, _i6h;
+	struct iphdr *ih, _ih;
+
+	switch (vlan_get_protocol(skb)) {
+	case htons(ETH_P_IP):
+		ih = skb_header_pointer(skb, no, sizeof(_ih), &_ih);
+		return ih && ih->protocol == IPPROTO_UDP;
+	case htons(ETH_P_IPV6):
+		i6h = skb_header_pointer(skb, no, sizeof(_i6h), &_i6h);
+		return i6h && i6h->nexthdr == IPPROTO_UDP;
+	default:
+		return false;
+	}
+}
+
+#define RTL_MIN_PATCH_LEN	47
+
+/* see rtl8125_get_patch_pad_len() in r8125 vendor driver */
+static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
+					    struct sk_buff *skb)
 {
+	unsigned int padto = 0, len = skb->len;
+
+	if (rtl_is_8125(tp) && len < 128 + RTL_MIN_PATCH_LEN &&
+	    rtl_skb_is_udp(skb) && skb_transport_header_was_set(skb)) {
+		unsigned int trans_data_len = skb_tail_pointer(skb) -
+					      skb_transport_header(skb);
+
+		if (trans_data_len >= offsetof(struct udphdr, len) &&
+		    trans_data_len < RTL_MIN_PATCH_LEN) {
+			u16 dest = ntohs(udp_hdr(skb)->dest);
+
+			/* dest is a standard PTP port */
+			if (dest == 319 || dest == 320)
+				padto = len + RTL_MIN_PATCH_LEN - trans_data_len;
+		}
+
+		if (trans_data_len < sizeof(struct udphdr))
+			padto = max_t(unsigned int, padto,
+				      len + sizeof(struct udphdr) - trans_data_len);
+	}
+
+	return padto;
+}
+
+static unsigned int rtl_quirk_packet_padto(struct rtl8169_private *tp,
+					   struct sk_buff *skb)
+{
+	unsigned int padto;
+
+	padto = rtl8125_quirk_udp_padto(tp, skb);
+
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_60:
 	case RTL_GIGA_MAC_VER_61:
 	case RTL_GIGA_MAC_VER_63:
-		return true;
+		padto = max_t(unsigned int, padto, ETH_ZLEN);
 	default:
-		return false;
+		break;
 	}
+
+	return padto;
 }
 
 static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
@@ -4164,9 +4219,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 
 		opts[1] |= transport_offset << TCPHO_SHIFT;
 	} else {
-		if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
-			/* eth_skb_pad would free the skb on error */
-			return !__skb_put_padto(skb, ETH_ZLEN, false);
+		unsigned int padto = rtl_quirk_packet_padto(tp, skb);
+
+		/* skb_padto would free the skb on error */
+		return !__skb_put_padto(skb, padto, false);
 	}
 
 	return true;
@@ -4349,6 +4405,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 		if (skb->len < ETH_ZLEN)
 			features &= ~NETIF_F_CSUM_MASK;
 
+		if (rtl_quirk_packet_padto(tp, skb))
+			features &= ~NETIF_F_CSUM_MASK;
+
 		if (transport_offset > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_CSUM_MASK;
-- 
2.27.0




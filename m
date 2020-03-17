Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 510F7188ECD
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 21:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgCQUQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 16:16:05 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49646 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQUQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 16:16:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584476163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVazEPyoe+3MVtpcuGHsDTVBdX4mvnd1+w/GldSKDPI=;
        b=0vPhChPwBsm+8oI3p8DIIxcFrfjGHMkwqssdFmeSNvNqeRT2rTcKapdikybicJ/jSW2tJN
        hLgibsouBOyfqSMcqJVk2Xgd4FxsucOnSpd7IxgdCB1rWUaRZCKyqMTlVDuokojFRT/NEb
        +A64ap8ou6mrCdCSLZvwtHEIr8zyUjk=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 3/3] batman-adv: Use explicit tvlv padding for ELP packets
Date:   Tue, 17 Mar 2020 21:15:40 +0100
Message-Id: <20200317201540.23496-4-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317201540.23496-1-sven@narfation.org>
References: <20200317201540.23496-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f4156f9656feac21f4de712fac94fae964c5d402 upstream.

The announcement messages of batman-adv COMPAT_VERSION 15 have the
possibility to announce additional information via a dynamic TVLV part.
This part is optional for the ELP packets and currently not parsed by the
Linux implementation. Still out-of-tree versions are using it to transport
things like neighbor hashes to optimize the rebroadcast behavior.

Since the ELP broadcast packets are smaller than the minimal ethernet
packet, it often has to be padded. This is often done (as specified in
RFC894) with octets of zero and thus work perfectly fine with the TVLV
part (making it a zero length and thus empty). But not all ethernet
compatible hardware seems to follow this advice. To avoid ambiguous
situations when parsing the TVLV header, just force the 4 bytes (TVLV
length + padding) after the required ELP header to zero.

Fixes: d6f94d91f766 ("batman-adv: ELP - adding basic infrastructure")
Reported-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_v_elp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 11e1a28ff526..62df763b2aae 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -335,21 +335,23 @@ static void batadv_v_elp_periodic_work(struct work_struct *work)
  */
 int batadv_v_elp_iface_enable(struct batadv_hard_iface *hard_iface)
 {
+	static const size_t tvlv_padding = sizeof(__be32);
 	struct batadv_elp_packet *elp_packet;
 	unsigned char *elp_buff;
 	u32 random_seqno;
 	size_t size;
 	int res = -ENOMEM;
 
-	size = ETH_HLEN + NET_IP_ALIGN + BATADV_ELP_HLEN;
+	size = ETH_HLEN + NET_IP_ALIGN + BATADV_ELP_HLEN + tvlv_padding;
 	hard_iface->bat_v.elp_skb = dev_alloc_skb(size);
 	if (!hard_iface->bat_v.elp_skb)
 		goto out;
 
 	skb_reserve(hard_iface->bat_v.elp_skb, ETH_HLEN + NET_IP_ALIGN);
-	elp_buff = skb_put(hard_iface->bat_v.elp_skb, BATADV_ELP_HLEN);
+	elp_buff = skb_put(hard_iface->bat_v.elp_skb,
+			   BATADV_ELP_HLEN + tvlv_padding);
 	elp_packet = (struct batadv_elp_packet *)elp_buff;
-	memset(elp_packet, 0, BATADV_ELP_HLEN);
+	memset(elp_packet, 0, BATADV_ELP_HLEN + tvlv_padding);
 
 	elp_packet->packet_type = BATADV_ELP;
 	elp_packet->version = BATADV_COMPAT_VERSION;
-- 
2.20.1


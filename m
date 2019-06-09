Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9AB3A935
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388216AbfFIRFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388831AbfFIRFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7011020843;
        Sun,  9 Jun 2019 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099929;
        bh=yypGrqrxjEQ7y+K2xAwxm4B2ziaK9OEcEM3gMtFVeXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWvcYZqa9EsjE1xDBgU7486y1dPO+5CCZf2WsoNmc4H5kTewDIVYYCsHqPXaaIT7Y
         SziZwkEMI9+U3kYlyeE9x9qUes/Tk2HNNQl8nsDozJgXuQrGcdpkGBq85z0m/Pk9lH
         0GwPJTtHP4lzNSTsqEIokru2a0qM9ZnbHNfvwmeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Axtens <dja@axtens.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 216/241] net: create skb_gso_validate_mac_len()
Date:   Sun,  9 Jun 2019 18:42:38 +0200
Message-Id: <20190609164154.908348867@linuxfoundation.org>
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

commit 2b16f048729bf35e6c28a40cbfad07239f9dcd90 upstream.

If you take a GSO skb, and split it into packets, will the MAC
length (L2 + L3 + L4 headers + payload) of those packets be small
enough to fit within a given length?

Move skb_gso_mac_seglen() to skbuff.h with other related functions
like skb_gso_network_seglen() so we can use it, and then create
skb_gso_validate_mac_len to do the full calculation.

Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 4.4: There is no GSO_BY_FRAGS case to handle, so
 skb_gso_validate_mac_len() becomes a trivial comparison. Put it inline in
 <linux/skbuff.h>.]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |   30 ++++++++++++++++++++++++++++++
 net/sched/sch_tbf.c    |   10 ----------
 2 files changed, 30 insertions(+), 10 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3664,5 +3664,35 @@ static inline unsigned int skb_gso_netwo
 	return hdr_len + skb_gso_transport_seglen(skb);
 }
 
+/**
+ * skb_gso_mac_seglen - Return length of individual segments of a gso packet
+ *
+ * @skb: GSO skb
+ *
+ * skb_gso_mac_seglen is used to determine the real size of the
+ * individual segments, including MAC/L2, Layer3 (IP, IPv6) and L4
+ * headers (TCP/UDP).
+ */
+static inline unsigned int skb_gso_mac_seglen(const struct sk_buff *skb)
+{
+	unsigned int hdr_len = skb_transport_header(skb) - skb_mac_header(skb);
+	return hdr_len + skb_gso_transport_seglen(skb);
+}
+
+/**
+ * skb_gso_validate_mac_len - Will a split GSO skb fit in a given length?
+ *
+ * @skb: GSO skb
+ * @len: length to validate against
+ *
+ * skb_gso_validate_mac_len validates if a given skb will fit a wanted
+ * length once split, including L2, L3 and L4 headers and the payload.
+ */
+static inline bool
+skb_gso_validate_mac_len(const struct sk_buff *skb, unsigned int len)
+{
+	return skb_gso_mac_seglen(skb) <= len;
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -142,16 +142,6 @@ static u64 psched_ns_t2l(const struct ps
 	return len;
 }
 
-/*
- * Return length of individual segments of a gso packet,
- * including all headers (MAC, IP, TCP/UDP)
- */
-static unsigned int skb_gso_mac_seglen(const struct sk_buff *skb)
-{
-	unsigned int hdr_len = skb_transport_header(skb) - skb_mac_header(skb);
-	return hdr_len + skb_gso_transport_seglen(skb);
-}
-
 /* GSO packet is too big, segment it so that tbf can transmit
  * each segment in time
  */



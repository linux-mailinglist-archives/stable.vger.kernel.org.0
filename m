Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FB35869D8
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbiHAMIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiHAMHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:07:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F285F135;
        Mon,  1 Aug 2022 04:55:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25FBBB8117D;
        Mon,  1 Aug 2022 11:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75ADDC43142;
        Mon,  1 Aug 2022 11:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354928;
        bh=QMw995bFN4btZZcVAz0aVohWTc+76L26YjLiWXMto/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XV+bDg4zYLEO+rOGKly/t+brWwA9WwJ0eZQ//1AIAK7evx6oKdzUF3ScbIQNH1EOI
         XfoscSvAnd5NbRhz9nC2xh+bt09n90gS1aIc4baWjntI88N193ffeAXF7ipU/qyHvS
         VRDtR7H9vcsCWhLGfRpVWgYXuzhC3yd6LPxaSA3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/69] macsec: limit replay window size with XPN
Date:   Mon,  1 Aug 2022 13:47:07 +0200
Message-Id: <20220801114136.220910073@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit b07a0e2044057f201d694ab474f5c42a02b6465b ]

IEEE 802.1AEbw-2013 (section 10.7.8) specifies that the maximum value
of the replay window is 2^30-1, to help with recovery of the upper
bits of the PN.

To avoid leaving the existing macsec device in an inconsistent state
if this test fails during changelink, reuse the cleanup mechanism
introduced for HW offload. This wasn't needed until now because
macsec_changelink_common could not fail during changelink, as
modifying the cipher suite was not allowed.

Finally, this must happen after handling IFLA_MACSEC_CIPHER_SUITE so
that secy->xpn is set.

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 9ede0d7cd0b5..1f2eb576533c 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -241,6 +241,7 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 #define DEFAULT_SEND_SCI true
 #define DEFAULT_ENCRYPT false
 #define DEFAULT_ENCODING_SA 0
+#define MACSEC_XPN_MAX_REPLAY_WINDOW (((1 << 30) - 1))
 
 static bool send_sci(const struct macsec_secy *secy)
 {
@@ -3739,9 +3740,6 @@ static int macsec_changelink_common(struct net_device *dev,
 		secy->operational = tx_sa && tx_sa->active;
 	}
 
-	if (data[IFLA_MACSEC_WINDOW])
-		secy->replay_window = nla_get_u32(data[IFLA_MACSEC_WINDOW]);
-
 	if (data[IFLA_MACSEC_ENCRYPT])
 		tx_sc->encrypt = !!nla_get_u8(data[IFLA_MACSEC_ENCRYPT]);
 
@@ -3787,6 +3785,16 @@ static int macsec_changelink_common(struct net_device *dev,
 		}
 	}
 
+	if (data[IFLA_MACSEC_WINDOW]) {
+		secy->replay_window = nla_get_u32(data[IFLA_MACSEC_WINDOW]);
+
+		/* IEEE 802.1AEbw-2013 10.7.8 - maximum replay window
+		 * for XPN cipher suites */
+		if (secy->xpn &&
+		    secy->replay_window > MACSEC_XPN_MAX_REPLAY_WINDOW)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -3816,7 +3824,7 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	ret = macsec_changelink_common(dev, data);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
-- 
2.35.1




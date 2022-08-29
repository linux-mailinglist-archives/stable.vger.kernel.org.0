Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDD95A48EF
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiH2LRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiH2LRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:17:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4276C133;
        Mon, 29 Aug 2022 04:11:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88048B80FA3;
        Mon, 29 Aug 2022 11:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6487C433D6;
        Mon, 29 Aug 2022 11:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771338;
        bh=+9wM4QlZB+oC1gAupTb1i7MvWaWUDZZLNPUsZ5YiG+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rydlBiuvl1lNCA8TInV5ySVDq9hoJsxl5MlCUsq3JLZ2aEgGjSibPDrBBjo/tWUny
         JApoSrVIH7xPD5AI8zeSJPSALz/XED8Nkv8GDDnqzXZ53PjCBKbxEEcbhQJQJgOadG
         w8CQzE+k/hTw0w9woRBm3zy0lRr469w6owez3T18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 018/158] Revert "net: macsec: update SCI upon MAC address change."
Date:   Mon, 29 Aug 2022 12:57:48 +0200
Message-Id: <20220829105809.581648514@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit e82c649e851c9c25367fb7a2a6cf3479187de467 ]

This reverts commit 6fc498bc82929ee23aa2f35a828c6178dfd3f823.

Commit 6fc498bc8292 states:

    SCI should be updated, because it contains MAC in its first 6
    octets.

That's not entirely correct. The SCI can be based on the MAC address,
but doesn't have to be. We can also use any 64-bit number as the
SCI. When the SCI based on the MAC address, it uses a 16-bit "port
number" provided by userspace, which commit 6fc498bc8292 overwrites
with 1.

In addition, changing the SCI after macsec has been setup can just
confuse the receiver. If we configure the RXSC on the peer based on
the original SCI, we should keep the same SCI on TX.

When the macsec device is being managed by a userspace key negotiation
daemon such as wpa_supplicant, commit 6fc498bc8292 would also
overwrite the SCI defined by userspace.

Fixes: 6fc498bc8292 ("net: macsec: update SCI upon MAC address change.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/9b1a9d28327e7eb54550a92eebda45d25e54dd0d.1660667033.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f354fad05714a..5b0b23e55fa76 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -449,11 +449,6 @@ static struct macsec_eth_header *macsec_ethhdr(struct sk_buff *skb)
 	return (struct macsec_eth_header *)skb_mac_header(skb);
 }
 
-static sci_t dev_to_sci(struct net_device *dev, __be16 port)
-{
-	return make_sci(dev->dev_addr, port);
-}
-
 static void __macsec_pn_wrapped(struct macsec_secy *secy,
 				struct macsec_tx_sa *tx_sa)
 {
@@ -3622,7 +3617,6 @@ static int macsec_set_mac_address(struct net_device *dev, void *p)
 
 out:
 	eth_hw_addr_set(dev, addr->sa_data);
-	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
 
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
@@ -3960,6 +3954,11 @@ static bool sci_exists(struct net_device *dev, sci_t sci)
 	return false;
 }
 
+static sci_t dev_to_sci(struct net_device *dev, __be16 port)
+{
+	return make_sci(dev->dev_addr, port);
+}
+
 static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
-- 
2.35.1




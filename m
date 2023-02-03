Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975CE6895DE
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjBCKTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbjBCKS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:18:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34343CE17
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2602B82A65
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3C6C433EF;
        Fri,  3 Feb 2023 10:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419490;
        bh=UhGxtUE5T7Qh2eWf8jlSfRYtqy22NUX7bhDbzVPkb4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgMR/5qoKrF7vz0I/89OgMgr6nh8ZwqVbsYFvOtFJ/wr2S4hvHK3NH1orIWhhDS+m
         rXYWNxzuX8xafUBFkiDHxkRRIDAvNTMFwYBGDqDDpgYAO0sxJJ3oRgLv2eMrp/xNg6
         IyHNUqhuSX2Afku1Lh5ZJXdzgoa9ZwjsoTjlMDAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Robert Hancock <robert.hancock@calian.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/80] net: macb: fix PTP TX timestamp failure due to packet padding
Date:   Fri,  3 Feb 2023 11:12:17 +0100
Message-Id: <20230203101016.181404208@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 7b90f5a665acd46efbbfa677a3a3a18d01ad6487 ]

PTP TX timestamp handling was observed to be broken with this driver
when using the raw Layer 2 PTP encapsulation. ptp4l was not receiving
the expected TX timestamp after transmitting a packet, causing it to
enter a failure state.

The problem appears to be due to the way that the driver pads packets
which are smaller than the Ethernet minimum of 60 bytes. If headroom
space was available in the SKB, this caused the driver to move the data
back to utilize it. However, this appears to cause other data references
in the SKB to become inconsistent. In particular, this caused the
ptp_one_step_sync function to later (in the TX completion path) falsely
detect the packet as a one-step SYNC packet, even when it was not, which
caused the TX timestamp to not be processed when it should be.

Using the headroom for this purpose seems like an unnecessary complexity
as this is not a hot path in the driver, and in most cases it appears
that there is sufficient tailroom to not require using the headroom
anyway. Remove this usage of headroom to prevent this inconsistency from
occurring and causing other problems.

Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com> # on SAMA7G5
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 50331b202f73..324d81516832 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1738,7 +1738,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	bool cloned = skb_cloned(*skb) || skb_header_cloned(*skb) ||
 		      skb_is_nonlinear(*skb);
 	int padlen = ETH_ZLEN - (*skb)->len;
-	int headroom = skb_headroom(*skb);
 	int tailroom = skb_tailroom(*skb);
 	struct sk_buff *nskb;
 	u32 fcs;
@@ -1752,9 +1751,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 		/* FCS could be appeded to tailroom. */
 		if (tailroom >= ETH_FCS_LEN)
 			goto add_fcs;
-		/* FCS could be appeded by moving data to headroom. */
-		else if (!cloned && headroom + tailroom >= ETH_FCS_LEN)
-			padlen = 0;
 		/* No room for FCS, need to reallocate skb. */
 		else
 			padlen = ETH_FCS_LEN;
@@ -1763,10 +1759,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 		padlen += ETH_FCS_LEN;
 	}
 
-	if (!cloned && headroom + tailroom >= padlen) {
-		(*skb)->data = memmove((*skb)->head, (*skb)->data, (*skb)->len);
-		skb_set_tail_pointer(*skb, (*skb)->len);
-	} else {
+	if (cloned || tailroom < padlen) {
 		nskb = skb_copy_expand(*skb, 0, padlen, GFP_ATOMIC);
 		if (!nskb)
 			return -ENOMEM;
-- 
2.39.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51529689622
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjBCK1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjBCK1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:27:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F729EE2A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:26:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D654CB82A5F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33037C433D2;
        Fri,  3 Feb 2023 10:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419979;
        bh=W65sEcktP7gPkZlIEV2bmCtCackr2H0mcTrU4hTcGTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKllEZ6gjXm+m8QTiV4rcTI1aM90pIzKd762HjVZ82msjUNL3CEBSqU+802nAoLgg
         D73Vs+ecdt8RZhYRy0f9uAgu8PccaCHJOWYa6dfgEoKaCLXteoWKn32ugnP7MzQ93Y
         kYTCfvixy7Q/pD8v8ZWJKcWikr+qvQ6hm3wnrT0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Robert Hancock <robert.hancock@calian.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/134] net: macb: fix PTP TX timestamp failure due to packet padding
Date:   Fri,  3 Feb 2023 11:12:26 +0100
Message-Id: <20230203101025.711087221@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 78219a9943a7..d948b582f4c9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1752,7 +1752,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	bool cloned = skb_cloned(*skb) || skb_header_cloned(*skb) ||
 		      skb_is_nonlinear(*skb);
 	int padlen = ETH_ZLEN - (*skb)->len;
-	int headroom = skb_headroom(*skb);
 	int tailroom = skb_tailroom(*skb);
 	struct sk_buff *nskb;
 	u32 fcs;
@@ -1766,9 +1765,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 		/* FCS could be appeded to tailroom. */
 		if (tailroom >= ETH_FCS_LEN)
 			goto add_fcs;
-		/* FCS could be appeded by moving data to headroom. */
-		else if (!cloned && headroom + tailroom >= ETH_FCS_LEN)
-			padlen = 0;
 		/* No room for FCS, need to reallocate skb. */
 		else
 			padlen = ETH_FCS_LEN;
@@ -1777,10 +1773,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA0E531A63
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240752AbiEWRd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241037AbiEWRcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:32:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF8077F05;
        Mon, 23 May 2022 10:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF3A6B81202;
        Mon, 23 May 2022 17:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E3BC385A9;
        Mon, 23 May 2022 17:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326841;
        bh=/Vp/mTzC2zQzuZMpQFRBDEVKDe4ulklZbwulRP4GhAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bboBFDnCpCarytOdCTzLF9/gbSHRQsdVFDEI2xXaqd7ehBNs6ALUuuI4b1DsQiN4b
         nP7qzTn+LEtlHsWio9FwyNp0REQGeoPdIkRYF/ZWcUWkc5kGXNbj0J2qoBKBtKKAPo
         Urwnhx1CJ4zGs4o40gSLZZwld+TL+Kv0niZmkjPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 076/158] net: ipa: certain dropped packets arent accounted for
Date:   Mon, 23 May 2022 19:03:53 +0200
Message-Id: <20220523165843.595929416@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 30b338ff7998b6ed7a90815870cd5db725f87168 ]

If an RX endpoint receives packets containing status headers, and a
packet in the buffer is not dropped, ipa_endpoint_skb_copy() is
responsible for wrapping the packet data in an SKB and forwarding it
to ipa_modem_skb_rx() for further processing.

If ipa_endpoint_skb_copy() gets a null pointer from build_skb(), it
just returns early.  But in the process it doesn't record that as a
dropped packet in the network device statistics.

Instead, call ipa_modem_skb_rx() whether or not the SKB pointer is
NULL; that function ensures the statistics are properly updated.

Fixes: 1b65bbcc9a710 ("net: ipa: skip SKB copy if no netdev")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_endpoint.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 68291a3efd04..2ecfc17544a6 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1169,13 +1169,12 @@ static void ipa_endpoint_skb_copy(struct ipa_endpoint *endpoint,
 		return;
 
 	skb = __dev_alloc_skb(len, GFP_ATOMIC);
-	if (!skb)
-		return;
-
-	/* Copy the data into the socket buffer and receive it */
-	skb_put(skb, len);
-	memcpy(skb->data, data, len);
-	skb->truesize += extra;
+	if (skb) {
+		/* Copy the data into the socket buffer and receive it */
+		skb_put(skb, len);
+		memcpy(skb->data, data, len);
+		skb->truesize += extra;
+	}
 
 	ipa_modem_skb_rx(endpoint->netdev, skb);
 }
-- 
2.35.1




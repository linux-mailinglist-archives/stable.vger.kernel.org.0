Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF9B579E58
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbiGSNBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242988AbiGSM7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112345C976;
        Tue, 19 Jul 2022 05:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2204C61924;
        Tue, 19 Jul 2022 12:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01987C341C6;
        Tue, 19 Jul 2022 12:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233524;
        bh=Q/LC8x8u1BICLPDe82F7RyQjByOA98Fh4+OHqOj3ey0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQ9+idosvDfudSTxY38YvKnH7q7cnvj+ZoaRCw4AteGpo95IkuUDA9VvRuFaTw9vv
         A1Phirj/MsvlfQ47sikUI5U1efM9EFPfKy4zVZ+EcCGnyzHYpL2J1+NfxdGGlwgjZW
         0ZxR3MxHkibompJSFZwHS4OGuWaWaC0r6W/66H9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 124/231] net: ftgmac100: Hold reference returned by of_get_child_by_name()
Date:   Tue, 19 Jul 2022 13:53:29 +0200
Message-Id: <20220719114724.883323292@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 49b9f431ff0d845a36be0b3ede35ec324f2e5fee ]

In ftgmac100_probe(), we should hold the refernece returned by
of_get_child_by_name() and use it to call of_node_put() for
reference balance.

Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 5231818943c6..c03663785a8d 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1764,6 +1764,19 @@ static int ftgmac100_setup_clk(struct ftgmac100 *priv)
 	return rc;
 }
 
+static bool ftgmac100_has_child_node(struct device_node *np, const char *name)
+{
+	struct device_node *child_np = of_get_child_by_name(np, name);
+	bool ret = false;
+
+	if (child_np) {
+		ret = true;
+		of_node_put(child_np);
+	}
+
+	return ret;
+}
+
 static int ftgmac100_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -1883,7 +1896,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 
 		/* Display what we found */
 		phy_attached_info(phy);
-	} else if (np && !of_get_child_by_name(np, "mdio")) {
+	} else if (np && !ftgmac100_has_child_node(np, "mdio")) {
 		/* Support legacy ASPEED devicetree descriptions that decribe a
 		 * MAC with an embedded MDIO controller but have no "mdio"
 		 * child node. Automatically scan the MDIO bus for available
-- 
2.35.1




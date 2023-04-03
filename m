Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09C96D4ACC
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbjDCOu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbjDCOuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4382D4A1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:49:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D57AF6136F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE7DC433EF;
        Mon,  3 Apr 2023 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533365;
        bh=VJ8fSE6cPSnFA9ct74l+U//TUQbG/ORxZtqTFAi4G1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQKd5iaoZkUGAC31d0zIImZrRDcE2ZWLDXSHz99E4DA3EpEcn8e3KhND3s7H2sQap
         R0IuABr7BE3U/ko1l9o7lYaudni+vMfqJiMnTJ7uJBHyztop/NiSY1kT1weQzFe+cy
         Ig2M4KlxmNYtjIZgdniykBekMA2gpKuRcRiQ42I8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yazan Shhady <yazan.shhady@solid-run.com>,
        Josua Mayer <josua@solid-run.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 148/187] net: phy: dp83869: fix default value for tx-/rx-internal-delay
Date:   Mon,  3 Apr 2023 16:09:53 +0200
Message-Id: <20230403140420.894519955@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

commit 82e2c39f9ef78896e9b634dfd82dc042e6956bb7 upstream.

dp83869 internally uses a look-up table for mapping supported delays in
nanoseconds to register values.
When specific delays are defined in device-tree, phy_get_internal_delay
does the lookup automatically returning an index.

The default case wrongly assigns the nanoseconds value from the lookup
table, resulting in numeric value 2000 applied to delay configuration
register, rather than the expected index values 0-7 (7 for 2000).
Ultimately this issue broke RX for 1Gbps links.

Fix default delay configuration by assigning the intended index value
directly.

Cc: stable@vger.kernel.org
Fixes: 736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")
Co-developed-by: Yazan Shhady <yazan.shhady@solid-run.com>
Signed-off-by: Yazan Shhady <yazan.shhady@solid-run.com>
Signed-off-by: Josua Mayer <josua@solid-run.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230323102536.31988-1-josua@solid-run.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83869.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -588,15 +588,13 @@ static int dp83869_of_init(struct phy_de
 						       &dp83869_internal_delay[0],
 						       delay_size, true);
 	if (dp83869->rx_int_delay < 0)
-		dp83869->rx_int_delay =
-				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		dp83869->rx_int_delay = DP83869_CLK_DELAY_DEF;
 
 	dp83869->tx_int_delay = phy_get_internal_delay(phydev, dev,
 						       &dp83869_internal_delay[0],
 						       delay_size, false);
 	if (dp83869->tx_int_delay < 0)
-		dp83869->tx_int_delay =
-				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		dp83869->tx_int_delay = DP83869_CLK_DELAY_DEF;
 
 	return ret;
 }



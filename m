Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC7269CDED
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjBTNyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjBTNyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:54:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD3A1DB8D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:54:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFF90B80B4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2789AC433EF;
        Mon, 20 Feb 2023 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901252;
        bh=poceO0hDaDSSEdVBSTJ02Ot/K1XSx+iEzkbT/G3F/nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJ8kVB57gtF5pvyarFzJNNI70BBOVDRC2nO6pX23l84u2t/WJ/wXQ4n0M4HJaEBWv
         OhlvTY2ygKPDu+yUPIPoGeKNSuataePXSXEXFAposLuIHKqkSq1nP9HPcy2VNJMRGz
         Vo/LkaW5p102fyg2hdAdY5vm2T3UwqTPZeh+pOx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Zink <j.zink@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 64/83] net: stmmac: fix order of dwmac5 FlexPPS parametrization sequence
Date:   Mon, 20 Feb 2023 14:36:37 +0100
Message-Id: <20230220133555.904831350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

From: Johannes Zink <j.zink@pengutronix.de>

commit 4562c65ec852067c6196abdcf2d925f08841dcbc upstream.

So far changing the period by just setting new period values while
running did not work.

The order as indicated by the publicly available reference manual of the i.MX8MP [1]
indicates a sequence:

 * initiate the programming sequence
 * set the values for PPS period and start time
 * start the pulse train generation.

This is currently not used in dwmac5_flex_pps_config(), which instead does:

 * initiate the programming sequence and immediately start the pulse train generation
 * set the values for PPS period and start time

This caused the period values written not to take effect until the FlexPPS output was
disabled and re-enabled again.

This patch fix the order and allows the period to be set immediately.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MPRM

Fixes: 9a8a02c9d46d ("net: stmmac: Add Flexible PPS support")
Signed-off-by: Johannes Zink <j.zink@pengutronix.de>
Link: https://lore.kernel.org/r/20230210143937.3427483-1-j.zink@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -541,9 +541,9 @@ int dwmac5_flex_pps_config(void __iomem
 		return 0;
 	}
 
-	val |= PPSCMDx(index, 0x2);
 	val |= TRGTMODSELx(index, 0x2);
 	val |= PPSEN0;
+	writel(val, ioaddr + MAC_PPS_CONTROL);
 
 	writel(cfg->start.tv_sec, ioaddr + MAC_PPSx_TARGET_TIME_SEC(index));
 
@@ -568,6 +568,7 @@ int dwmac5_flex_pps_config(void __iomem
 	writel(period - 1, ioaddr + MAC_PPSx_WIDTH(index));
 
 	/* Finally, activate it */
+	val |= PPSCMDx(index, 0x2);
 	writel(val, ioaddr + MAC_PPS_CONTROL);
 	return 0;
 }



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EEF5948DA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353991AbiHOXm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354286AbiHOXls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC37DF92;
        Mon, 15 Aug 2022 13:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD3B26077B;
        Mon, 15 Aug 2022 20:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC606C433C1;
        Mon, 15 Aug 2022 20:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594296;
        bh=zJh7aVjy83OVBviyzmE9wu2gQP51nHf6qxEIm9t2EEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxZIXbBfoLzPTQAdQ79ET1V6o7OScZyp54lr45B6umd1DoN6AIUWWGXIP3jACSFwq
         VgRg9Mqt++gICxEdv6sqLndn3jFwTB+E5lINtrjyoRbmua3+pn4KoUPzDvKWx3WXlj
         rkQKg2PII+pIyalAKAru8U04Nd4FZF/xrukqkFL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0410/1157] drm/vc4: dsi: Correct DSI divider calculations
Date:   Mon, 15 Aug 2022 19:56:06 +0200
Message-Id: <20220815180456.055982552@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 3b45eee87da171caa28f61240ddb5c21170cda53 ]

The divider calculations tried to find the divider just faster than the
clock requested. However if it required a divider of 7 then the for loop
aborted without handling the "error" case, and could end up with a clock
lower than requested.

The integer divider from parent PLL to DSI clock is also capable of
going up to /255, not just /7 that the driver was trying.  This allows
for slower link frequencies on the DSI bus where the resolution permits.

Correct the loop so that we always have a clock greater than requested,
and covering the whole range of dividers.

Fixes: 86c1b9eff3f2 ("drm/vc4: Adjust modes in DSI to work around the integer PLL divider.")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-13-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index e82ee94cafc7..81a6c4e9576d 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -805,11 +805,9 @@ static bool vc4_dsi_encoder_mode_fixup(struct drm_encoder *encoder,
 	/* Find what divider gets us a faster clock than the requested
 	 * pixel clock.
 	 */
-	for (divider = 1; divider < 8; divider++) {
-		if (parent_rate / divider < pll_clock) {
-			divider--;
+	for (divider = 1; divider < 255; divider++) {
+		if (parent_rate / (divider + 1) < pll_clock)
 			break;
-		}
 	}
 
 	/* Now that we've picked a PLL divider, calculate back to its
-- 
2.35.1




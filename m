Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C1C657CCA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiL1PgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiL1PgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:36:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7C2140BE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:36:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00791B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB99C433D2;
        Wed, 28 Dec 2022 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241761;
        bh=kT2RdgshqTYBZNY+OZg4XNCVZXXwtSxQhole0gp59+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNMYz91WQdKs/5PW/qcONKCtVxc3cABYfimk8tm8l1NcP4ukEZ17UJCIJfylkYlDN
         ayvkPpZRN2Gvrza+QYcYj4O6JfbXWDFKYdu+vVlkAgipMqtlhLDe4QfEmErFj/xXDt
         qxNhqtlIoNHEQYsDHLuWmONBuBAnKn5m0w9nehv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0268/1146] drm/panel/panel-sitronix-st7701: Fix RTNI calculation
Date:   Wed, 28 Dec 2022 15:30:07 +0100
Message-Id: <20221228144337.416848338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit c1cdee9b685a174fca849e1451c201a846a69318 ]

The RTNI field is multiplied by 16 and incremented by 512 before being
used as the minimum number of pixel clock per horizontal line, hence
it is necessary to subtract those 512 bytes from htotal and then divide
the result by 16 before writing the value into the RTNI field. Fix the
calculation.

Fixes: de2b4917843c ("drm/panel/panel-sitronix-st7701: Infer horizontal pixel count from TFT mode")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221012221159.88397-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sitronix-st7701.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7701.c b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
index c481daa4bbce..9578f461f5e4 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7701.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
@@ -244,7 +244,7 @@ static void st7701_init_sequence(struct st7701 *st7701)
 		   DSI_CMD2_BK0_INVSEL_ONES_MASK |
 		   FIELD_PREP(DSI_CMD2_BK0_INVSEL_NLINV_MASK, desc->nlinv),
 		   FIELD_PREP(DSI_CMD2_BK0_INVSEL_RTNI_MASK,
-			      DIV_ROUND_UP(mode->htotal, 16)));
+			      (clamp((u32)mode->htotal, 512U, 1008U) - 512) / 16));
 
 	/* Command2, BK1 */
 	ST7701_DSI(st7701, DSI_CMD2BKX_SEL,
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3875F29E4
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJCH1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJCH00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:26:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6064BD1C;
        Mon,  3 Oct 2022 00:18:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EB4060F08;
        Mon,  3 Oct 2022 07:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587CCC433C1;
        Mon,  3 Oct 2022 07:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781528;
        bh=v7g4F4OSPeaZNOBmVwP/wUNFNVZYgcHERgCo9de8d90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpQcoaUxjWFJubczK4ryFwuQqSEGR6K+FVagBi8bq+01PWFU47iJC39bdneghUIkD
         pypE23fap4+oBWzrsZzQgRz09xzO9relst+GquLoBrb03xHc2RqxNU/TIswevuzjyh
         ep2ecP5P0flTrd8ED9c5fiCLF/jmsKIClxFAgF3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 52/83] drm/bridge: lt8912b: fix corrupted image output
Date:   Mon,  3 Oct 2022 09:11:17 +0200
Message-Id: <20221003070723.305982375@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 051ad2788d35ca07aec8402542e5d38429f2426a ]

Correct I2C address for the register list in lt8912_write_lvds_config(),
these registers are on the first I2C address (0x48), the current
function is just writing garbage to the wrong registers and this creates
multiple issues (artifacts and output completely corrupted) on some HDMI
displays.

Correct I2C address comes from Lontium documentation and it is the one
used on other out-of-tree LT8912B drivers [1].

[1] https://github.com/boundarydevices/linux/blob/boundary-imx_5.10.x_2.0.0/drivers/video/lt8912.c#L296

Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
Acked-by: Adrien Grassein <adrien.grassein@gmail.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220922124306.34729-4-dev@pschenker.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 6e04d51b4636..82169b6bfca1 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -186,7 +186,7 @@ static int lt8912_write_lvds_config(struct lt8912 *lt)
 		{0x03, 0xff},
 	};
 
-	return regmap_multi_reg_write(lt->regmap[I2C_CEC_DSI], seq, ARRAY_SIZE(seq));
+	return regmap_multi_reg_write(lt->regmap[I2C_MAIN], seq, ARRAY_SIZE(seq));
 };
 
 static inline struct lt8912 *bridge_to_lt8912(struct drm_bridge *b)
-- 
2.35.1




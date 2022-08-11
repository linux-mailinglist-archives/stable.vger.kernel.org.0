Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E25590192
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbiHKP5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237355AbiHKP4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:56:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59A6A0609;
        Thu, 11 Aug 2022 08:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A7E616E4;
        Thu, 11 Aug 2022 15:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0D5C43470;
        Thu, 11 Aug 2022 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232824;
        bh=OeMg4a/pR6P2uG64JhkuHV+oop0WsQ1wlASz8/VVvbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7rDuQoUsOF3KJFog53YzH0/C0V0XmYBKV4aZzaYkvTKn6ET8qffterarGUS7T3q6
         03OREh1nTrHC6bE7A5oWqAuv6SpnZNpQ4E7MtgNQRUlXTMOMbmvBAiksIB873T5vJD
         A2uQ7jKwxwqEDxbE52M/1RY5n6Ox6lyLOZbiB7m1TB6IeR9gxGPKNc8nPHH/RtAreK
         8+82JA3+G5lTq/cYsDRQ2k0I/uuKkKYfbGIItI4n7vtM7AOO4f71mdOMwOP6Y3lYU4
         voc3cUJ1kfelWid4ITgu6KwYDSxOpSQTfJ8pGtWANuloU5z+KKYWO1f515fitjlLAz
         7zJgJIYzgv3ow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugen Hristev <eugen.hristev@microchip.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 43/93] media: atmel: atmel-isc-base: allow wb ctrls to be changed when isc is not configured
Date:   Thu, 11 Aug 2022 11:41:37 -0400
Message-Id: <20220811154237.1531313-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit aa63c5eaf7f7d2d3a4b1cc5782e7151b8ae3079f ]

When attempting to change the white balance (WB) ctrls before starting
streaming, e.g.:

 # v4l2-ctl -L

User Controls
..
            blue_component_gain 0x009819c1 (int)    : min=0 max=8191 step=1 default=512 value=512 flags=slider
..
 # v4l2-ctl --set-ctrl=blue_component_gain=500
 # v4l2-ctl -L
..
            blue_component_gain 0x009819c1 (int)    : min=0 max=8191 step=1 default=512 value=500 flags=slider
..

These will not be written to the internal data struct and will not be
written to the WB hardware module.
Thus, after starting streaming, they will be reset to default:

 # v4l2-ctl -L
..
            blue_component_gain 0x009819c1 (int)    : min=0 max=8191 step=1 default=512 value=512 flags=slider
..

It does not make much sense to not be able to configure the WB controls
at all times. Even if the sensor would not be RAW Bayer (and in this case the
WB module is unavailable), the user could configure the ISC itself, as the
ISC should not care about the sensor format.
Thus, when WB module is available (if the sensor changes format e.g.) it will
be already configured as be user's desires.
In consequence, remove the check in isc_s_awb_ctrl that will return if ISC
does not know the sensor format.

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index db15770d5b88..968b505f40e8 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -1509,10 +1509,6 @@ static int isc_s_awb_ctrl(struct v4l2_ctrl *ctrl)
 		else
 			ctrls->awb = ISC_WB_NONE;
 
-		/* we did not configure ISC yet */
-		if (!isc->config.sd_format)
-			break;
-
 		/* configure the controls with new values from v4l2 */
 		if (ctrl->cluster[ISC_CTRL_R_GAIN]->is_new)
 			ctrls->gain[ISC_HIS_CFG_MODE_R] = isc->r_gain_ctrl->val;
-- 
2.35.1


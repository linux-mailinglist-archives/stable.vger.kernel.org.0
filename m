Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820784F447D
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbiDEMVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242154AbiDEKag (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C21DDD946;
        Tue,  5 Apr 2022 03:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85770617A4;
        Tue,  5 Apr 2022 10:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93246C385A0;
        Tue,  5 Apr 2022 10:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153901;
        bh=Jf4PjsEHBrgGDU8e0I19DbGc3U4kngzVA4IrMT/RlIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2WUuv/cihSX+IavIqcuYjnvI8btwILQJjEfw+owOM5yH08RKUUi+YF1hiXzj86pwm
         +kGhlcJWthtXBn5igz/DuHlOo2hnKThYDIj/lAve3l//ViBhfxMIQQseHfLY28jc2n
         iZ8KxzB3vI8unDyRgeQIpjLpd/o/itTs9dYJjS3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 388/599] pinctrl: renesas: r8a77470: Reduce size for narrow VIN1 channel
Date:   Tue,  5 Apr 2022 09:31:22 +0200
Message-Id: <20220405070310.377236055@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9e04a0eda84fccab0ac22a33825ad53f47c968c7 ]

The second video-in channel on RZ/G1C has only 12 data lanes, but the
pin control driver uses the vin_data union, which is meant for 24 data
lanes, thus wasting space.

Fix this by using the vin_data12 union instead.

This reduces kernel size by 96 bytes.

Fixes: 50f3f2d73e3426ba ("pinctrl: sh-pfc: Reduce kernel size for narrow VIN channels")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/52716fa89139f6f92592633edb52804d4c5e18f0.1640269757.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pfc-r8a77470.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/renesas/pfc-r8a77470.c b/drivers/pinctrl/renesas/pfc-r8a77470.c
index b3b116da1bb0..14005725a726 100644
--- a/drivers/pinctrl/renesas/pfc-r8a77470.c
+++ b/drivers/pinctrl/renesas/pfc-r8a77470.c
@@ -2121,7 +2121,7 @@ static const unsigned int vin0_clk_mux[] = {
 	VI0_CLK_MARK,
 };
 /* - VIN1 ------------------------------------------------------------------- */
-static const union vin_data vin1_data_pins = {
+static const union vin_data12 vin1_data_pins = {
 	.data12 = {
 		RCAR_GP_PIN(3,  1), RCAR_GP_PIN(3, 2),
 		RCAR_GP_PIN(3,  3), RCAR_GP_PIN(3, 4),
@@ -2131,7 +2131,7 @@ static const union vin_data vin1_data_pins = {
 		RCAR_GP_PIN(3, 15), RCAR_GP_PIN(3, 16),
 	},
 };
-static const union vin_data vin1_data_mux = {
+static const union vin_data12 vin1_data_mux = {
 	.data12 = {
 		VI1_DATA0_MARK, VI1_DATA1_MARK,
 		VI1_DATA2_MARK, VI1_DATA3_MARK,
-- 
2.34.1




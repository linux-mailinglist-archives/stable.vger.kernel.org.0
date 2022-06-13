Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C935493BA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377347AbiFMNcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377951AbiFMNam (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EEE6EC40;
        Mon, 13 Jun 2022 04:25:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 369C96114A;
        Mon, 13 Jun 2022 11:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454DCC3411C;
        Mon, 13 Jun 2022 11:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119520;
        bh=3Q/PmVUxD9TMrty0pQpmIjcdEoWqv0ccX6+5z3kXWEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bDToHPKQLMDaAibTa79Hcg0Ez4AzR5Zfvgvdj3H2n++L6kNGhZoZLF1YeL5xWgOt
         6mbtmsSWnyoUFpplOVgvD++pdNaNc9H3qz6yBBPN/IZFVe9seYOQKdLjYZ/XR2aFkY
         K6vOyBA7f0m1V0ka9Ntnc2ZFV0VxMUDPol3ci7fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 023/339] pwm: raspberrypi-poe: Fix endianness in firmware struct
Date:   Mon, 13 Jun 2022 12:07:28 +0200
Message-Id: <20220613094927.212477490@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 09f688f0718f57f9cf68ee1aa94490f641e759ba ]

The reg member of struct raspberrypi_pwm_prop is a little endian 32 bit
quantity. Explicitly convert the (native endian) value to little endian
on assignment as is already done in raspberrypi_pwm_set_property().

This fixes the following sparse warning:

	drivers/pwm/pwm-raspberrypi-poe.c:69:24: warning: incorrect type in initializer (different base types)
	drivers/pwm/pwm-raspberrypi-poe.c:69:24:    expected restricted __le32 [usertype] reg
	drivers/pwm/pwm-raspberrypi-poe.c:69:24:    got unsigned int [usertype] reg

Fixes: 79caa362eab6 ("pwm: Add Raspberry Pi Firmware based PWM bus")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-raspberrypi-poe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-raspberrypi-poe.c b/drivers/pwm/pwm-raspberrypi-poe.c
index e52e29fc8231..6ff73029f367 100644
--- a/drivers/pwm/pwm-raspberrypi-poe.c
+++ b/drivers/pwm/pwm-raspberrypi-poe.c
@@ -66,7 +66,7 @@ static int raspberrypi_pwm_get_property(struct rpi_firmware *firmware,
 					u32 reg, u32 *val)
 {
 	struct raspberrypi_pwm_prop msg = {
-		.reg = reg
+		.reg = cpu_to_le32(reg),
 	};
 	int ret;
 
-- 
2.35.1




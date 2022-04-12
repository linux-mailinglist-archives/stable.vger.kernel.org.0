Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFBA4FC9AD
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbiDLAsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243258AbiDLArs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:47:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4743D18395;
        Mon, 11 Apr 2022 17:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D766F617E6;
        Tue, 12 Apr 2022 00:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBFBC385A3;
        Tue, 12 Apr 2022 00:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724331;
        bh=h3/4h0H471UJtADRLo2a8XhpcTHhAAbQKbJpOEoncW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoKOTF0c/rY6TGKH5m7wi8z61ao7Qjn0+/f5wl5zgC/hG0YOlutMKHNuZn5h3kDGg
         Fa5dczroqySFdyhIoy3CYmODvEgemYnHvNQ5QW4CnOx14TmOSzlWhDq7irPJrrYZLB
         +Hu75xrHkiqsTdbvonww//pb4xobn/tnjlKcX2EpPuvLIKd3DroYdG+YmBGz3/YYmQ
         V39utCVxanEPyusjxFNwq/DyzYq6R9IcAi9AIn/h4LDG+zChCG7etQrDcvgGOjABtc
         4grBOTRKuUeusHQ709qcVX82avqOno5KD41wuyOJ7Q1W+aIPxfcjGsOBTwfyg+eRE7
         Ksn3mg7ka1D9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leo Ruan <tingquan.ruan@cn.bosch.com>,
        Mark Jonas <mark.jonas@de.bosch.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 24/49] gpu: ipu-v3: Fix dev_dbg frequency output
Date:   Mon, 11 Apr 2022 20:43:42 -0400
Message-Id: <20220412004411.349427-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Leo Ruan <tingquan.ruan@cn.bosch.com>

[ Upstream commit 070a88fd4a03f921b73a2059e97d55faaa447dab ]

This commit corrects the printing of the IPU clock error percentage if
it is between -0.1% to -0.9%. For example, if the pixel clock requested
is 27.2 MHz but only 27.0 MHz can be achieved the deviation is -0.8%.
But the fixed point math had a flaw and calculated error of 0.2%.

Before:
  Clocks: IPU 270000000Hz DI 24716667Hz Needed 27200000Hz
  IPU clock can give 27000000 with divider 10, error 0.2%
  Want 27200000Hz IPU 270000000Hz DI 24716667Hz using IPU, 27000000Hz

After:
  Clocks: IPU 270000000Hz DI 24716667Hz Needed 27200000Hz
  IPU clock can give 27000000 with divider 10, error -0.8%
  Want 27200000Hz IPU 270000000Hz DI 24716667Hz using IPU, 27000000Hz

Signed-off-by: Leo Ruan <tingquan.ruan@cn.bosch.com>
Signed-off-by: Mark Jonas <mark.jonas@de.bosch.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220207151411.5009-1-mark.jonas@de.bosch.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-di.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index 666223c6bec4..0a34e0ab4fe6 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -447,8 +447,9 @@ static void ipu_di_config_clock(struct ipu_di *di,
 
 		error = rate / (sig->mode.pixelclock / 1000);
 
-		dev_dbg(di->ipu->dev, "  IPU clock can give %lu with divider %u, error %d.%u%%\n",
-			rate, div, (signed)(error - 1000) / 10, error % 10);
+		dev_dbg(di->ipu->dev, "  IPU clock can give %lu with divider %u, error %c%d.%d%%\n",
+			rate, div, error < 1000 ? '-' : '+',
+			abs(error - 1000) / 10, abs(error - 1000) % 10);
 
 		/* Allow a 1% error */
 		if (error < 1010 && error >= 990) {
-- 
2.35.1


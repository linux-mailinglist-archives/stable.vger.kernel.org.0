Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0456B592434
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242361AbiHNQ31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242454AbiHNQ2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:28:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573FA1C138;
        Sun, 14 Aug 2022 09:24:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C17A60F98;
        Sun, 14 Aug 2022 16:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4A4C433C1;
        Sun, 14 Aug 2022 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494241;
        bh=HsE6Hc1g0L5kt8Rb3CEnOB/34WTJkVgtm0Yx9+swGaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YphVKDRXFRRBqurWrgkUg1FJ7pK8ITTQIoPrPqxvqQR0sjbKJtxg8lTEdE6zp38+L
         4DvKaHJKx8wzdkLK6XwqpLWDD0w54YQFCS11ESA8W7ni3hRAoNEYSDWp4gE1tk8yDk
         G4a4Y7NAlJhyYzGuLaXJ/j2OwfHfhRm/fiNSERRbbqyT36XYlRK4ZzRpPeRPkId24O
         GZmT7w4U5u8rtc/u7u2V039dEV9t6bRo1Hor6oeto/oHBGXXNEoX2xofEAXpJc2aUV
         S14QGFsiVk0scU0Cvy3Sah3uFDP5EiJBps0Dfr3Y0RTUMU5zfdNkmuHuP4qK1d+0Wg
         tFoUQnFKhMQag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Nguyen Bao Nguyen <nguyen.nguyen.yj@renesas.com>,
        Nishiyama Kunihiko <kunihiko.nishiyama.dn@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 10/39] ASoC: rsnd: care default case on rsnd_ssiu_busif_err_irq_ctrl()
Date:   Sun, 14 Aug 2022 12:22:59 -0400
Message-Id: <20220814162332.2396012-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit ef30911d3c39fd57884c348c29b9cbff88def155 ]

Before, ssiu.c didn't care SSI5-8, thus,
commit b1384d4c95088d0 ("ASoC: rsnd: care default case on
rsnd_ssiu_busif_err_status_clear()") cares it for status clear.

But we should care it for error irq handling, too.
This patch cares it.

Reported-by: Nguyen Bao Nguyen <nguyen.nguyen.yj@renesas.com>
Reported-by: Nishiyama Kunihiko <kunihiko.nishiyama.dn@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/871quocio1.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/ssiu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sh/rcar/ssiu.c b/sound/soc/sh/rcar/ssiu.c
index 4b8a63e336c7..d7f4646ee029 100644
--- a/sound/soc/sh/rcar/ssiu.c
+++ b/sound/soc/sh/rcar/ssiu.c
@@ -67,6 +67,8 @@ static void rsnd_ssiu_busif_err_irq_ctrl(struct rsnd_mod *mod, int enable)
 		shift  = 1;
 		offset = 1;
 		break;
+	default:
+		return;
 	}
 
 	for (i = 0; i < 4; i++) {
-- 
2.35.1


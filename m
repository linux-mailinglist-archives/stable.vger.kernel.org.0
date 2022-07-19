Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFF4579F06
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbiGSNKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243224AbiGSNIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:08:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB536550DF;
        Tue, 19 Jul 2022 05:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2AD6B81B84;
        Tue, 19 Jul 2022 12:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48858C341C6;
        Tue, 19 Jul 2022 12:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233659;
        bh=U3MgG21b5SazhZDFf0lLfuAYMuBp9MqEc7e1BPZoKXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kE1sG8GKhYrTqbMn6/qqxfRXTMRM2g/E7S/jNLf0vc607z7flew4EdxMPIF3ZfNsT
         ALNmyIe235SdqZyagNDq5+E7ynCdYjCiftURJz4S8fU+EEG4AAOa7ZKDmi7NO1LrK9
         OT+lmPqT55HJpya0nLNHwHd44NtaDwyMzjCOhOEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 197/231] ASoC: Intel: bytcr_wm5102: Fix GPIO related probe-ordering problem
Date:   Tue, 19 Jul 2022 13:54:42 +0200
Message-Id: <20220719114730.648078383@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 4e07479eab8a044cc9542414ccb4aeb8eb033bde ]

The "wlf,spkvdd-ena" GPIO needed by the bytcr_wm5102 driver
is made available through a gpio-lookup table.

This gpio-lookup table is registered by drivers/mfd/arizona-spi.c, which
may get probed after the bytcr_wm5102 driver.

If the gpio-lookup table has not registered yet then the gpiod_get()
will return -ENOENT. Treat -ENOENT as -EPROBE_DEFER to still keep
things working in this case.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220612155652.107310-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_wm5102.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_wm5102.c b/sound/soc/intel/boards/bytcr_wm5102.c
index 8d8e96e3cd2d..f6d0cef1b28c 100644
--- a/sound/soc/intel/boards/bytcr_wm5102.c
+++ b/sound/soc/intel/boards/bytcr_wm5102.c
@@ -421,8 +421,17 @@ static int snd_byt_wm5102_mc_probe(struct platform_device *pdev)
 	priv->spkvdd_en_gpio = gpiod_get(codec_dev, "wlf,spkvdd-ena", GPIOD_OUT_LOW);
 	put_device(codec_dev);
 
-	if (IS_ERR(priv->spkvdd_en_gpio))
-		return dev_err_probe(dev, PTR_ERR(priv->spkvdd_en_gpio), "getting spkvdd-GPIO\n");
+	if (IS_ERR(priv->spkvdd_en_gpio)) {
+		ret = PTR_ERR(priv->spkvdd_en_gpio);
+		/*
+		 * The spkvdd gpio-lookup is registered by: drivers/mfd/arizona-spi.c,
+		 * so -ENOENT means that arizona-spi hasn't probed yet.
+		 */
+		if (ret == -ENOENT)
+			ret = -EPROBE_DEFER;
+
+		return dev_err_probe(dev, ret, "getting spkvdd-GPIO\n");
+	}
 
 	/* override platform name, if required */
 	byt_wm5102_card.dev = dev;
-- 
2.35.1




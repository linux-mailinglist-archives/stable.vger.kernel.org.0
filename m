Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E33E4AAF40
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbiBFMt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiBFMt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:49:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E98C06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 04:49:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92BAEB80CF3
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 12:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EB4C340E9;
        Sun,  6 Feb 2022 12:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644151764;
        bh=mjEr21GCLVkKz60QFkf5vaM3Dln2zjEHoIhc1WVGSX8=;
        h=Subject:To:Cc:From:Date:From;
        b=h/VzcJbElXSobSCXmutWA6zcSXXs0MHtkCKXJ1SFU9W5js+igphQ/XBa/Pw5hpUv0
         h+C/0SWbloBBk3ZkIsZNBJccXviZmkoJRzypCNNauO1/u20e3KOsxAjmLYKEFcZM+b
         E0EXMqRJdwmeSg6Q7VdlxlKmFO4oxgD4Cm71efUE=
Subject: FAILED: patch "[PATCH] ASoC: simple-card: fix probe failure on platform component" failed to apply to 5.10-stable tree
To:     robert.hancock@calian.com, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Feb 2022 13:49:21 +0100
Message-ID: <16441517619956@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a64067f4cecaaa4deed8e33d3266bc0bcc189142 Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Fri, 7 Jan 2022 15:47:10 -0600
Subject: [PATCH] ASoC: simple-card: fix probe failure on platform component

A previous change to simple-card resulted in asoc_simple_parse_dai
attempting to retrieve the dai_name for platform components, which are
unlikely to have a valid DAI name. This caused simple-card to fail to
probe when using the xlnx_formatter_pcm as the platform component, since
it does not register any DAI components.

Since the dai_name is not used for platform components, just skip trying
to retrieve it for those.

Fixes: f107294c6422 ("ASoC: simple-card: support snd_soc_dai_link_component style for cpu")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220107214711.1100162-6-robert.hancock@calian.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index a89d1cfdda32..78419e18717d 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -28,6 +28,30 @@ static const struct snd_soc_ops simple_ops = {
 	.hw_params	= asoc_simple_hw_params,
 };
 
+static int asoc_simple_parse_platform(struct device_node *node,
+				      struct snd_soc_dai_link_component *dlc)
+{
+	struct of_phandle_args args;
+	int ret;
+
+	if (!node)
+		return 0;
+
+	/*
+	 * Get node via "sound-dai = <&phandle port>"
+	 * it will be used as xxx_of_node on soc_bind_dai_link()
+	 */
+	ret = of_parse_phandle_with_args(node, DAI, CELL, 0, &args);
+	if (ret)
+		return ret;
+
+	/* dai_name is not required and may not exist for plat component */
+
+	dlc->of_node = args.np;
+
+	return 0;
+}
+
 static int asoc_simple_parse_dai(struct device_node *node,
 				 struct snd_soc_dai_link_component *dlc,
 				 int *is_single_link)
@@ -289,7 +313,7 @@ static int simple_dai_link_of(struct asoc_simple_priv *priv,
 	if (ret < 0)
 		goto dai_link_of_err;
 
-	ret = asoc_simple_parse_dai(plat, platforms, NULL);
+	ret = asoc_simple_parse_platform(plat, platforms);
 	if (ret < 0)
 		goto dai_link_of_err;
 


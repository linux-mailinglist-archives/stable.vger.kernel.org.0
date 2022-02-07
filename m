Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89254ABC5A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiBGLfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384704AbiBGL3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:29:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486CFC0401D1;
        Mon,  7 Feb 2022 03:28:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0458AB80EBD;
        Mon,  7 Feb 2022 11:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B371C340F0;
        Mon,  7 Feb 2022 11:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233280;
        bh=biUjx9epFYxUc5njJ7zZT0O1LrXh9iSxhzE0Ljx4fBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYs9Jo9EtA7FesHozSOyGRkhE7fydY4vcQmF00FNJ9DKbqF2ET3hEfcbkVOx6Yk5w
         xhRfZtgPQddCRWQytlagEid3kFoPLZCEI9sko4TrMyEvFNsbmogUgTgfScgP20fAwB
         M0/r8xR2xTHY9mF0cfayyRoFXpeu9/UeT5V3BpHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 073/110] ASoC: simple-card: fix probe failure on platform component
Date:   Mon,  7 Feb 2022 12:06:46 +0100
Message-Id: <20220207103804.763779936@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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

From: Robert Hancock <robert.hancock@calian.com>

commit a64067f4cecaaa4deed8e33d3266bc0bcc189142 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/generic/simple-card.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -28,6 +28,30 @@ static const struct snd_soc_ops simple_o
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
@@ -289,7 +313,7 @@ static int simple_dai_link_of(struct aso
 	if (ret < 0)
 		goto dai_link_of_err;
 
-	ret = asoc_simple_parse_dai(plat, platforms, NULL);
+	ret = asoc_simple_parse_platform(plat, platforms);
 	if (ret < 0)
 		goto dai_link_of_err;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECEA4BDB78
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242724AbiBUJaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:30:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350047AbiBUJ3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:29:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4D7240BE;
        Mon, 21 Feb 2022 01:13:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89FC7CE0E88;
        Mon, 21 Feb 2022 09:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C320C340E9;
        Mon, 21 Feb 2022 09:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434778;
        bh=E6A2kwIv4UUnoTr2Zs/vVy+OJVA/kcWOfEpF7UolTxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnAMl4drPcNIAhoAVaWo8K1LGMkMaqS1PT5iuumU1ALGudFjEEX9Eg0ew/GX3A8b7
         CLQJuq1KsRm0i0YD2p4/wa3Uk8QDm1/bnG/UInAGCYDVFneNCL+oQef2jIDV9SqEuI
         jiRuHG/76++JSy4fY/CGnW4uZrKEjbzL38EGgmfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 128/196] ASoC: tas2770: Insert post reset delay
Date:   Mon, 21 Feb 2022 09:49:20 +0100
Message-Id: <20220221084935.222292473@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Martin Povišer <povik+lin@cutebit.org>

commit 307f31452078792aab94a729fce33200c6e42dc4 upstream.

Per TAS2770 datasheet there must be a 1 ms delay from reset to first
command. So insert delays into the driver where appropriate.

Fixes: 1a476abc723e ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220204095301.5554-1-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2770.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -38,10 +38,12 @@ static void tas2770_reset(struct tas2770
 		gpiod_set_value_cansleep(tas2770->reset_gpio, 0);
 		msleep(20);
 		gpiod_set_value_cansleep(tas2770->reset_gpio, 1);
+		usleep_range(1000, 2000);
 	}
 
 	snd_soc_component_write(tas2770->component, TAS2770_SW_RST,
 		TAS2770_RST);
+	usleep_range(1000, 2000);
 }
 
 static int tas2770_set_bias_level(struct snd_soc_component *component,
@@ -110,6 +112,7 @@ static int tas2770_codec_resume(struct s
 
 	if (tas2770->sdz_gpio) {
 		gpiod_set_value_cansleep(tas2770->sdz_gpio, 1);
+		usleep_range(1000, 2000);
 	} else {
 		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
 						    TAS2770_PWR_CTRL_MASK,
@@ -510,8 +513,10 @@ static int tas2770_codec_probe(struct sn
 
 	tas2770->component = component;
 
-	if (tas2770->sdz_gpio)
+	if (tas2770->sdz_gpio) {
 		gpiod_set_value_cansleep(tas2770->sdz_gpio, 1);
+		usleep_range(1000, 2000);
+	}
 
 	tas2770_reset(tas2770);
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D2F59D5E7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240668AbiHWImt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239922AbiHWImF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:42:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B9E7AC3F;
        Tue, 23 Aug 2022 01:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44844B81C48;
        Tue, 23 Aug 2022 08:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F580C433D6;
        Tue, 23 Aug 2022 08:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242725;
        bh=0RH08DlYaBDEIvYoq52VEKqDG4diNbNpOF8jgqGa704=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8IFQvrpBq1N+8PqvP/kbWoNncu5SLZfnaacRxUJi895YqT5rKKRuMMyuxkR0KAML
         5sNjn+bdxOIwDNB+66u1u0wZ1sVOcO+wKF0sljrqNt8087/qNPlTu0YXMBrHMGozSA
         x26O+JV1GGZV3IU48M5gM6WtswISh7ZTQq9z7bu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.19 181/365] ASoC: tas2770: Allow mono streams
Date:   Tue, 23 Aug 2022 10:01:22 +0200
Message-Id: <20220823080125.799694042@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit bf54d97a835dfe62d4d29e245e170c63d0089be7 upstream.

The part is a mono speaker amp, but it can do downmix and switch between
left and right channel, so the right channel range is 1 to 2.

Fixes: 1a476abc723e ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220808141246.5749-3-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2770.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -507,7 +507,7 @@ static struct snd_soc_dai_driver tas2770
 		.id = 0,
 		.playback = {
 			.stream_name    = "ASI1 Playback",
-			.channels_min   = 2,
+			.channels_min   = 1,
 			.channels_max   = 2,
 			.rates      = TAS2770_RATES,
 			.formats    = TAS2770_FORMATS,



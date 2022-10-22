Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541CA608894
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiJVITz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbiJVITF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:19:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881A22CCA0F;
        Sat, 22 Oct 2022 00:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A70FE60AD9;
        Sat, 22 Oct 2022 07:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA7AC433D6;
        Sat, 22 Oct 2022 07:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424879;
        bh=7+fjVzf8Ald8bczHdsBDYgEKHhhR9GoYNcP6Ek+3Dd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdzYe1GFCY3mPdCF8tvgk/r+UbybuwvunTZuljf5yxptOZXTl3AfaCQ/Agw8nBv3h
         +A0ksoDWsFFgFs7nJxSazFr39wqp4Rzib0/qzfnhVPh0+3+96JK6NwRSKzHFiOytu0
         EFsXxk0BiNzUhZuEkJFv/hTnCD7+sEwwNFPInDmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 311/717] ASoC: tas2764: Allow mono streams
Date:   Sat, 22 Oct 2022 09:23:10 +0200
Message-Id: <20221022072507.487813118@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit 23204d928a27146d13e11c9383632775345ecca8 ]

The part is a mono speaker amp, but it can do downmix and switch between
left and right channel, so the right channel range is 1 to 2.

(This mirrors commit bf54d97a835d ("ASoC: tas2770: Allow mono streams")
which was a fix to the tas2770 driver.)

Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220825140241.53963-2-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 4cb788f3e5f7..00df36fb3ede 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -485,7 +485,7 @@ static struct snd_soc_dai_driver tas2764_dai_driver[] = {
 		.id = 0,
 		.playback = {
 			.stream_name    = "ASI1 Playback",
-			.channels_min   = 2,
+			.channels_min   = 1,
 			.channels_max   = 2,
 			.rates      = TAS2764_RATES,
 			.formats    = TAS2764_FORMATS,
-- 
2.35.1




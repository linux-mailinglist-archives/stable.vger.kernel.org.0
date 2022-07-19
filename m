Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99127579DA4
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbiGSMx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239020AbiGSMxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:53:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71F590D84;
        Tue, 19 Jul 2022 05:20:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 031D5B81B13;
        Tue, 19 Jul 2022 12:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E52BC341CA;
        Tue, 19 Jul 2022 12:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233245;
        bh=wrmeyo29Y2fleQVwAXQJxUKLpQE8RgfOI0r4Ukl5Vbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1w9rF7FFlTUV7rMB74We08MVicPolOhm9YA1bUTIcUUn5At/KF2Ztn2JjP7fh8xld
         AGA9m7wzStEV03S9iHAL8ww4fjc041w4x0FYsvOeKAF5gmqSQW6LtlsBOgNRVp6gWi
         72tuxhyWhDTaYps7MgYYpF7Z60aKJ46DOdq3HRas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 056/231] ASoC: tas2764: Correct playback volume range
Date:   Tue, 19 Jul 2022 13:52:21 +0200
Message-Id: <20220719114718.919093926@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 3e99e5697e1f7120b5abc755e8a560b22612d6ed ]

DVC value 0xc8 is -100dB and 0xc9 is mute; this needs to map to
-100.5dB as far as the dB scale is concerned. Fix that and enable
the mute flag, so alsamixer correctly shows the control as
<0 dB .. -100 dB, mute>.

Signed-off-by: Hector Martin <marcan@marcan.st>
Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220630075135.2221-3-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 46c815650b2c..bd79bc7ecf6b 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -536,7 +536,7 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 }
 
 static DECLARE_TLV_DB_SCALE(tas2764_digital_tlv, 1100, 50, 0);
-static DECLARE_TLV_DB_SCALE(tas2764_playback_volume, -10000, 50, 0);
+static DECLARE_TLV_DB_SCALE(tas2764_playback_volume, -10050, 50, 1);
 
 static const struct snd_kcontrol_new tas2764_snd_controls[] = {
 	SOC_SINGLE_TLV("Speaker Volume", TAS2764_DVC, 0,
-- 
2.35.1




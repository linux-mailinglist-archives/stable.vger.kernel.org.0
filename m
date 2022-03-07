Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFBD4CF5D8
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiCGJap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238724AbiCGJ3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:29:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221DA5BE4B;
        Mon,  7 Mar 2022 01:27:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00FC661135;
        Mon,  7 Mar 2022 09:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00183C340E9;
        Mon,  7 Mar 2022 09:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645278;
        bh=ho+1fk4JbqUuOdumvMPIOqALlMHuN+23rs2JHlchIaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uo37i50BtHWiNmZ6gI1XzkfU7bZjhfbmSUDqok1orxumySQ0OY+fqKrD7TfErdfC3
         IvSpwFNXyo24e70uGOq0xzMe81d6jj1/YolQrgH9ypG/7StJGqZOGQPB4iGZqh+73t
         MCkNEMXulfEnQJqki2DUubsa+7IWIZtDuLDqTkK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 42/64] ASoC: cs4265: Fix the duplicated control name
Date:   Mon,  7 Mar 2022 10:19:15 +0100
Message-Id: <20220307091640.341191030@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

commit c5487b9cdea5c1ede38a7ec94db0fc59963c8e86 upstream.

Currently, the following error messages are seen during boot:

asoc-simple-card sound: control 2:0:0:SPDIF Switch:0 is already present
cs4265 1-004f: ASoC: failed to add widget SPDIF dapm kcontrol SPDIF Switch: -16

Quoting Mark Brown:

"The driver is just plain buggy, it defines both a regular SPIDF Switch
control and a SND_SOC_DAPM_SWITCH() called SPDIF both of which will
create an identically named control, it can never have loaded without
error.  One or both of those has to be renamed or they need to be
merged into one thing."

Fix the duplicated control name by combining the two SPDIF controls here
and move the register bits onto the DAPM widget and have DAPM control them.

Fixes: f853d6b3ba34 ("ASoC: cs4265: Add a S/PDIF enable switch")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220215120514.1760628-1-festevam@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs4265.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/codecs/cs4265.c
+++ b/sound/soc/codecs/cs4265.c
@@ -150,7 +150,6 @@ static const struct snd_kcontrol_new cs4
 	SOC_SINGLE("E to F Buffer Disable Switch", CS4265_SPDIF_CTL1,
 				6, 1, 0),
 	SOC_ENUM("C Data Access", cam_mode_enum),
-	SOC_SINGLE("SPDIF Switch", CS4265_SPDIF_CTL2, 5, 1, 1),
 	SOC_SINGLE("Validity Bit Control Switch", CS4265_SPDIF_CTL2,
 				3, 1, 0),
 	SOC_ENUM("SPDIF Mono/Stereo", spdif_mono_stereo_enum),
@@ -186,7 +185,7 @@ static const struct snd_soc_dapm_widget
 
 	SND_SOC_DAPM_SWITCH("Loopback", SND_SOC_NOPM, 0, 0,
 			&loopback_ctl),
-	SND_SOC_DAPM_SWITCH("SPDIF", SND_SOC_NOPM, 0, 0,
+	SND_SOC_DAPM_SWITCH("SPDIF", CS4265_SPDIF_CTL2, 5, 1,
 			&spdif_switch),
 	SND_SOC_DAPM_SWITCH("DAC", CS4265_PWRCTL, 1, 1,
 			&dac_switch),



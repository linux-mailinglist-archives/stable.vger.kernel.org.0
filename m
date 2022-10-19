Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1050F604195
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbiJSKqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbiJSKoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:44:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35668E7B5;
        Wed, 19 Oct 2022 03:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 104CAB824D7;
        Wed, 19 Oct 2022 09:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECE1C433C1;
        Wed, 19 Oct 2022 09:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170787;
        bh=FoAKBoM3BVE06nEwOQj9AKyKByzBVLYrsUm0mfXl8EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOI4Viqzgb1uOEYMe4Zhg8V7lYI7431EbtRIXIAALVKMAcNUZqBu3oxlzLvK09jNt
         KYSe/eymQZP+n+XOFGBcHRALnwleVfzk5QLdRovZ2TH6uPXTMC39rFVwohMiGGlnnU
         VHx/MFcGrzWYcCP6blMw7GVlLanePa+mxeKyRNF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikhail Rudenko <mike.rudenko@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 752/862] ASoC: sunxi: sun4i-codec: set debugfs_prefix for CPU DAI component
Date:   Wed, 19 Oct 2022 10:33:59 +0200
Message-Id: <20221019083323.137280072@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikhail Rudenko <mike.rudenko@gmail.com>

[ Upstream commit 717a8ff20f32792d6a94f2883e771482c37d844b ]

At present, succesfull probing of H3 Codec results in an error

    debugfs: Directory '1c22c00.codec' with parent 'H3 Audio Codec' already present!

This is caused by a directory name conflict between codec
components. Fix it by setting debugfs_prefix for the CPU DAI
component.

Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
Link: https://lore.kernel.org/r/20220913212256.151799-2-mike.rudenko@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-codec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sunxi/sun4i-codec.c b/sound/soc/sunxi/sun4i-codec.c
index 830beb38bf15..fdf3165acd70 100644
--- a/sound/soc/sunxi/sun4i-codec.c
+++ b/sound/soc/sunxi/sun4i-codec.c
@@ -1232,6 +1232,9 @@ static const struct snd_soc_component_driver sun8i_a23_codec_codec = {
 static const struct snd_soc_component_driver sun4i_codec_component = {
 	.name			= "sun4i-codec",
 	.legacy_dai_naming	= 1,
+#ifdef CONFIG_DEBUG_FS
+	.debugfs_prefix		= "cpu",
+#endif
 };
 
 #define SUN4I_CODEC_RATES	SNDRV_PCM_RATE_CONTINUOUS
-- 
2.35.1




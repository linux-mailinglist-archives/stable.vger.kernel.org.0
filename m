Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303666357FF
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbiKWJss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238158AbiKWJsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:48:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BD0B854
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:45:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B6F8B81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA567C433C1;
        Wed, 23 Nov 2022 09:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196736;
        bh=RAlBgkkVIGUhLQb5DkS5yMQzKs+03Qxn7Gr6Z2YEhz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQ2N/Ez8+C6mIp9TF5bUwgt7SgP57aGMxBGOD9Lq2KjCMhPJlH4kPfnvJzixyBm0B
         XhSFq3VoR0nSIeSi1IWhtOsVdqH0FfX1U580SY9F9lNgMDMX3D7En7zgrWt5JMtAf1
         0RX5Ejd209PGOS5WJ4RfguvMMBWlc4TVE2bFIK8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Montleon <jmontleo@redhat.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 102/314] ASoC: rt5514: fix legacy dai naming
Date:   Wed, 23 Nov 2022 09:49:07 +0100
Message-Id: <20221123084630.109324125@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Montleon <jmontleo@redhat.com>

[ Upstream commit 392cc13c5ec72ccd6bbfb1bc2339502cc59dd285 ]

Starting with 6.0-rc1 these messages are logged and the sound card
is unavailable. Adding legacy_dai_naming to the rt5514-spi causes
it to function properly again.

[   16.928454] kbl_r5514_5663_max kbl_r5514_5663_max: ASoC: CPU DAI
spi-PRP0001:00 not registered
[   16.928561] platform kbl_r5514_5663_max: deferred probe pending

Fixes: fc34ece41f71 ("ASoC: Refactor non_legacy_dai_naming flag")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216641
Signed-off-by: Jason Montleon <jmontleo@redhat.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221103144612.4431-1-jmontleo@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5514-spi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/rt5514-spi.c b/sound/soc/codecs/rt5514-spi.c
index 1a25a3787935..362663abcb89 100644
--- a/sound/soc/codecs/rt5514-spi.c
+++ b/sound/soc/codecs/rt5514-spi.c
@@ -298,13 +298,14 @@ static int rt5514_spi_pcm_new(struct snd_soc_component *component,
 }
 
 static const struct snd_soc_component_driver rt5514_spi_component = {
-	.name		= DRV_NAME,
-	.probe		= rt5514_spi_pcm_probe,
-	.open		= rt5514_spi_pcm_open,
-	.hw_params	= rt5514_spi_hw_params,
-	.hw_free	= rt5514_spi_hw_free,
-	.pointer	= rt5514_spi_pcm_pointer,
-	.pcm_construct	= rt5514_spi_pcm_new,
+	.name			= DRV_NAME,
+	.probe			= rt5514_spi_pcm_probe,
+	.open			= rt5514_spi_pcm_open,
+	.hw_params		= rt5514_spi_hw_params,
+	.hw_free		= rt5514_spi_hw_free,
+	.pointer		= rt5514_spi_pcm_pointer,
+	.pcm_construct		= rt5514_spi_pcm_new,
+	.legacy_dai_naming	= 1,
 };
 
 /**
-- 
2.35.1




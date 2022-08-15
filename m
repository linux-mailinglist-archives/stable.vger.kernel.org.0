Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D175594D31
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343775AbiHPAmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350173AbiHPAlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:41:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CAA1907E5;
        Mon, 15 Aug 2022 13:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF9E5B81197;
        Mon, 15 Aug 2022 20:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC42C433D6;
        Mon, 15 Aug 2022 20:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595992;
        bh=poDWCIjXQdZOYKDtK4fB+2LprMUP+thyEgOgjHZB9/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0sKesqrhzhhozYWzvuLH5k8O00mDQl2ZEdRPWMqfioAyj/5KflHPy++PDdi5uomU
         df9RejyyTmhs4lPnVtL+vPYCc3Wt/his8vvdBK+jrpaI6HhnaiOmnOdHIWh3CzuTJK
         qnC2ncsxpzon/Ya8tGTZcBlNJ0qObkIpH3SZ+oNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0906/1157] ASoC: cs35l45: Add endianness flag in snd_soc_component_driver
Date:   Mon, 15 Aug 2022 20:04:22 +0200
Message-Id: <20220815180515.695385074@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit d919630fe77904931277e663c902582ea6f4e4cf ]

The endianness flag is used on the CODEC side to specify an
ambivalence to endian, typically because it is lost over the hardware
link. This device receives audio over an I2S DAI and as such should
have endianness applied.

Fixes: 0d463d016000 ("ASoC: cs35l45: Add driver for Cirrus Logic CS35L45 Smart Amp")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220614131022.778057-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l45.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/cs35l45.c b/sound/soc/codecs/cs35l45.c
index 2367c1a4c10e..145051390471 100644
--- a/sound/soc/codecs/cs35l45.c
+++ b/sound/soc/codecs/cs35l45.c
@@ -500,6 +500,8 @@ static const struct snd_soc_component_driver cs35l45_component = {
 	.num_controls = ARRAY_SIZE(cs35l45_controls),
 
 	.name = "cs35l45",
+
+	.endianness = 1,
 };
 
 static int __maybe_unused cs35l45_runtime_suspend(struct device *dev)
-- 
2.35.1




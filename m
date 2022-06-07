Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6CC541C6B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382647AbiFGV7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239238AbiFGV6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:58:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF0A24D7A9;
        Tue,  7 Jun 2022 12:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 678DDB82182;
        Tue,  7 Jun 2022 19:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F73C385A2;
        Tue,  7 Jun 2022 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629219;
        bh=cDGXQDzvZnIg4L2nHZB3SGryb9zKYnI5rFK0O1CZtEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoxGOO/1uiJfNUXWbWH5u9+GCtvOcm43uQDoEZtmw5vk7wzKgTRtpcYdF6TsXs7Cl
         bcnPJ407aJtYnk7Tb+sAWFWGkvsJdYlq5tte+0T1Qql+TddekpzIubwvrCE1NyNWfW
         gAYuxCOtU5ydfgu8pFWdA7wB/K6ufh3UsK6zN6M8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 612/879] ASoC: atmel-pdmic: Remove endianness flag on pdmic component
Date:   Tue,  7 Jun 2022 19:02:10 +0200
Message-Id: <20220607165020.614363265@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 52857c3baa0e5ddeba7b2c84e56bb71c9674e048 ]

The endianness flag should have been removed when the driver was
ported across from having both a CODEC and CPU side component, to
just having a CPU component and using the dummy for the CODEC. The
endianness flag is used to indicate that the device is completely
ambivalent to the endianness of the data, typically due to the
endianness being lost over the hardware link (ie. the link defines
bit ordering). It's usage didn't have any effect when the driver
had both a CPU and CODEC component, since the union of those equals
the CPU side settings, but now causes the driver to falsely report
it supports big endian. Correct this by removing the flag.

Fixes: f3c668074a04 ("ASoC: atmel-pdmic: remove codec component")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220504170905.332415-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-pdmic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/atmel/atmel-pdmic.c b/sound/soc/atmel/atmel-pdmic.c
index 42117de299e7..ea34efac2fff 100644
--- a/sound/soc/atmel/atmel-pdmic.c
+++ b/sound/soc/atmel/atmel-pdmic.c
@@ -481,7 +481,6 @@ static const struct snd_soc_component_driver atmel_pdmic_cpu_dai_component = {
 	.num_controls		= ARRAY_SIZE(atmel_pdmic_snd_controls),
 	.idle_bias_on		= 1,
 	.use_pmdown_time	= 1,
-	.endianness		= 1,
 };
 
 /* ASoC sound card */
-- 
2.35.1




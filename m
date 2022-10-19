Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719FB604851
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiJSN4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbiJSNw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:52:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D61731ECE;
        Wed, 19 Oct 2022 06:36:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FA17B823DB;
        Wed, 19 Oct 2022 08:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4121C433D7;
        Wed, 19 Oct 2022 08:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169800;
        bh=EbACe5qacps0SV0GIDnIuKU9lBFLNTXwJE3mpAJw9sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKgmsxpU3rVnOhUfky4eqUsXkkd9jGaG0A9JhF3ycWLh8l62SEaps0TEonYTmXkFE
         qupCFsmrDbEZPH//CclTTg6q0BN0dfa4PsiuDEksqeutgFiuMMjon4PcYNi0KbICfU
         TsAzOKhEthu9jEbAJ44m8GjYvBTyEvugirVEu/hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 381/862] ASoC: wm_adsp: Handle optional legacy support
Date:   Wed, 19 Oct 2022 10:27:48 +0200
Message-Id: <20221019083306.807821695@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 35c8ae25c4fdeabf490e005692795a3be17ca5f6 ]

The tracing capabilities for the speaker protection fw enabled via
commit c55b3e46cb99 ("ASoC: wm_adsp: Add trace caps to speaker
protection FW") are not be available on all platforms, such as the
Valve's Steam Deck which is based on the Halo Core DSP.

As a consequence, whenever the firmware is loaded, a rather misleading
'Failed to parse legacy: -19' error message is written to the kernel
ring buffer:

[  288.977412] steamdeck kernel: cs35l41 spi-VLV1776:01: DSP1: Firmware version: 3
[  288.978002] steamdeck kernel: cs35l41 spi-VLV1776:01: DSP1: cs35l41-dsp1-spk-prot.wmfw: Fri 02 Apr 2021 21:03:50 W. Europe Daylight Time
[  289.094065] steamdeck kernel: cs35l41 spi-VLV1776:01: DSP1: Firmware: 400a4 vendor: 0x2 v0.33.0, 2 algorithms
[  289.095073] steamdeck kernel: cs35l41 spi-VLV1776:01: DSP1: 0: ID cd v29.53.0 XM@94 YM@e
[  289.095665] steamdeck kernel: cs35l41 spi-VLV1776:01: DSP1: 1: ID f20b v0.0.1 XM@170 YM@0
[  289.096275] steamdeck kernel: cs35l41 spi-VLV1776:01: DSP1: Protection: C:\Users\ocanavan\Desktop\cirrusTune_july2021.bin
[  291.172383] steamdeck kernel: cs35l41 spi-VLV1776:01: DSP1: Failed to parse legacy: -19

Update wm_adsp_buffer_init() to print a more descriptive info message
when wm_adsp_buffer_parse_legacy() returns -ENODEV.

Fixes: c55b3e46cb99 ("ASoC: wm_adsp: Add trace caps to speaker protection FW")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220825220530.1205141-1-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index cfaa45ede916..8a2e9771bb50 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1602,7 +1602,9 @@ static int wm_adsp_buffer_init(struct wm_adsp *dsp)
 	if (list_empty(&dsp->buffer_list)) {
 		/* Fall back to legacy support */
 		ret = wm_adsp_buffer_parse_legacy(dsp);
-		if (ret)
+		if (ret == -ENODEV)
+			adsp_info(dsp, "Legacy support not available\n");
+		else if (ret)
 			adsp_warn(dsp, "Failed to parse legacy: %d\n", ret);
 	}
 
-- 
2.35.1




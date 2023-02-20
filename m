Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E8469CDAF
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjBTNvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjBTNvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:51:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD5E1E2B0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:51:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6488560E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758B9C433D2;
        Mon, 20 Feb 2023 13:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901100;
        bh=lfuAHYzrt2sPHR3hAQMkks3VM6Ap55lxyshqk6d3UY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14doBM3eUhsw5CNu7L+Fn8Aq2AzKkkgjAAJR2s7LocrnZjRaEM7/eDAnCg461+DPe
         JhBewwoE502asweyXrr3latP6U6FagDNIUrufAQV3KTMquQRtOJ8hmdo/QgY4YhZwo
         luBaK2UZES47HbzEmpkq+DO4SYyrQI2kjmBRewl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/83] ASoC: Intel: sof_cs42l42: always set dpcm_capture for amplifiers
Date:   Mon, 20 Feb 2023 14:35:39 +0100
Message-Id: <20230220133553.905512982@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit e0a52220344ab7defe25b9cdd58fe1dc1122e67c ]

The amplifier may provide hardware support for I/V feedback, or
alternatively the firmware may generate an echo reference attached to
the SSP and dailink used for the amplifier.

To avoid any issues with invalid/NULL substreams in the latter case,
always unconditionally set dpcm_capture.

Link: https://github.com/thesofproject/linux/issues/4083
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20230119163459.2235843-3-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_cs42l42.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/boards/sof_cs42l42.c b/sound/soc/intel/boards/sof_cs42l42.c
index ce78c18798876..8061082d9fbf3 100644
--- a/sound/soc/intel/boards/sof_cs42l42.c
+++ b/sound/soc/intel/boards/sof_cs42l42.c
@@ -311,6 +311,9 @@ static int create_spk_amp_dai_links(struct device *dev,
 	links[*id].platforms = platform_component;
 	links[*id].num_platforms = ARRAY_SIZE(platform_component);
 	links[*id].dpcm_playback = 1;
+	/* firmware-generated echo reference */
+	links[*id].dpcm_capture = 1;
+
 	links[*id].no_pcm = 1;
 	links[*id].cpus = &cpus[*id];
 	links[*id].num_cpus = 1;
-- 
2.39.0




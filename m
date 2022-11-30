Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A8A63E033
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiK3Syh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiK3Sye (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:54:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F99863D5E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:54:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C405061D41
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2408C433C1;
        Wed, 30 Nov 2022 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834468;
        bh=i62pXkbM8jq3FwMIp1Yu4olWnfxvvXuVJj5DLFQdd78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnajh5g0BysTwt9a5cE2K3OBzynDwLprcg0pCTPTJyiNOgYS9fHvRksN4D+vcV030
         VaCk2k68ZtbIi2OZTEZlROLtsbahcdIUymqy0eeqI9Yp1J22WNcXAQDNS+zKS1ZMGX
         3N31jxjQSIdOPzFTBEGCQNi9fit5J/nX/Xpnz9KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 227/289] ASoC: Intel: soc-acpi: add ES83x6 support to IceLake
Date:   Wed, 30 Nov 2022 19:23:32 +0100
Message-Id: <20221130180549.260451997@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

[ Upstream commit 9a1d248bb4beaf1b43d17ba12481ee0629fa29b9 ]

Missing entry to find a machine driver for ES83x6-based platforms.

Link: https://github.com/thesofproject/linux/issues/3873
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20221031195836.250193-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-icl-match.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-icl-match.c b/sound/soc/intel/common/soc-acpi-intel-icl-match.c
index b032bc07de8b..d0062f2cd256 100644
--- a/sound/soc/intel/common/soc-acpi-intel-icl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-icl-match.c
@@ -10,6 +10,11 @@
 #include <sound/soc-acpi-intel-match.h>
 #include "../skylake/skl.h"
 
+static const struct snd_soc_acpi_codecs essx_83x6 = {
+	.num_codecs = 3,
+	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
+};
+
 static struct skl_machine_pdata icl_pdata = {
 	.use_tplg_pcm = true,
 };
@@ -27,6 +32,14 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_icl_machines[] = {
 		.drv_name = "sof_rt5682",
 		.sof_tplg_filename = "sof-icl-rt5682.tplg",
 	},
+	{
+		.comp_ids = &essx_83x6,
+		.drv_name = "sof-essx8336",
+		.sof_tplg_filename = "sof-icl-es8336", /* the tplg suffix is added at run time */
+		.tplg_quirk_mask = SND_SOC_ACPI_TPLG_INTEL_SSP_NUMBER |
+					SND_SOC_ACPI_TPLG_INTEL_SSP_MSB |
+					SND_SOC_ACPI_TPLG_INTEL_DMIC_NUMBER,
+	},
 	{},
 };
 EXPORT_SYMBOL_GPL(snd_soc_acpi_intel_icl_machines);
-- 
2.35.1




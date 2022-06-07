Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E345D54091C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349917AbiFGSFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352076AbiFGSCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B751D311;
        Tue,  7 Jun 2022 10:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36582B82239;
        Tue,  7 Jun 2022 17:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8123CC34119;
        Tue,  7 Jun 2022 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624015;
        bh=lCKe4ucTRzZZVHOi/79ZSIpq7eiSisbTI1Mxo7eA1Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUu8ZAcWfii4sjM7g83y3e00OaoF7p2Gkg/0WWQ66QIOjDbDQc4H9J9bLHb6jzcCS
         ZJ5bSe40KD+lzo3eA5bIyYvqE801hFw5oZOVR4gn/yjSXgor9qIguCxgveE26mYtJi
         X+UZo7aDIkzP6jehbB8nHvoMnz7Xpx/fS7+qDyRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <yujie.liu@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/667] ASoC: rt1015p: remove dependency on GPIOLIB
Date:   Tue,  7 Jun 2022 18:56:38 +0200
Message-Id: <20220607164938.812328613@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit b390c25c6757b9d56cecdfbf6d55f15fc89a6386 ]

commit dcc2c012c7691 ("ASoC: Fix gpiolib dependencies") removed a
series of unnecessary dependencies on GPIOLIB when the gpio was
optional.

A similar simplification seems valid for rt1015p, so remove the
dependency as well. This will avoid the following warning

  WARNING: unmet direct dependencies detected for SND_SOC_RT1015P

     Depends on [n]: SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] &&
     GPIOLIB [=n]

     Selected by [y]:

     - SND_SOC_INTEL_SOF_RT5682_MACH [=y] && SOUND [=y] && !UML && SND
       [=y] && SND_SOC [=y] && SND_SOC_INTEL_MACH [=y] &&
       (SND_SOC_SOF_HDA_LINK [=y] || SND_SOC_SOF_BAYTRAIL [=n]) && I2C
       [=y] && ACPI [=y] && (SND_HDA_CODEC_HDMI [=y] &&
       SND_SOC_SOF_HDA_AUDIO_CODEC [=y] && (MFD_INTEL_LPSS [=y] ||
       COMPILE_TEST [=y]) || SND_SOC_SOF_BAYTRAIL [=n] &&
       (X86_INTEL_LPSS [=n] || COMPILE_TEST [=y]))

Reported-by: kernel test robot <yujie.liu@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220517172647.468244-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 2cbf4fc0f675..d59a7e99ce42 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1148,7 +1148,6 @@ config SND_SOC_RT1015
 
 config SND_SOC_RT1015P
 	tristate
-	depends on GPIOLIB
 
 config SND_SOC_RT1019
 	tristate
-- 
2.35.1




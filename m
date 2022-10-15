Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407055FF787
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 02:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiJOAMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 20:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJOAMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 20:12:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DEDE083;
        Fri, 14 Oct 2022 17:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KNt+pCSIUZ9+O3L8HoQe1tmbspN8QLuURkdKt3vda7s=; b=ekN/1fFjDh8HdTdr8OyIHH1VZ3
        1B+vgd01iZnf/itUErKgBI6cOUZdEIryUBIi7QTCLZGMstfAxWfeAYPvlo3CFivnE+wQHPSrzYW0O
        acGL9OA49uWn03sKPDxKg9XgnpIgYs7zv2QE1LejVxnphyYME/cn0Z9O0uxztpw28nhncRyD5EPMw
        YL6p078s0zH3RMzpqf6tf/Tzbk1fhu2M1tVDsUJ1FQ3ZNU7XYm8ayN/CBGM7fmOHr4k+sCDcKWDiK
        yuvHZaN6xhThWecIgpyts8ItC2+Qhr8BU1QHxeKVvY8o+yFEHtquMgk/zRwPnCcND2K6HpV6LMg2h
        +ZTgzp5A==;
Received: from [2601:1c2:d80:3110::a2e7] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ojUn8-0081ai-Hl; Sat, 15 Oct 2022 00:12:39 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ajit Pandey <ajitp@codeaurora.org>,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, stable@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH] ASoC: qcom: SND_SOC_SC7180 optionally depends on SOUNDWIRE
Date:   Fri, 14 Oct 2022 17:12:28 -0700
Message-Id: <20221015001228.18990-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If SOUNDWIRE is enabled, then SND_SOC_SC7180 should depend on
SOUNDWIRE to prevent SOUNDWIRE=m and SND_SOC_SC7180=y, which causes
build errors:

s390-linux-ld: sound/soc/qcom/common.o: in function `qcom_snd_sdw_prepare':
common.c:(.text+0x140): undefined reference to `sdw_disable_stream'
s390-linux-ld: common.c:(.text+0x14a): undefined reference to `sdw_deprepare_stream'
s390-linux-ld: common.c:(.text+0x158): undefined reference to `sdw_prepare_stream'
s390-linux-ld: common.c:(.text+0x16a): undefined reference to `sdw_enable_stream'
s390-linux-ld: common.c:(.text+0x17c): undefined reference to `sdw_deprepare_stream'
s390-linux-ld: sound/soc/qcom/common.o: in function `qcom_snd_sdw_hw_free':
common.c:(.text+0x344): undefined reference to `sdw_disable_stream'
s390-linux-ld: common.c:(.text+0x34e): undefined reference to `sdw_deprepare_stream'

Fixes: 3bd975f3ae0a ("ASoC: qcom: sm8250: move some code to common")
Fixes: 9e3ecb5b1681 ("ASoC: qcom: sc7180: Add machine driver for sound card registration")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Banajit Goswami <bgoswami@quicinc.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Ajit Pandey <ajitp@codeaurora.org>
Cc: Cheng-Yi Chiang <cychiang@chromium.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: stable@vger.kernel.org
Cc: alsa-devel@alsa-project.org
---
Sorry, I can't tell which Fixes: hash is appropriate here.

 sound/soc/qcom/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -- a/sound/soc/qcom/Kconfig b/sound/soc/qcom/Kconfig
--- a/sound/soc/qcom/Kconfig
+++ b/sound/soc/qcom/Kconfig
@@ -187,6 +187,7 @@ config SND_SOC_SC8280XP
 config SND_SOC_SC7180
 	tristate "SoC Machine driver for SC7180 boards"
 	depends on I2C && GPIOLIB
+	depends on SOUNDWIRE || SOUNDWIRE=n
 	select SND_SOC_QCOM_COMMON
 	select SND_SOC_LPASS_SC7180
 	select SND_SOC_MAX98357A

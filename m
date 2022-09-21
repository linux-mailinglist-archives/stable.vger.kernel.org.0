Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2ADA5C0051
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 16:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiIUOyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 10:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiIUOyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 10:54:06 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BFB5E571
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 07:54:04 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id s10so7331676ljp.5
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 07:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=fc9rvJk53jSt+31V+DshEMPT99txfYe0aFmQRodV1Rk=;
        b=F4Gm9tI8bRPXoj3MXzslfn42dKJ9CgrIkN+dQlksRQKb2QLs69cZEM0rHakPqe4mcu
         up6+zxUBsLdj0T2BXHtQdgNVXWrMZesU27ALdOMc38XiOmvh5GMWAC5cVSVz6SQoxbx9
         ZHMwDp3ZjpbkxgL3Hxq5EkIXlZv+d7pbZO0ynDSDGWqWBqJMlLYB5xOqcgu+XpcWT7Tb
         GbabFZlH0rtEyW1Ee0eaC8P1Q9vzWucAf+hZuTksj5oB3Ahjp4C3kNIVxKgVbSTrPY07
         s0+uJlvEYH+Sy/8Bk1JCF1/rZB2P5OANFbxtBFwA0H4bL4bblkOrFgtEwL8LlOOMI2/R
         Q8rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=fc9rvJk53jSt+31V+DshEMPT99txfYe0aFmQRodV1Rk=;
        b=qeo02KYBwB+h/dS6bXmub0CNxw9YoXt4kFXPIRCq1vFXtWI6mo4YxBtLdRAXoxbG/S
         c0My7iZeI6//UOtvSDCLNxpIFZNztYF+yOYpWb8InyzEPo2lTCRVOOFuhQnbw+26tfSS
         nkXOSIik/xvUtgBS+/tyHIpnNVwtMK/mCqx/WzhAV4W2pQOZrNMVQS5fZ4wPJ2Nks1mx
         d3kRf0EDLzHo22+FVk/IQF6LgFOTEW1wGofi3YF96YdAKMGAI9954XhKM0hdbHlEF7bW
         mFMtMdpZuHEr4YH2bB3ouM2Nn2WeYBZIpQcl2QVfXgD62renwOcOpx/I08TIsA7DQRqe
         4tHg==
X-Gm-Message-State: ACrzQf15LVIiJGtivudcz0XXSL/mT4dLTNutdBPyPiQI4L/T4nW6B+SO
        GkHj1nL/laqUVoCmonYC4bSpKw==
X-Google-Smtp-Source: AMsMyM4tHSgnHedkMCUmL9LyyL8xnzoHnFXiLsg6lWP/gbuPqkGj9AKlLPlXgXc33q+Uy5gjk24+AA==
X-Received: by 2002:a2e:5344:0:b0:26c:417b:aa78 with SMTP id t4-20020a2e5344000000b0026c417baa78mr7614255ljd.298.1663772042208;
        Wed, 21 Sep 2022 07:54:02 -0700 (PDT)
Received: from krzk-bin.. (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id c24-20020a056512075800b00494a1e875a9sm461981lfs.191.2022.09.21.07.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 07:54:01 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Vinod Koul <vkoul@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ASoC: wcd9335: fix order of Slimbus unprepare/disable
Date:   Wed, 21 Sep 2022 16:53:53 +0200
Message-Id: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Slimbus streams are first prepared and then enabled, so the cleanup path
should reverse it.  The unprepare sets stream->num_ports to 0 and frees
the stream->ports.  Calling disable after unprepare was not really
effective (channels was not deactivated) and could lead to further
issues due to making transfers on unprepared stream.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 sound/soc/codecs/wcd9335.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 06c6adbe5920..d2548fdf9ae5 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -1972,8 +1972,8 @@ static int wcd9335_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		slim_stream_unprepare(dai_data->sruntime);
 		slim_stream_disable(dai_data->sruntime);
+		slim_stream_unprepare(dai_data->sruntime);
 		break;
 	default:
 		break;
-- 
2.34.1


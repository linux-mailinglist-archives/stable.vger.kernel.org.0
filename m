Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D2E4F3337
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343957AbiDEJQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244977AbiDEIww (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDD21D0E6;
        Tue,  5 Apr 2022 01:48:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09CA561504;
        Tue,  5 Apr 2022 08:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B688C385A1;
        Tue,  5 Apr 2022 08:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148504;
        bh=k+kA+XOU2S9QaW5auCvkHqxpqLDNO4b9XtnucmR8ilA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWmoDH4VvhWNMEbPPLbEPHTIh4S5DkBg3J8v/R2mb2VuyW6ylRQTMy8jtXbojP0KD
         +juFni223uey48+5YsSsL56TDvIgPQhlfV/plm8ZB03DYYrdcLoD64cOtY2ZwEX9Qv
         3i5DkQQ4Lgs+yawzOm39X+OADT2r7HLVl2R9Y+5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0378/1017] ASoC: atmel: Fix error handling in snd_proto_probe
Date:   Tue,  5 Apr 2022 09:21:31 +0200
Message-Id: <20220405070405.506970709@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit b0bfaf0544d08d093d6211d7ef8816fb0b5b6c75 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

This function only calls of_node_put() in the regular path.
And it will cause refcount leak in error paths.
Fix this by calling of_node_put() in error handling too.

Fixes: a45f8853a5f9 ("ASoC: Add driver for PROTO Audio CODEC (with a WM8731)")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20220308013949.20323-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mikroe-proto.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/sound/soc/atmel/mikroe-proto.c b/sound/soc/atmel/mikroe-proto.c
index f9331f7e80fe..5b513ff7fe2d 100644
--- a/sound/soc/atmel/mikroe-proto.c
+++ b/sound/soc/atmel/mikroe-proto.c
@@ -115,7 +115,8 @@ static int snd_proto_probe(struct platform_device *pdev)
 	cpu_np = of_parse_phandle(np, "i2s-controller", 0);
 	if (!cpu_np) {
 		dev_err(&pdev->dev, "i2s-controller missing\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_codec_node;
 	}
 	dai->cpus->of_node = cpu_np;
 	dai->platforms->of_node = cpu_np;
@@ -125,7 +126,8 @@ static int snd_proto_probe(struct platform_device *pdev)
 						       &bitclkmaster, &framemaster);
 	if (bitclkmaster != framemaster) {
 		dev_err(&pdev->dev, "Must be the same bitclock and frame master\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_cpu_node;
 	}
 	if (bitclkmaster) {
 		if (codec_np == bitclkmaster)
@@ -136,18 +138,20 @@ static int snd_proto_probe(struct platform_device *pdev)
 		dai_fmt |= snd_soc_daifmt_parse_clock_provider_as_flag(np, NULL);
 	}
 
-	of_node_put(bitclkmaster);
-	of_node_put(framemaster);
-	dai->dai_fmt = dai_fmt;
-
-	of_node_put(codec_np);
-	of_node_put(cpu_np);
 
+	dai->dai_fmt = dai_fmt;
 	ret = snd_soc_register_card(&snd_proto);
 	if (ret && ret != -EPROBE_DEFER)
 		dev_err(&pdev->dev,
 			"snd_soc_register_card() failed: %d\n", ret);
 
+
+put_cpu_node:
+	of_node_put(bitclkmaster);
+	of_node_put(framemaster);
+	of_node_put(cpu_np);
+put_codec_node:
+	of_node_put(codec_np);
 	return ret;
 }
 
-- 
2.34.1




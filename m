Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A3F4F27ED
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbiDEIJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbiDEIAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CE31AD86;
        Tue,  5 Apr 2022 00:57:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C955AB81B18;
        Tue,  5 Apr 2022 07:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB59C340EE;
        Tue,  5 Apr 2022 07:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145468;
        bh=MQT/c8B9STkSA+ZJifM4SkIT1HBwLZ19pKMHc5bvbbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARBc98iiL1CKvsUQZm83IfDJxc0yBvNu3HFXu/bk2q1ZDrbas83BJq9QqZs5awGs4
         ov6anc2WRoj82F+o9QWJ1h6JMmE+0nG+4OzaSneA+WumHN1taK+Zz9dUitrEelm6ld
         w4NLJf6gZSXV2QTJO86UDChFC/jHk7wraghjATOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0415/1126] ASoC: atmel: Fix error handling in sam9x5_wm8731_driver_probe
Date:   Tue,  5 Apr 2022 09:19:22 +0200
Message-Id: <20220405070419.806758564@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 740dc3e846537c3743da98bf106f376023fd085c ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

This function only calls of_node_put() in the regular path.
And it will cause refcount leak in error path.

Fixes: fdbcb3cba54b ("ASoC: atmel: machine driver for at91sam9x5-wm8731 boards")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20220316111530.4551-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/sam9x5_wm8731.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/sound/soc/atmel/sam9x5_wm8731.c b/sound/soc/atmel/sam9x5_wm8731.c
index 7c45dc4f8c1b..99310e40e7a6 100644
--- a/sound/soc/atmel/sam9x5_wm8731.c
+++ b/sound/soc/atmel/sam9x5_wm8731.c
@@ -142,7 +142,7 @@ static int sam9x5_wm8731_driver_probe(struct platform_device *pdev)
 	if (!cpu_np) {
 		dev_err(&pdev->dev, "atmel,ssc-controller node missing\n");
 		ret = -EINVAL;
-		goto out;
+		goto out_put_codec_np;
 	}
 	dai->cpus->of_node = cpu_np;
 	dai->platforms->of_node = cpu_np;
@@ -153,12 +153,9 @@ static int sam9x5_wm8731_driver_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to set SSC %d for audio: %d\n",
 			ret, priv->ssc_id);
-		goto out;
+		goto out_put_cpu_np;
 	}
 
-	of_node_put(codec_np);
-	of_node_put(cpu_np);
-
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 	if (ret) {
 		dev_err(&pdev->dev, "Platform device allocation failed\n");
@@ -167,10 +164,14 @@ static int sam9x5_wm8731_driver_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "%s ok\n", __func__);
 
-	return ret;
+	goto out_put_cpu_np;
 
 out_put_audio:
 	atmel_ssc_put_audio(priv->ssc_id);
+out_put_cpu_np:
+	of_node_put(cpu_np);
+out_put_codec_np:
+	of_node_put(codec_np);
 out:
 	return ret;
 }
-- 
2.34.1




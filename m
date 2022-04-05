Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5DA4F27D7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbiDEIJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbiDEH77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF811BE8B;
        Tue,  5 Apr 2022 00:56:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 616E4B81B90;
        Tue,  5 Apr 2022 07:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74BDC340EE;
        Tue,  5 Apr 2022 07:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145408;
        bh=L7t5eCcbxKioBhlB6WdiF/7kW9vwa2XNaTwBhgAO9Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRJ144yxZ5dn91keSkrPp+ZcWBiA8snUNok4WhMxWyY51XpIsWDmpVB+LF5Snv7iT
         bm0d6/D6GnEiN4IrdWTiybQ1G7n1ERxO/Ai72ucLXYu6BQc+oVNhdEkEHZmOggd0An
         JfRpJjS2JMYIRBl/GIsqv1kzjK/2MG0rBvM+NZOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0395/1126] ASoC: atmel: Add missing of_node_put() in at91sam9g20ek_audio_probe
Date:   Tue,  5 Apr 2022 09:19:02 +0200
Message-Id: <20220405070419.222010820@linuxfoundation.org>
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

[ Upstream commit f590797fa3c1bccdd19e55441592a23b46aef449 ]

This node pointer is returned by of_parse_phandle() with refcount
incremented in this function.
Calling of_node_put() to avoid the refcount leak.

Fixes: 531f67e41dcd ("ASoC: at91sam9g20ek-wm8731: convert to dt support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20220307124539.1743-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/sam9g20_wm8731.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index 915da92e1ec8..33e43013ff77 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -214,6 +214,7 @@ static int at91sam9g20ek_audio_probe(struct platform_device *pdev)
 	cpu_np = of_parse_phandle(np, "atmel,ssc-controller", 0);
 	if (!cpu_np) {
 		dev_err(&pdev->dev, "dai and pcm info missing\n");
+		of_node_put(codec_np);
 		return -EINVAL;
 	}
 	at91sam9g20ek_dai.cpus->of_node = cpu_np;
-- 
2.34.1




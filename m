Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291BD505839
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244174AbiDRN75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244606AbiDRN4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:56:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493DF2A734;
        Mon, 18 Apr 2022 06:05:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB71060B42;
        Mon, 18 Apr 2022 13:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC88FC385A7;
        Mon, 18 Apr 2022 13:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287134;
        bh=3CgcAMqJTWG/rh9tZWq/btmcwy2kL2QhkhYPfFqd/YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbfIvT80L1tqFq1qJ1l4FatscWm4vlvmYjICSgdZB2r+NIkR3vNdf67nyVStSfK3E
         BqpFg0eWisayuPTbVXYo6I97EOyYPv8FeoD8NRzsLGWtZq3AHOgtsikUeLerl9Akuh
         5jxiRsDp3tHcvP8dFsuuYKninq29xRM+wtyS2/Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 066/218] ASoC: atmel_ssc_dai: Handle errors for clk_enable
Date:   Mon, 18 Apr 2022 14:12:12 +0200
Message-Id: <20220418121201.500077886@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit f9e2ca0640e59d19af0ff285ee5591ed39069b09 ]

As the potential failure of the clk_enable(),
it should be better to check it and return error if fals.

Fixes: cbaadf0f90d6 ("ASoC: atmel_ssc_dai: refactor the startup and shutdown")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220301090637.3776558-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel_ssc_dai.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index 16e459aedffe..5958aafac8eb 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -296,7 +296,10 @@ static int atmel_ssc_startup(struct snd_pcm_substream *substream,
 
 	/* Enable PMC peripheral clock for this SSC */
 	pr_debug("atmel_ssc_dai: Starting clock\n");
-	clk_enable(ssc_p->ssc->clk);
+	ret = clk_enable(ssc_p->ssc->clk);
+	if (ret)
+		return ret;
+
 	ssc_p->mck_rate = clk_get_rate(ssc_p->ssc->clk);
 
 	/* Reset the SSC unless initialized to keep it in a clean state */
-- 
2.34.1




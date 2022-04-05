Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB674F2738
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiDEIFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbiDEH74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A235C1AF3A;
        Tue,  5 Apr 2022 00:56:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EF32B81B18;
        Tue,  5 Apr 2022 07:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A454FC340EE;
        Tue,  5 Apr 2022 07:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145394;
        bh=DuYmSyEzedX7U/nY9Gg5hYz0dMAKEediBXzyg56hMdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qav+hcWE46twwS5cupmpMzvQ03YCwF2/LUhMBY8J5nT6a8PwnWOWSRqVDe8WgHBt/
         taXYdMtS42+jxhD2usR7LdI/LdpRkxkK2KUMTOCpCCgKVvg64MdKLFlN/hxwSsritH
         LdzL8mrAZNZ2OKs6vkgrDBpP5AYSo9uCvHoyL00Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0382/1126] ASoC: atmel_ssc_dai: Handle errors for clk_enable
Date:   Tue,  5 Apr 2022 09:18:49 +0200
Message-Id: <20220405070418.838826040@linuxfoundation.org>
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
index 26e2bc690d86..c1dea8d62416 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -280,7 +280,10 @@ static int atmel_ssc_startup(struct snd_pcm_substream *substream,
 
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




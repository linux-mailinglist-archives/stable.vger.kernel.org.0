Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C2A4F2B1F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347877AbiDEJ2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244947AbiDEIwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1552024BCE;
        Tue,  5 Apr 2022 01:47:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 881ECCE1BF9;
        Tue,  5 Apr 2022 08:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E71FC385A0;
        Tue,  5 Apr 2022 08:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148441;
        bh=4CbGFM1Lbe8DmiPQBMYFTnVQIyjT1+Fi1scJt5CW+h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEp9GTLpYbJ/9LHeOcWLN6nIaphVbnVDJZkIJMYWJxz2v4Ep8QFtnZNhlSa4twtG6
         FxzOm+5u6IGU97tsxmm0LPlDzdls1UB7WiAZdJvLnBKnBheEHZZ+RepY5r0Pi4W1FA
         tV37CcEoYAOyfENmgoHgl89QO9U094IqD+G7HWUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0359/1017] ASoC: mxs-saif: Handle errors for clk_enable
Date:   Tue,  5 Apr 2022 09:21:12 +0200
Message-Id: <20220405070404.941951979@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 2ecf362d220317debf5da376e0390e9f7a3f7b29 ]

As the potential failure of the clk_enable(),
it should be better to check it, like mxs_saif_trigger().

Fixes: d0ba4c014934 ("ASoC: mxs-saif: set a base clock rate for EXTMASTER mode work")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220301081717.3727190-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mxs/mxs-saif.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 6a2d24d48964..879c1221a809 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -455,7 +455,10 @@ static int mxs_saif_hw_params(struct snd_pcm_substream *substream,
 		* basic clock which should be fast enough for the internal
 		* logic.
 		*/
-		clk_enable(saif->clk);
+		ret = clk_enable(saif->clk);
+		if (ret)
+			return ret;
+
 		ret = clk_set_rate(saif->clk, 24000000);
 		clk_disable(saif->clk);
 		if (ret)
-- 
2.34.1




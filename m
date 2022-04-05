Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF58B4F43C9
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350991AbiDEMIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357975AbiDEK1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50778CD335;
        Tue,  5 Apr 2022 03:12:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A65CB81B7A;
        Tue,  5 Apr 2022 10:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6222DC385A1;
        Tue,  5 Apr 2022 10:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153517;
        bh=TqgaRzDre7yag1CqyqM9emE+nY8wsrYrMnO0ieJPUpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xd/TCE+AXbBaVrBZkCLj+JTxF4OEMrvY9TTx3anAoeuDdSNOscAWroWrnYvRDGtp9
         BpNATDdo7t2aazWv50z3CrX1F+Iido19TxAt0q475uhv5MQvF2/OHFBblXj8pgDS4E
         4W+bZLqHjqaN8plo6ZZbt9D7PBxrIEpcbNLQ0Tdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/599] ASoC: fsl_spdif: Disable TX clock when stop
Date:   Tue,  5 Apr 2022 09:29:05 +0200
Message-Id: <20220405070306.309197882@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 6ddf611219ba8f7c8fa0d26b39710a641e7d37a5 ]

The TX clock source may be changed in next case, need to
disable it when stop, otherwise the TX may not work after
changing the clock source, error log is:

aplay: pcm_write:2058: write error: Input/output error

Fixes: a2388a498ad2 ("ASoC: fsl: Add S/PDIF CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/1646879863-27711-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_spdif.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index 15bcb0f38ec9..d01e8d516df1 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -544,6 +544,8 @@ static void fsl_spdif_shutdown(struct snd_pcm_substream *substream,
 		mask = SCR_TXFIFO_AUTOSYNC_MASK | SCR_TXFIFO_CTRL_MASK |
 			SCR_TXSEL_MASK | SCR_USRC_SEL_MASK |
 			SCR_TXFIFO_FSEL_MASK;
+		/* Disable TX clock */
+		regmap_update_bits(regmap, REG_SPDIF_STC, STC_TXCLK_ALL_EN_MASK, 0);
 	} else {
 		scr = SCR_RXFIFO_OFF | SCR_RXFIFO_CTL_ZERO;
 		mask = SCR_RXFIFO_FSEL_MASK | SCR_RXFIFO_AUTOSYNC_MASK|
-- 
2.34.1




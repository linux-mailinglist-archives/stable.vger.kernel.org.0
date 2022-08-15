Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDD5594CFB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245646AbiHPAgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350742AbiHPAgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:36:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C201894E1;
        Mon, 15 Aug 2022 13:37:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72E5CB80EA8;
        Mon, 15 Aug 2022 20:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3930C433D6;
        Mon, 15 Aug 2022 20:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595846;
        bh=yhuN0DL0yv2xRFCMow4wX3R8JWRCMkUfnbUAKDjrUfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzlRNDlXIcex49HLKDKb8U1I6l8zPmejfBBls5zRIzDFt9u/xXIiim4SJS+OSUlBU
         LB+ka3lIStZQDjFbPz7iGhvYtM6fCM59xVjsXoPPqm84SzEvjW51DQYZu3wUmqsPvP
         /Yrxb9Jevu01uPn5bory1N8Ln5674HfGZGj9MRfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0892/1157] ASoC: imx-audmux: Silence a clang warning
Date:   Mon, 15 Aug 2022 20:04:08 +0200
Message-Id: <20220815180515.123236133@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 2f4a8171da06609bb6a063630ed546ee3d93dad7 ]

Change the of_device_get_match_data() cast to (uintptr_t)
to silence the following clang warning:

sound/soc/fsl/imx-audmux.c:301:16: warning: cast to smaller integer type 'enum imx_audmux_type' from 'const void *' [-Wvoid-pointer-to-enum-cast]

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 6a8b8b582db1 ("ASoC: imx-audmux: Remove unused .id_table")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20220526010543.1164793-1-festevam@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-audmux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-audmux.c b/sound/soc/fsl/imx-audmux.c
index dfa05d40b276..a8e5e0f57faf 100644
--- a/sound/soc/fsl/imx-audmux.c
+++ b/sound/soc/fsl/imx-audmux.c
@@ -298,7 +298,7 @@ static int imx_audmux_probe(struct platform_device *pdev)
 		audmux_clk = NULL;
 	}
 
-	audmux_type = (enum imx_audmux_type)of_device_get_match_data(&pdev->dev);
+	audmux_type = (uintptr_t)of_device_get_match_data(&pdev->dev);
 
 	switch (audmux_type) {
 	case IMX31_AUDMUX:
-- 
2.35.1




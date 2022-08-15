Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D772593A1C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344875AbiHOTbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244202AbiHOT32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A355E32A;
        Mon, 15 Aug 2022 11:44:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB07B611DD;
        Mon, 15 Aug 2022 18:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21D3C433D6;
        Mon, 15 Aug 2022 18:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589043;
        bh=yhuN0DL0yv2xRFCMow4wX3R8JWRCMkUfnbUAKDjrUfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkfOykeIpBV7596KxMb/efFs6T1mJtJNkiF1chrmu2gZZ5rM1+44FIqN189xhNE2T
         Tfm2Cxl6tN6VtXjleUXEgiJ4YjKGw4DhYahU5FkvT+Zh/KuMFkM7MXsZHXJDT5p61D
         qaSYyohjZB8ETGnF1yVjfiVAm2xj9DKxNHibhnU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 563/779] ASoC: imx-audmux: Silence a clang warning
Date:   Mon, 15 Aug 2022 20:03:27 +0200
Message-Id: <20220815180401.386328352@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C73F608A81
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbiJVI6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiJVI5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:57:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C6CF53FB;
        Sat, 22 Oct 2022 01:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DC7E60AC7;
        Sat, 22 Oct 2022 07:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD89C433C1;
        Sat, 22 Oct 2022 07:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424960;
        bh=gvy+AFjkeW4zfEWxGpVygqiYoy0/OwkUtGWZjzI5AQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqeTczgi13ZoZqZhR3tURjRbFkw7KittIIlTGBMDl0MRDoBIgqXfWSQ8oi5axfrOr
         /2kogDZXI7y7pkFbasMEQjLGAe34pAK8ABaf0rzZyKuk4jRiOxGmCxW7zMuJ3weOZX
         +n8rDsGTGyjvrsQh4DnNj6nyWikV5IrqG6BL6JQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 341/717] ASoC: stm32: spdifrx: Fix PM disable depth imbalance in stm32_spdifrx_probe
Date:   Sat, 22 Oct 2022 09:23:40 +0200
Message-Id: <20221022072510.568088669@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 0325cc0ac7980e1c7b744aab8df59afab6daeb43 ]

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context. We fix it by moving
pm_runtime_enable to the endding of stm32_spdifrx_probe.

Fixes:ac5e3efd55868 ("ASoC: stm32: spdifrx: add pm_runtime support")

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/20220927142601.64266-3-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_spdifrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/stm/stm32_spdifrx.c b/sound/soc/stm/stm32_spdifrx.c
index 6f7882c4fe6a..60be4894e5fd 100644
--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -1001,8 +1001,6 @@ static int stm32_spdifrx_probe(struct platform_device *pdev)
 	udelay(2);
 	reset_control_deassert(rst);
 
-	pm_runtime_enable(&pdev->dev);
-
 	pcm_config = &stm32_spdifrx_pcm_config;
 	ret = snd_dmaengine_pcm_register(&pdev->dev, pcm_config, 0);
 	if (ret)
@@ -1035,6 +1033,8 @@ static int stm32_spdifrx_probe(struct platform_device *pdev)
 			FIELD_GET(SPDIFRX_VERR_MIN_MASK, ver));
 	}
 
+	pm_runtime_enable(&pdev->dev);
+
 	return ret;
 
 error:
-- 
2.35.1




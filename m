Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C465413F4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358136AbiFGUJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358128AbiFGUIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DA1EBAB5;
        Tue,  7 Jun 2022 11:26:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 927CC6127C;
        Tue,  7 Jun 2022 18:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32FDC385A2;
        Tue,  7 Jun 2022 18:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626377;
        bh=PxGyuL6ReFTTSA/dQVTf/Ns6fdwTRWGkJOcMF8Ss+2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xk7LmyQAafxWKY1JXc6kGdF0LbbaqE1jvUEXIR7xUuMJHE04K1+gXWLIiKovCvCKR
         t40MWHODcml2eEGoAoTzRhdNUHiP05YZ1eOYzw+eLkuik8P/VaECK2yLyLkNxCAO6G
         usnc0QA4yuJdFLFhBMTN0T0cjsD83rENA9lqqRpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 357/772] ASoC: imx-hdmi: Fix refcount leak in imx_hdmi_probe
Date:   Tue,  7 Jun 2022 18:59:09 +0200
Message-Id: <20220607164959.538606095@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ed46731d8e86c8d65f5fc717671e1f1f6c3146d2 ]

of_find_device_by_node() takes reference, we should use put_device()
to release it. when devm_kzalloc() fails, it doesn't have a
put_device(), it will cause refcount leak.
Add missing put_device() to fix this.

Fixes: 6a5f850aa83a ("ASoC: fsl: Add imx-hdmi machine driver")
Fixes: f670b274f7f6 ("ASoC: imx-hdmi: add put_device() after of_find_device_by_node()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220511052740.46903-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/imx-hdmi.c b/sound/soc/fsl/imx-hdmi.c
index 929f69b758af..ec149dc73938 100644
--- a/sound/soc/fsl/imx-hdmi.c
+++ b/sound/soc/fsl/imx-hdmi.c
@@ -126,6 +126,7 @@ static int imx_hdmi_probe(struct platform_device *pdev)
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		ret = -ENOMEM;
+		put_device(&cpu_pdev->dev);
 		goto fail;
 	}
 
-- 
2.35.1




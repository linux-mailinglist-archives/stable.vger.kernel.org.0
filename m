Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D706AF06A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCGSac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjCGS37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA93E399
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:23:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EAB5CCE1C88
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3377C4339E;
        Tue,  7 Mar 2023 18:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213407;
        bh=pVo9CTcdTCogM2tzqn0lqJt1q9wQawngu5IFVOa+R3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NPkpHuRQjkOdw5rpiiaSfh9O4R/A40E3lq2OvTlIRB+uxHMZGs82QFY6tdURDD+A
         UjXs1WrzrJFzCIyWInZa4Zf4sYm8WSXlmV3HHfcRWTsHFZ/ljoruYtuZDXBnIwhOwK
         tj97Tuh5N95lmqWs+EVnUlyCQDldQm3Raq9xs5/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 496/885] media: platform: ti: Add missing check for devm_regulator_get
Date:   Tue,  7 Mar 2023 17:57:10 +0100
Message-Id: <20230307170024.007129640@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit da8e05f84a11c3cc3b0ba0a3c62d20e358002d99 ]

Add check for the return value of devm_regulator_get since it may return
error pointer.

Fixes: 448de7e7850b ("[media] omap3isp: OMAP3 ISP core")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/omap3isp/isp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/ti/omap3isp/isp.c b/drivers/media/platform/ti/omap3isp/isp.c
index 24d2383400b0a..11ae479ee89c8 100644
--- a/drivers/media/platform/ti/omap3isp/isp.c
+++ b/drivers/media/platform/ti/omap3isp/isp.c
@@ -2308,7 +2308,16 @@ static int isp_probe(struct platform_device *pdev)
 
 	/* Regulators */
 	isp->isp_csiphy1.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy1");
+	if (IS_ERR(isp->isp_csiphy1.vdd)) {
+		ret = PTR_ERR(isp->isp_csiphy1.vdd);
+		goto error;
+	}
+
 	isp->isp_csiphy2.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy2");
+	if (IS_ERR(isp->isp_csiphy2.vdd)) {
+		ret = PTR_ERR(isp->isp_csiphy2.vdd);
+		goto error;
+	}
 
 	/* Clocks
 	 *
-- 
2.39.2




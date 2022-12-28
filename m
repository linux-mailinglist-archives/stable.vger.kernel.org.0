Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65EA365783E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbiL1Os5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiL1Osa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:48:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4347B7F1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:48:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 517DC6153B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6458BC433D2;
        Wed, 28 Dec 2022 14:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238908;
        bh=I4ReXCxBHQxCRGL4VTGkps6QkdJ8vIiK1wxjQpiYzb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NlK6CPinhF+XDC6NSxl5YGWPbhiTQCkz6JEjC97/44zsW4anGldHaVIo1Cu97JHm
         Jqb7/vNqnmyiLfYE7F40w1VA0NLvbjar8FnZiJpwpdq9yWrbqOa9ZIvV/Elhb1meYa
         AmYMzNp8AYZgZIzCGYjg7z3T34w+1OfHR91dDCHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Weiss <luca.weiss@fairphone.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/731] soc: qcom: llcc: make irq truly optional
Date:   Wed, 28 Dec 2022 15:32:05 +0100
Message-Id: <20221228144257.066473472@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit c882c899ead3545102a4d71b5fbe73b9e4bc2657 ]

The function platform_get_irq prints an error message into the kernel
log when the irq isn't found.

Since the interrupt is actually optional and not provided by some SoCs,
use platform_get_irq_optional which does not print an error message.

Fixes: c081f3060fab ("soc: qcom: Add support to register LLCC EDAC driver")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221104153041.412020-1-luca.weiss@fairphone.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/llcc-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index cabd8870316d..47d41804fdf6 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -607,7 +607,7 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	drv_data->ecc_irq = platform_get_irq(pdev, 0);
+	drv_data->ecc_irq = platform_get_irq_optional(pdev, 0);
 	if (drv_data->ecc_irq >= 0) {
 		llcc_edac = platform_device_register_data(&pdev->dev,
 						"qcom_llcc_edac", -1, drv_data,
-- 
2.35.1




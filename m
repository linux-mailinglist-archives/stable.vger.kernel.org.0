Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40AE528EC8
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244455AbiEPTrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346949AbiEPTqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:46:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBA3427D1;
        Mon, 16 May 2022 12:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DAAF6155B;
        Mon, 16 May 2022 19:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DF9C385AA;
        Mon, 16 May 2022 19:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730255;
        bh=Dd5bm4NtHHEFcaFf5w6xNS60nrturXKLQxOMwNfw/2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+qGp6MmETdWa2TmtZ9edm8tE7ak3Wqbxn4oV3lSS/wWnWQGQnb6AF6H63y1C5c3f
         iRjx6QQ6BUtOqIuaB6P6nnXtAUBaFW1adBUDxl7Bujs2/2HwhLyH6faKp8pqAXm7Lj
         pHJ8mqZCXta433nR6+Gd608Q+CHdC2D/ZVQkaCUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.4 32/43] slimbus: qcom: Fix IRQ check in qcom_slim_probe
Date:   Mon, 16 May 2022 21:36:43 +0200
Message-Id: <20220516193615.666836040@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
References: <20220516193614.714657361@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit fe503887eed6ea528e144ec8dacfa1d47aa701ac upstream.

platform_get_irq() returns non-zero IRQ number on success,
negative error number on failure.
And the doc of platform_get_irq() provides a usage example:

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0)
        return irq;

Fix the check of return value to catch errors correctly.

Fixes: ad7fcbc308b0 ("slimbus: qcom: Add Qualcomm Slimbus controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220429164917.5202-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ctrl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/slimbus/qcom-ctrl.c
+++ b/drivers/slimbus/qcom-ctrl.c
@@ -515,9 +515,9 @@ static int qcom_slim_probe(struct platfo
 	}
 
 	ctrl->irq = platform_get_irq(pdev, 0);
-	if (!ctrl->irq) {
+	if (ctrl->irq < 0) {
 		dev_err(&pdev->dev, "no slimbus IRQ\n");
-		return -ENODEV;
+		return ctrl->irq;
 	}
 
 	sctrl = &ctrl->ctrl;



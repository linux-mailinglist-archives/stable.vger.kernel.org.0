Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D5F594D96
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243585AbiHPAr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347315AbiHPApz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:45:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79D0AEDA8;
        Mon, 15 Aug 2022 13:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 447366122B;
        Mon, 15 Aug 2022 20:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CF6C433C1;
        Mon, 15 Aug 2022 20:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596098;
        bh=EYeWNRRdqeLTH60vOeNeougrx1JxpB34+HdpnISTfl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1n9RRyMvx0sTjDTZ3dkJcBiK/opGc33CrnJqMQmvfmoi8QhEZsatLcnaywQJ3ILsS
         NzRXzqEqb1/fVkfMjEuU7xzU6OA2vOlW+G8N8W67lyyXIpKfOHO4imUOiLwKoi4xjO
         T8MVbd6FwMGZvQEppart3cBEkZNYQ6xDLbbcNlvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sireesh Kodali <sireeshkodali1@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0937/1157] remoteproc: qcom: wcnss: Fix handling of IRQs
Date:   Mon, 15 Aug 2022 20:04:53 +0200
Message-Id: <20220815180516.989931223@linuxfoundation.org>
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

From: Sireesh Kodali <sireeshkodali1@gmail.com>

[ Upstream commit bed0adac1ded4cb486ba19a3a7e730fbd9a1c9c6 ]

The wcnss_get_irq function is expected to return a value > 0 in the
event that an IRQ is succssfully obtained, but it instead returns 0.
This causes the stop and ready IRQs to never actually be used despite
being defined in the device-tree. This patch fixes that.

Fixes: aed361adca9f ("remoteproc: qcom: Introduce WCNSS peripheral image loader")
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220526141740.15834-2-sireeshkodali1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index 9a223d394087..68f37296b151 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -467,6 +467,7 @@ static int wcnss_request_irq(struct qcom_wcnss *wcnss,
 			     irq_handler_t thread_fn)
 {
 	int ret;
+	int irq_number;
 
 	ret = platform_get_irq_byname(pdev, name);
 	if (ret < 0 && optional) {
@@ -477,14 +478,19 @@ static int wcnss_request_irq(struct qcom_wcnss *wcnss,
 		return ret;
 	}
 
+	irq_number = ret;
+
 	ret = devm_request_threaded_irq(&pdev->dev, ret,
 					NULL, thread_fn,
 					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 					"wcnss", wcnss);
-	if (ret)
+	if (ret) {
 		dev_err(&pdev->dev, "request %s IRQ failed\n", name);
+		return ret;
+	}
 
-	return ret;
+	/* Return the IRQ number if the IRQ was successfully acquired */
+	return irq_number;
 }
 
 static int wcnss_alloc_memory_region(struct qcom_wcnss *wcnss)
-- 
2.35.1




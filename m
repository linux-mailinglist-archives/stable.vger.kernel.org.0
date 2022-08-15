Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1D559453C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244778AbiHOWHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349485AbiHOWGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:06:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7563642EE;
        Mon, 15 Aug 2022 12:37:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABB9DB80EA9;
        Mon, 15 Aug 2022 19:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E497BC433B5;
        Mon, 15 Aug 2022 19:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592265;
        bh=V8H25ZulhY1oWUWS8KPaAgWDB8FzsNqGAGC4m5li3/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JENRT8Rkp00YDKMEbQmrz/p9V7lDHAirhkOBXLz5x4SE8JrR2/O0p6K7yCp0pE6FJ
         487coY55KZNw0E0xw/3TJYqDMTrPDVOFZsUlSsj7x5MApsodEKlnmnIFliK44DFaHT
         WPFpyz0AyotkUyWutxd/K9AV9EM/FfiyWxf/t7bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Halaney <ahalaney@redhat.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0758/1095] usb: dwc3: qcom: fix missing optional irq warnings
Date:   Mon, 15 Aug 2022 20:02:37 +0200
Message-Id: <20220815180500.649676059@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 69bb3520db7cecbccc9e497fc568fa5465c9d43f ]

Not all platforms have all of the four currently supported wakeup
interrupts so use the optional irq helpers when looking up interrupts to
avoid printing error messages when an optional interrupt is not found:

	dwc3-qcom a6f8800.usb: error -ENXIO: IRQ hs_phy_irq not found

Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220713131340.29401-4-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 6cba990da32e..3582fd6dfa14 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -443,9 +443,9 @@ static int dwc3_qcom_get_irq(struct platform_device *pdev,
 	int ret;
 
 	if (np)
-		ret = platform_get_irq_byname(pdev_irq, name);
+		ret = platform_get_irq_byname_optional(pdev_irq, name);
 	else
-		ret = platform_get_irq(pdev_irq, num);
+		ret = platform_get_irq_optional(pdev_irq, num);
 
 	return ret;
 }
-- 
2.35.1




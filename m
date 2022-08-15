Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC1595068
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiHPEmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiHPEk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81983D1E07;
        Mon, 15 Aug 2022 13:33:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E1467CE12E8;
        Mon, 15 Aug 2022 20:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD21C433C1;
        Mon, 15 Aug 2022 20:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595590;
        bh=V8H25ZulhY1oWUWS8KPaAgWDB8FzsNqGAGC4m5li3/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtCnKOoOfJzVMqh20VZDYnwvuryYL4yFhSzzE0jUf+JaVFdozpbTCqjafuXrcq/tz
         rdGpZVht6o000hyqnDsxFHvx6khv+zQLXQ1N3+6cTrEht9/V3EdZdIKRTVuVfKwr+7
         ouGv2ShKSGDlV3IF+ltencmCn5aDXZ2vYJeRXAj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Halaney <ahalaney@redhat.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0812/1157] usb: dwc3: qcom: fix missing optional irq warnings
Date:   Mon, 15 Aug 2022 20:02:48 +0200
Message-Id: <20220815180511.979476499@linuxfoundation.org>
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC22499E49
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1588290AbiAXWbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584587AbiAXWV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56999C0424E2;
        Mon, 24 Jan 2022 12:51:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E789B81061;
        Mon, 24 Jan 2022 20:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D111C340E5;
        Mon, 24 Jan 2022 20:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057491;
        bh=ZFkvLrbQuEXn14yPP2X0Q5NlzUl9AI4o2OqopNOvoAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHzykWs7qiIA7c7VZ9rDOUOQyWnHdQpYBolNIfyMhESmb3lZxAlH9RYUdFhqcJNPb
         ZnD/yvsVWOn4cchjpIY7F0BGEXqN8pxGq5L414ToutLgiu8oA15chuFmYC7b4cHuS7
         XmXtzXO2Fq2IFWD7Lm7k6pPJecY9Q1ZknojZlnC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 787/846] pinctrl/rockchip: fix gpio device creation
Date:   Mon, 24 Jan 2022 19:45:04 +0100
Message-Id: <20220124184128.105321929@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

commit bceb6732f3fd2a55d8f2e518cced1c7555e216b6 upstream.

GPIO nodes are not themselves busses, so passing rockchip_bank_match
here is wrong.  Passing NULL instead uses the standard bus match table
which is more appropriate.

devm_of_platform_populate() shows that this is the normal way to call
of_platform_populate() from a device driver, so in order to match that
more closely also add the pinctrl device as the parent for the newly
created GPIO controllers.

Specifically, using the wrong match here can break dynamic GPIO hogs as
marking the GPIO bank as a bus means that of_platform_notify() will set
OF_POPULATED on new child nodes and if this happens before
of_gpio_notify() is called then the new hog will be skipped as
OF_POPULATED is already set.

Fixes: 9ce9a02039de ("pinctrl/rockchip: drop the gpio related codes")
Signed-off-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20211126151352.1509583-1-john@metanate.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-rockchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2748,7 +2748,7 @@ static int rockchip_pinctrl_probe(struct
 
 	platform_set_drvdata(pdev, info);
 
-	ret = of_platform_populate(np, rockchip_bank_match, NULL, NULL);
+	ret = of_platform_populate(np, NULL, NULL, &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register gpio device\n");
 		return ret;



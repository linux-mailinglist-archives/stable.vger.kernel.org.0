Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585C9417278
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344021AbhIXMsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344156AbhIXMsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:48:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE62C6126A;
        Fri, 24 Sep 2021 12:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487590;
        bh=RbYqApV3RJiuGFmsttC5NlA7eNtOdc5LPz3npf3X0dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxGx0BLWPwHSJYiHMIvdGjoARUbUxzLGBiMTHPisSLPmi7AvVpeZhmO3pfk5wSmuc
         S2gQvZD5bwnAnc99/f9uXTrAdftTMg945sTNGgPrr1FaL11nafFRGzdukHysJLhuD/
         zj/qh9A0FlG+fIrd5Fv5XXjhOVRAgzP+J8y75oLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 4.9 08/26] thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()
Date:   Fri, 24 Sep 2021 14:43:56 +0200
Message-Id: <20210924124328.615866017@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124328.336953942@linuxfoundation.org>
References: <20210924124328.336953942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 02d438f62c05f0d055ceeedf12a2f8796b258c08 upstream.

This error path return success but it should propagate the negative
error code from devm_clk_get().

Fixes: 6c247393cfdd ("thermal: exynos: Add TMU support for Exynos7 SoC")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210810084413.GA23810@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/samsung/exynos_tmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -1372,6 +1372,7 @@ static int exynos_tmu_probe(struct platf
 		data->sclk = devm_clk_get(&pdev->dev, "tmu_sclk");
 		if (IS_ERR(data->sclk)) {
 			dev_err(&pdev->dev, "Failed to get sclk\n");
+			ret = PTR_ERR(data->sclk);
 			goto err_clk;
 		} else {
 			ret = clk_prepare_enable(data->sclk);



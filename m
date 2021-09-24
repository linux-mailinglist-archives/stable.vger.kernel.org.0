Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B3341735A
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344149AbhIXMzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344305AbhIXMxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4186A61278;
        Fri, 24 Sep 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487809;
        bh=7JkoLnTqFRGSu4CDuG7Hv+/U1pOyGjfpqqP4FJJVrg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVIG+LhEevmAvNZabZeNOXSgx8T4pYg+RAy0MKohYIQs1F/QGSuS5OpUwN8JX4wUO
         J9Ja1/saq+KA3LZ9iZgB0OZZQNWgJyIFJFoEjQxWwK8mP62IIxpgA4HlHcODu+X3Bs
         ezelAmiroA2+f/m6oNScBdb0EfY5EBq9oq8Tpou8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.4 20/50] thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()
Date:   Fri, 24 Sep 2021 14:44:09 +0200
Message-Id: <20210924124332.914944338@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
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
@@ -1070,6 +1070,7 @@ static int exynos_tmu_probe(struct platf
 		data->sclk = devm_clk_get(&pdev->dev, "tmu_sclk");
 		if (IS_ERR(data->sclk)) {
 			dev_err(&pdev->dev, "Failed to get sclk\n");
+			ret = PTR_ERR(data->sclk);
 			goto err_clk;
 		} else {
 			ret = clk_prepare_enable(data->sclk);



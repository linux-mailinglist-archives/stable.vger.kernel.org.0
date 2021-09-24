Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741B4417238
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343707AbhIXMqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343883AbhIXMqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:46:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9EA36124C;
        Fri, 24 Sep 2021 12:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487488;
        bh=Dgofh8tSSc35rV9tFdQX8r0iW5bDB8dS7yOc5CNHVV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ii6ouERqqsFhmISN+GBap01ckF5D22j3dbJSKbuLuCwmS6A8alVZk9CmWXsbDv7MT
         zU7uGQWzmYE2qRtVhuQTTiwRmhufv1HZx4plyWf8kBbg5kgCkH7MGaEJoPKetixcDN
         cQ/mWsRtqYVOUGDfEsBDBX+/TIUuBU18iD1B7kHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 4.4 05/23] thermal/drivers/exynos: Fix an error code in exynos_tmu_probe()
Date:   Fri, 24 Sep 2021 14:43:46 +0200
Message-Id: <20210924124328.001025476@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124327.816210800@linuxfoundation.org>
References: <20210924124327.816210800@linuxfoundation.org>
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
@@ -1347,6 +1347,7 @@ static int exynos_tmu_probe(struct platf
 		data->sclk = devm_clk_get(&pdev->dev, "tmu_sclk");
 		if (IS_ERR(data->sclk)) {
 			dev_err(&pdev->dev, "Failed to get sclk\n");
+			ret = PTR_ERR(data->sclk);
 			goto err_clk;
 		} else {
 			ret = clk_prepare_enable(data->sclk);



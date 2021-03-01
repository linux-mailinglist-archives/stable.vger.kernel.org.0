Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D28C328F7D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbhCATwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:52:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242166AbhCAToB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C484165257;
        Mon,  1 Mar 2021 17:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619700;
        bh=dX7ScFUt0rdSyYPxeVINzm8psJX8eoWSmit3uQhjedc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wn3sIFMfaeDoKjU6z/lOO9xPC92D10xUQH03MNXFG8c3rnb5axWMQaoHjadl5Bhwg
         4+NdnKBdFnCFrkyuHhTwhcPzReT2Ezy/LCdCAMksmBhUsIP5zR7I0DWZbPCzQhHDUc
         EuDA+IG6HG5dt86EyvPoWsGPoabBVZ21l3GGzEqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.10 549/663] soc: samsung: exynos-asv: dont defer early on not-supported SoCs
Date:   Mon,  1 Mar 2021 17:13:17 +0100
Message-Id: <20210301161209.034901632@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 0458b88267c637fb872b0359da9ff0b243081e9e upstream.

Check if the SoC is really supported before gathering the needed
resources. This fixes endless deferred probe on some SoCs other than
Exynos5422 (like Exynos5410).

Fixes: 5ea428595cc5 ("soc: samsung: Add Exynos Adaptive Supply Voltage driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Link: https://lore.kernel.org/r/20201207190517.262051-2-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/samsung/exynos-asv.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/soc/samsung/exynos-asv.c
+++ b/drivers/soc/samsung/exynos-asv.c
@@ -119,11 +119,6 @@ static int exynos_asv_probe(struct platf
 	u32 product_id = 0;
 	int ret, i;
 
-	cpu_dev = get_cpu_device(0);
-	ret = dev_pm_opp_get_opp_count(cpu_dev);
-	if (ret < 0)
-		return -EPROBE_DEFER;
-
 	asv = devm_kzalloc(&pdev->dev, sizeof(*asv), GFP_KERNEL);
 	if (!asv)
 		return -ENOMEM;
@@ -144,6 +139,11 @@ static int exynos_asv_probe(struct platf
 		return -ENODEV;
 	}
 
+	cpu_dev = get_cpu_device(0);
+	ret = dev_pm_opp_get_opp_count(cpu_dev);
+	if (ret < 0)
+		return -EPROBE_DEFER;
+
 	ret = of_property_read_u32(pdev->dev.of_node, "samsung,asv-bin",
 				   &asv->of_bin);
 	if (ret < 0)



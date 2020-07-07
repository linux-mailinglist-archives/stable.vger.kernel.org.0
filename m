Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC021717F
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgGGPVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbgGGPVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:21:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58C8A206E2;
        Tue,  7 Jul 2020 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135269;
        bh=Yb/kN+Ykzu3y1QxV3gSKWsc82uPftmNrmA3t8MPJMyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTjyLkOSdkpwkwYk5BDzu4L1QzK0DeDjczK9ClNCjRuG8T8PCIEhtUxxD3FhFUHzq
         gkqEGmo65kXgXgKjIAsxO1cEPfFawVDI7PBX6LKmVuceOP4kRRnDIiBQXMlqC8ZGGa
         5RJGaOLbrxaz7/0mwvzc1lN91dsdSJyzPmSiTPfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Van Do <van.do.xw@renesas.com>,
        Dien Pham <dien.pham.ry@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Niklas Soderlund <niklas.soderlund+renesas@ragnatech.se>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/65] thermal/drivers/rcar_gen3: Fix undefined temperature if negative
Date:   Tue,  7 Jul 2020 17:17:12 +0200
Message-Id: <20200707145754.075806633@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dien Pham <dien.pham.ry@renesas.com>

[ Upstream commit 5f8f06425a0dcdad7bedbb77e67f5c65ab4dacfc ]

As description for DIV_ROUND_CLOSEST in file include/linux/kernel.h.
  "Result is undefined for negative divisors if the dividend variable
   type is unsigned and for negative dividends if the divisor variable
   type is unsigned."

In current code, the FIXPT_DIV uses DIV_ROUND_CLOSEST but has not
checked sign of divisor before using. It makes undefined temperature
value in case the value is negative.

This patch fixes to satisfy DIV_ROUND_CLOSEST description
and fix bug too. Note that the variable name "reg" is not good
because it should be the same type as rcar_gen3_thermal_read().
However, it's better to rename the "reg" in a further patch as
cleanup.

Signed-off-by: Van Do <van.do.xw@renesas.com>
Signed-off-by: Dien Pham <dien.pham.ry@renesas.com>
[shimoda: minor fixes, add Fixes tag]
Fixes: 564e73d283af ("thermal: rcar_gen3_thermal: Add R-Car Gen3 thermal driver")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Niklas Soderlund <niklas.soderlund+renesas@ragnatech.se>
Tested-by: Niklas Soderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/1593085099-2057-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_gen3_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 755d2b5bd2c2b..1ab2ffff4e7c7 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -169,7 +169,7 @@ static int rcar_gen3_thermal_get_temp(void *devdata, int *temp)
 {
 	struct rcar_gen3_thermal_tsc *tsc = devdata;
 	int mcelsius, val;
-	u32 reg;
+	int reg;
 
 	/* Read register and convert to mili Celsius */
 	reg = rcar_gen3_thermal_read(tsc, REG_GEN3_TEMP) & CTEMP_MASK;
-- 
2.25.1




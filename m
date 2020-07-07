Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48383217220
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbgGGP3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730165AbgGGPZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:25:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D783F2083B;
        Tue,  7 Jul 2020 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135507;
        bh=SYFssJ2fYNETHUelv4SR9+zQb3uOZ92wRAwxCOFXqBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYgbedhahGM8m+qtSoqoky909T67A4l+lMiRJm4a+P5Y4HjoRB+ngINX410VengL2
         XRBgaPntd0Mjnzd/CbhWyOCGusiBfYvKcv1Uy3Nd4hR8rf3qIlQ9y1QPuuyfrhqJWx
         TVNITh+iSVHYIdGj5DkWwsFwkwVB5LUzqpA1ZNXc=
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
Subject: [PATCH 5.7 069/112] thermal/drivers/rcar_gen3: Fix undefined temperature if negative
Date:   Tue,  7 Jul 2020 17:17:14 +0200
Message-Id: <20200707145804.284375172@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
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
index 58fe7c1ef00b1..c48c5e9b8f203 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -167,7 +167,7 @@ static int rcar_gen3_thermal_get_temp(void *devdata, int *temp)
 {
 	struct rcar_gen3_thermal_tsc *tsc = devdata;
 	int mcelsius, val;
-	u32 reg;
+	int reg;
 
 	/* Read register and convert to mili Celsius */
 	reg = rcar_gen3_thermal_read(tsc, REG_GEN3_TEMP) & CTEMP_MASK;
-- 
2.25.1




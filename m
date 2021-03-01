Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A57329157
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhCAUYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:24:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243138AbhCAUS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:18:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C85560235;
        Mon,  1 Mar 2021 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621813;
        bh=eH5OrqRRJLwP1cxpsnU1SbDPdNPeWOp0IuBJ/9hQmk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQOamK0od7QivgqNxOPqpVGGh8lr4MY6ROrsKphVcvHkX4zVVIvC/Tc7rXz6yNIsd
         YzeuwAPxbDVziF+tV9ehG1fxxp8t0qk1hRIpnX2gSeVAP534plBvfhB+8Qodzsi4N7
         ztC5FX+BOX88HCMXiE8I4Z8W19M3BrhQlw47MjEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 5.11 653/775] soc: samsung: exynos-asv: handle reading revision register error
Date:   Mon,  1 Mar 2021 17:13:41 +0100
Message-Id: <20210301161233.653983104@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 4561560dfb4f847a0b327d48bdd1f45bf1b6261f upstream.

If regmap_read() fails, the product_id local variable will contain
random value from the stack.  Do not try to parse such value and fail
the ASV driver probe.

Fixes: 5ea428595cc5 ("soc: samsung: Add Exynos Adaptive Supply Voltage driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Link: https://lore.kernel.org/r/20201207190517.262051-3-krzk@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/samsung/exynos-asv.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/soc/samsung/exynos-asv.c
+++ b/drivers/soc/samsung/exynos-asv.c
@@ -129,7 +129,13 @@ static int exynos_asv_probe(struct platf
 		return PTR_ERR(asv->chipid_regmap);
 	}
 
-	regmap_read(asv->chipid_regmap, EXYNOS_CHIPID_REG_PRO_ID, &product_id);
+	ret = regmap_read(asv->chipid_regmap, EXYNOS_CHIPID_REG_PRO_ID,
+			  &product_id);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Cannot read revision from ChipID: %d\n",
+			ret);
+		return -ENODEV;
+	}
 
 	switch (product_id & EXYNOS_MASK) {
 	case 0xE5422000:



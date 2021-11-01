Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085764416BC
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhKAJ2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232100AbhKAJ05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:26:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31EAE610A8;
        Mon,  1 Nov 2021 09:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758543;
        bh=pNrXwoyuWA4i11ayGcBrDb14dm/YtgyFAiA2VuHlrFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycsB+wZZVpzq/BXdQGXeFN7vvJo70zmImqiZ+fMimX7W9hWr4R8xgq+C1ldLWy1pK
         6eRIRK9zG4/s99W08kcjXHUDoBFe+I6Q6pANRFcYr1ljJLBNc57+mVHmsFZS0ICy9f
         iDqPjmoBnKm/Ibn+1RKpdwAmGgcVV/N+UaQHXUTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehoon Chung <jh80.chung@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Christian Hewitt <christianshewitt@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 18/35] mmc: dw_mmc: exynos: fix the finding clock sample value
Date:   Mon,  1 Nov 2021 10:17:30 +0100
Message-Id: <20211101082455.827333246@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaehoon Chung <jh80.chung@samsung.com>

commit 697542bceae51f7620af333b065dd09d213629fb upstream.

Even though there are candiates value if can't find best value, it's
returned -EIO. It's not proper behavior.
If there is not best value, use a first candiate value to work eMMC.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Christian Hewitt <christianshewitt@gmail.com>
Cc: stable@vger.kernel.org
Fixes: c537a1c5ff63 ("mmc: dw_mmc: exynos: add variable delay tuning sequence")
Link: https://lore.kernel.org/r/20211022082106.1557-1-jh80.chung@samsung.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc-exynos.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -455,6 +455,18 @@ static s8 dw_mci_exynos_get_best_clksmpl
 		}
 	}
 
+	/*
+	 * If there is no cadiates value, then it needs to return -EIO.
+	 * If there are candiates values and don't find bset clk sample value,
+	 * then use a first candiates clock sample value.
+	 */
+	for (i = 0; i < iter; i++) {
+		__c = ror8(candiates, i);
+		if ((__c & 0x1) == 0x1) {
+			loc = i;
+			goto out;
+		}
+	}
 out:
 	return loc;
 }
@@ -485,6 +497,8 @@ static int dw_mci_exynos_execute_tuning(
 		priv->tuned_sample = found;
 	} else {
 		ret = -EIO;
+		dev_warn(&mmc->class_dev,
+			"There is no candiates value about clksmpl!\n");
 	}
 
 	return ret;



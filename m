Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DE544175F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbhKAJf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233593AbhKAJdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:33:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DB106126A;
        Mon,  1 Nov 2021 09:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758705;
        bh=1L6HOAZc3NguJR8Z1xZ9cpvltmPs7kriAtdzSkzbNdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3x39UYkuWdYRI0yygXKFu9x4cwtgc17CiFzNDKmmZGCz/hbaMOsfVcHrqEsnffvg
         dekrhwndt3+6GQtrd4KexS4lFCZXNfYa+G4k93c2lqQUoWyYMRBgiqPWsb9ghq9Bf1
         YdGV1Iefrv7UqQn4k0PeD5Jtt9PH4HQ9KsqRqJ6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehoon Chung <jh80.chung@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Christian Hewitt <christianshewitt@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 23/77] mmc: dw_mmc: exynos: fix the finding clock sample value
Date:   Mon,  1 Nov 2021 10:17:11 +0100
Message-Id: <20211101082516.790385948@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
@@ -464,6 +464,18 @@ static s8 dw_mci_exynos_get_best_clksmpl
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
@@ -494,6 +506,8 @@ static int dw_mci_exynos_execute_tuning(
 		priv->tuned_sample = found;
 	} else {
 		ret = -EIO;
+		dev_warn(&mmc->class_dev,
+			"There is no candiates value about clksmpl!\n");
 	}
 
 	return ret;



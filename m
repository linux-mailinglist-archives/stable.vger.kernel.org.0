Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D7426F1DA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgIRCH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgIRCH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C11C239A1;
        Fri, 18 Sep 2020 02:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394846;
        bh=XxxrY+0LVUDKUPM63mF0qJ4HNb8rZ1kPsW2WuUNjq5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F02K7EhkLx1vWvVGfAzlsmHxoZ5/TRnm/90+BaHtWqWVEe4DU3DbuM9F4JLJxuW9h
         ifgofcbrY30JNv8jAPBFRiw0BOTBXfRSP9j34JosqdIzDjE1cJ+tKi2Akmk+RLMrLZ
         JLKEZ9nKmbuMLIKSvCcAqn2dur0y1VLDMK5KbtNg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 303/330] mtd: rawnand: omap_elm: Fix runtime PM imbalance on error
Date:   Thu, 17 Sep 2020 22:00:43 -0400
Message-Id: <20200918020110.2063155-303-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 37f7212148cf1d796135cdf8d0c7fee13067674b ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200522104008.28340-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/omap_elm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/raw/omap_elm.c b/drivers/mtd/nand/raw/omap_elm.c
index 5502ffbdd1e6d..6e0e31eab7cce 100644
--- a/drivers/mtd/nand/raw/omap_elm.c
+++ b/drivers/mtd/nand/raw/omap_elm.c
@@ -411,6 +411,7 @@ static int elm_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	if (pm_runtime_get_sync(&pdev->dev) < 0) {
 		ret = -EINVAL;
+		pm_runtime_put_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
 		dev_err(&pdev->dev, "can't enable clock\n");
 		return ret;
-- 
2.25.1


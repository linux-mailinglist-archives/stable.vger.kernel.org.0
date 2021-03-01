Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC1C32889D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbhCARnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236958AbhCARfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:35:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EBDF64FB8;
        Mon,  1 Mar 2021 16:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617663;
        bh=NdPjm/sp0kpByO+D4zxa+oJ6LkSr0cOqLLD3Cu9+Whw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzfGWN/kt0uyedHwZ0fye51NBJOdoCz1jVy4a7/9gR87jylhRR1J9YL0mQ27NReQz
         vkup0cyOgKY2TaDNmiqMkuFRgIoEoFpCGzn5Cda9x0gDcpKA74wjENT+o1FsWxA5G8
         qGI8OKy/xNCGAmyVEgk/XKhQpZ0bFIqe3NjYsZJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/340] regulator: axp20x: Fix reference cout leak
Date:   Mon,  1 Mar 2021 17:11:36 +0100
Message-Id: <20210301161055.798658853@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit e78bf6be7edaacb39778f3a89416caddfc6c6d70 ]

Decrements the reference count of device node and its child node.

Fixes: dfe7a1b058bb ("regulator: AXP20x: Add support for regulators subsystem")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210120123313.107640-1-bianpan2016@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/axp20x-regulator.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index aefc351bfed59..86a3c2dd05848 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -1072,7 +1072,7 @@ static int axp20x_set_dcdc_freq(struct platform_device *pdev, u32 dcdcfreq)
 static int axp20x_regulator_parse_dt(struct platform_device *pdev)
 {
 	struct device_node *np, *regulators;
-	int ret;
+	int ret = 0;
 	u32 dcdcfreq = 0;
 
 	np = of_node_get(pdev->dev.parent->of_node);
@@ -1087,13 +1087,12 @@ static int axp20x_regulator_parse_dt(struct platform_device *pdev)
 		ret = axp20x_set_dcdc_freq(pdev, dcdcfreq);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "Error setting dcdc frequency: %d\n", ret);
-			return ret;
 		}
-
 		of_node_put(regulators);
 	}
 
-	return 0;
+	of_node_put(np);
+	return ret;
 }
 
 static int axp20x_set_dcdc_workmode(struct regulator_dev *rdev, int id, u32 workmode)
-- 
2.27.0




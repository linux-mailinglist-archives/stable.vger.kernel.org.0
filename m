Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48E8451429
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349073AbhKOUCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:02:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344315AbhKOTYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EAAC6365D;
        Mon, 15 Nov 2021 18:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002540;
        bh=iC7IF6dVqGVqWQIH98l7aYnkMCcZP24pH6pirizffw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfrzwe5ZBBnqxKCwvzweTOBrP0eshpBSBo9fyr/Il+iPw4RIZluShLC0S9b6JRUpW
         G65yU2uo7IdcisFfSkLzqlY03XFBMWPbZbfjhKTN6Ie8kgAkN5MB+v1+8kAkYj4+KZ
         uYiP9iCeNaws18+7arK7zQd5cZyiZLSaMi0JsyvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 607/917] power: reset: at91-reset: check properly the return value of devm_of_iomap
Date:   Mon, 15 Nov 2021 18:01:42 +0100
Message-Id: <20211115165449.360012866@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit f558c8072c3461b65c12c0068b108f78cebc8246 ]

devm_of_iomap() returns error code or valid pointer. Check its return
value with IS_ERR().

Fixes: bd3127733f2c ("power: reset: at91-reset: use devm_of_iomap")
Reported-by: Cristian Birsan <cristian.birsan@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/at91-reset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/reset/at91-reset.c b/drivers/power/reset/at91-reset.c
index 026649409135c..64def79d557a8 100644
--- a/drivers/power/reset/at91-reset.c
+++ b/drivers/power/reset/at91-reset.c
@@ -193,7 +193,7 @@ static int __init at91_reset_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	reset->rstc_base = devm_of_iomap(&pdev->dev, pdev->dev.of_node, 0, NULL);
-	if (!reset->rstc_base) {
+	if (IS_ERR(reset->rstc_base)) {
 		dev_err(&pdev->dev, "Could not map reset controller address\n");
 		return -ENODEV;
 	}
@@ -203,7 +203,7 @@ static int __init at91_reset_probe(struct platform_device *pdev)
 		for_each_matching_node_and_match(np, at91_ramc_of_match, &match) {
 			reset->ramc_lpr = (u32)match->data;
 			reset->ramc_base[idx] = devm_of_iomap(&pdev->dev, np, 0, NULL);
-			if (!reset->ramc_base[idx]) {
+			if (IS_ERR(reset->ramc_base[idx])) {
 				dev_err(&pdev->dev, "Could not map ram controller address\n");
 				of_node_put(np);
 				return -ENODEV;
-- 
2.33.0




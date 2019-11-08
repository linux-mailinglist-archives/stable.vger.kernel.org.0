Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84AAF47B3
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391466AbfKHLwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390511AbfKHLrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E146222CE;
        Fri,  8 Nov 2019 11:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213631;
        bh=HShIySpLPUNeFNOt26VHwgmGLAKWF2+VsW+uRVUMwGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2kdjwde4yt8/g75V3htuFEB5bP1lURzZOLISopP7aAAlhzZHWBL7/v5zfWHQLKYHu
         kFT5yxdJea5SaDxwqpFoXCFTC9MEI3R9Z/TVdiPrVy6hdV/czy8wPvGqt7uwfp9MqI
         PcK2hW6Tu1W0J3EBho61LcjeHPzxFyw5RKRlcKlA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 58/64] power: reset: at91-poweroff: do not procede if at91_shdwc is allocated
Date:   Fri,  8 Nov 2019 06:45:39 -0500
Message-Id: <20191108114545.15351-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 9f1e44774be578fb92776add95f1fcaf8284d692 ]

There should be only one instance of struct shdwc in the system. This is
referenced through at91_shdwc. Return in probe if at91_shdwc is already
allocated.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/at91-sama5d2_shdwc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/reset/at91-sama5d2_shdwc.c b/drivers/power/reset/at91-sama5d2_shdwc.c
index 90b0b5a70ce52..04ca990e8f6cb 100644
--- a/drivers/power/reset/at91-sama5d2_shdwc.c
+++ b/drivers/power/reset/at91-sama5d2_shdwc.c
@@ -246,6 +246,9 @@ static int __init at91_shdwc_probe(struct platform_device *pdev)
 	if (!pdev->dev.of_node)
 		return -ENODEV;
 
+	if (at91_shdwc)
+		return -EBUSY;
+
 	at91_shdwc = devm_kzalloc(&pdev->dev, sizeof(*at91_shdwc), GFP_KERNEL);
 	if (!at91_shdwc)
 		return -ENOMEM;
-- 
2.20.1


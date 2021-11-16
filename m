Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C228D4539F2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbhKPTUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhKPTUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 14:20:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14C4363222;
        Tue, 16 Nov 2021 19:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637090276;
        bh=0+IHl2FA82SiI/XKL9laqutnEaqH7vcJ/2XO06Xc6T4=;
        h=From:To:Cc:Subject:Date:From;
        b=so3iaScYnycVZrUAidEV+7XuokyfXNwjYX7hN2vz6s/ql1R+U4o+GFndoXq1v080E
         c2nk4OaFbraZRjnnJ3AQ/nenYUZ++ywOjoJZLX+/AfSzmOTL10IGn8QFLLQKiX4c5n
         0b87aZETRWv8GJjt52NPS1TIc/TY4BIKcSbOLNCMOA6IuWusdRiyLvv8zOvJVlsSRC
         bv9ZZAotzzIDhoKcQEA07Z0jMbPDpGlah0U8CaDM8vurmbTkp3ae0u7SzUe3zbt7Vg
         tzvrx6jKOvf5Ug3gSaWAFZBe06oTN4hR2kwSrzKRkcCpLekysI3BwEQmrWRAG9cR1T
         5IWCDRQ3xex7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Bin <tangbin@cmss.chinamobile.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        sebastian.reichel@collabora.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/65] Input: cpcap-pwrbutton - handle errors from platform_get_irq()
Date:   Tue, 16 Nov 2021 14:16:46 -0500
Message-Id: <20211116191754.2419097-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit 58ae4004b9c4bb040958cf73986b687a5ea4d85d ]

The function cpcap_power_button_probe() does not perform
sufficient error checking after executing platform_get_irq(),
thus fix it.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20210802121740.8700-1-tangbin@cmss.chinamobile.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/cpcap-pwrbutton.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/input/misc/cpcap-pwrbutton.c b/drivers/input/misc/cpcap-pwrbutton.c
index 0abef63217e21..372cb44d06357 100644
--- a/drivers/input/misc/cpcap-pwrbutton.c
+++ b/drivers/input/misc/cpcap-pwrbutton.c
@@ -54,9 +54,13 @@ static irqreturn_t powerbutton_irq(int irq, void *_button)
 static int cpcap_power_button_probe(struct platform_device *pdev)
 {
 	struct cpcap_power_button *button;
-	int irq = platform_get_irq(pdev, 0);
+	int irq;
 	int err;
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
 	button = devm_kmalloc(&pdev->dev, sizeof(*button), GFP_KERNEL);
 	if (!button)
 		return -ENOMEM;
-- 
2.33.0


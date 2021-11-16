Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED844539C3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239766AbhKPTHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:07:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239755AbhKPTHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 14:07:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDD686321A;
        Tue, 16 Nov 2021 19:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637089486;
        bh=0+IHl2FA82SiI/XKL9laqutnEaqH7vcJ/2XO06Xc6T4=;
        h=From:To:Cc:Subject:Date:From;
        b=WdWwC9gegYvsch8ctXsZ4lC9rh6N73lRXaRoZ7dVAH6Ryl3kjYVErEataKFRaoXlX
         OWErFYNWEsnW/G78aS0928KBCioyUxtBEpNZLCt3b8tcm5k6HWhW+m1v2vAcSpHH3B
         BLhTHONwW8xHIrJylCXoxpdpBqn0hxPgsR/S4kb2lHgcTPTMRupxRGK/XbXSxME58u
         x0pg5mIwtchvFCaWGsj3ltlldNxjxqNH/qlTPwPedJo0Knwio/g9+P+7+8jVq1mQvD
         vQC4hqwOIeaZSrwWcIq9veWQ5ZpPg2+a6GuDupSefn7yWIBp495BRKCeFtG2BBAirF
         mW7+Gr7w+1Hiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Bin <tangbin@cmss.chinamobile.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        sebastian.reichel@collabora.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/65] Input: cpcap-pwrbutton - handle errors from platform_get_irq()
Date:   Tue, 16 Nov 2021 14:03:21 -0500
Message-Id: <20211116190443.2418144-1-sashal@kernel.org>
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


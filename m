Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10884013A3
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbhIFB1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240477AbhIFBZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:25:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEDF96115A;
        Mon,  6 Sep 2021 01:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891340;
        bh=c4O0i1G9vQwlfugXB5GKGILv3p/pg/WFfWyrERkDfDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XnaTar+6ggPvJ5kODakNN/cPsXgqXt7CArwRpG6nC8zJ1f95YVqyc+k/6RhtKp5Ow
         X6SDbNbkSGRCBsCL3rWxKsB7arzbK8lNv50w4HNFhoCfqmR8cDemOwstDQidn+wDO4
         kkCAxp2kHIkx+7QsWQMNpdbYi7os7KE6rtLlF3zmtl36YqIhSrlOk+Da0dzflEJqA7
         MvC2jgkS8x5uVvaVVt5ztwQDf8UTJ2dzUbDq7V/niGg5KnliU1/WHmd94waRzNqYUI
         C3BYBqAp1F6L9w3Il8p2Uyx5YCDkPSg/cKrBH0vr78OAHbIb8+OEzFRw9RiKoEErmG
         pA7/hNa4veCLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/39] power: supply: smb347-charger: Add missing pin control activation
Date:   Sun,  5 Sep 2021 21:21:36 -0400
Message-Id: <20210906012153.929962-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit efe2175478d5237949e33c84d9a722fc084b218c ]

Pin control needs to be activated by setting the enable bit, otherwise
hardware rejects all pin changes. Previously this stayed unnoticed on
Nexus 7 because pin control was enabled by default after rebooting from
downstream kernel, which uses driver that enables the bit and charger
registers are non-volatile until power supply (battery) is disconnected.
Configure the pin control enable bit. This fixes the potentially
never-enabled charging on devices that use pin control.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/smb347-charger.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/power/supply/smb347-charger.c b/drivers/power/supply/smb347-charger.c
index 8cfbd8d6b478..912e2184f918 100644
--- a/drivers/power/supply/smb347-charger.c
+++ b/drivers/power/supply/smb347-charger.c
@@ -56,6 +56,7 @@
 #define CFG_PIN_EN_CTRL_ACTIVE_LOW		0x60
 #define CFG_PIN_EN_APSD_IRQ			BIT(1)
 #define CFG_PIN_EN_CHARGER_ERROR		BIT(2)
+#define CFG_PIN_EN_CTRL				BIT(4)
 #define CFG_THERM				0x07
 #define CFG_THERM_SOFT_HOT_COMPENSATION_MASK	0x03
 #define CFG_THERM_SOFT_HOT_COMPENSATION_SHIFT	0
@@ -725,6 +726,15 @@ static int smb347_hw_init(struct smb347_charger *smb)
 	if (ret < 0)
 		goto fail;
 
+	/* Activate pin control, making it writable. */
+	switch (smb->enable_control) {
+	case SMB3XX_CHG_ENABLE_PIN_ACTIVE_LOW:
+	case SMB3XX_CHG_ENABLE_PIN_ACTIVE_HIGH:
+		ret = regmap_set_bits(smb->regmap, CFG_PIN, CFG_PIN_EN_CTRL);
+		if (ret < 0)
+			goto fail;
+	}
+
 	/*
 	 * Make the charging functionality controllable by a write to the
 	 * command register unless pin control is specified in the platform
-- 
2.30.2


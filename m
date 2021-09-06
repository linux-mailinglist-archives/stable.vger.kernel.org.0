Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC76401312
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238771AbhIFBX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239450AbhIFBWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:22:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 562BA610FC;
        Mon,  6 Sep 2021 01:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891282;
        bh=mKoCUpunYJSiaTBHgdPWAanw3UzSM4Xr6FEPAZKBpVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwFMD3SpJ/ExFXtGbncclA/m6+L/iRcATGJ3fwhnoiv3ou5j0swi2SW2FVbgJhfnn
         5dPfQCNcrfxnNjC7WF8oc0+aha183tJ7mKeFrNmO3AjXr+8+sc5ICkIW9pbZJzLYbs
         kJ3t5yzMai26t1kNn0u3PW1l5kAQId3OGJg6K5RvJCsUHyEx5l8F0ZaNX6xkqXin1a
         jMPpmSxfi027zfFNvdOu7ZfXHkPmIzoJD76EuPUOedP/YNN/ZjGJCgvRiF6Enp5o1N
         hMWuWL2of0bhTv0twFTS8qL7nSKBLA+P8vqNAtjewSOqCOIhBQvrG1tgKGc/D/UGUi
         tlsH6jLg8uQgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 23/46] power: supply: smb347-charger: Add missing pin control activation
Date:   Sun,  5 Sep 2021 21:20:28 -0400
Message-Id: <20210906012052.929174-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
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
index 3376f42d46c3..25d239f2330e 100644
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


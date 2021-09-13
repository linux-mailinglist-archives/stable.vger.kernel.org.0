Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995D8409383
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241181AbhIMOVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345590AbhIMOTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46DA861B06;
        Mon, 13 Sep 2021 13:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540760;
        bh=rvHCwWEs1NJnaLFZS2ViQ2ziBN1C7hXmykRAgJORJVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLii3zjL8gt1FhemWjxwvkIG7gm2vZdZwk37oHv9qjVC2/1Yv0s/qeMeQbnz62p8w
         cChUpcEDcmMpWogi9bJsPYmjWCSgHZimPo0XkrfSu5Ztfe4VQCOZLpf/mZJk4Zd/V5
         a0bvQjVJInzn+TN55H/GZv+Cq0iCgjMqyu6JCqeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 023/334] power: supply: smb347-charger: Add missing pin control activation
Date:   Mon, 13 Sep 2021 15:11:17 +0200
Message-Id: <20210913131114.187050021@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index df240420f2de..9d8c2fadd4d0 100644
--- a/drivers/power/supply/smb347-charger.c
+++ b/drivers/power/supply/smb347-charger.c
@@ -55,6 +55,7 @@
 #define CFG_PIN_EN_CTRL_ACTIVE_LOW		0x60
 #define CFG_PIN_EN_APSD_IRQ			BIT(1)
 #define CFG_PIN_EN_CHARGER_ERROR		BIT(2)
+#define CFG_PIN_EN_CTRL				BIT(4)
 #define CFG_THERM				0x07
 #define CFG_THERM_SOFT_HOT_COMPENSATION_MASK	0x03
 #define CFG_THERM_SOFT_HOT_COMPENSATION_SHIFT	0
@@ -724,6 +725,15 @@ static int smb347_hw_init(struct smb347_charger *smb)
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




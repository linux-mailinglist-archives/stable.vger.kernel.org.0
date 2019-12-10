Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663211196C4
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfLJV24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:28:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbfLJVKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35FAC246AF;
        Tue, 10 Dec 2019 21:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012217;
        bh=kag2uqw+ZN2yuHEHw/hWmnMaEuLq0RtILM6As/BgrTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGvDLPDJSb9A5Zr6IpxZMa9HXAcNJXrRlb4KIZh9i/24GM2oVGYJCBa5BVs+IoM4g
         hEGdcS4JzVy0/OcqObOd2SHmcydyuQDDICec503OxnNdy2X/56rtSzXMmOjzFJ9yMo
         RdOnFharZ6AYTG4bKflRlIoXHNNVXm2ezJ24vn4c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lingling Xu <ling_ling.xu@unisoc.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 168/350] spi: sprd: adi: Add missing lock protection when rebooting
Date:   Tue, 10 Dec 2019 16:04:33 -0500
Message-Id: <20191210210735.9077-129-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lingling Xu <ling_ling.xu@unisoc.com>

[ Upstream commit 91ea1d70607e374b014b4b9bea771ce661f9f64b ]

When rebooting the system, we should lock the watchdog after
configuration to make sure the watchdog can reboot the system
successfully.

Signed-off-by: Lingling Xu <ling_ling.xu@unisoc.com>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Link: https://lore.kernel.org/r/7b04711127434555e3a1a86bc6be99860cd86668.1572257085.git.baolin.wang@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd-adi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index 9a051286f1207..9613cfe3c0a25 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -393,6 +393,9 @@ static int sprd_adi_restart_handler(struct notifier_block *this,
 	val |= BIT_WDG_RUN | BIT_WDG_RST;
 	sprd_adi_write(sadi, sadi->slave_pbase + REG_WDG_CTRL, val);
 
+	/* Lock the watchdog */
+	sprd_adi_write(sadi, sadi->slave_pbase + REG_WDG_LOCK, ~WDG_UNLOCK_KEY);
+
 	mdelay(1000);
 
 	dev_emerg(sadi->dev, "Unable to restart system\n");
-- 
2.20.1


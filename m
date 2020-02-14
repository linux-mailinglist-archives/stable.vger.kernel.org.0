Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A9815F216
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391975AbgBNSG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731605AbgBNPyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEC40222C4;
        Fri, 14 Feb 2020 15:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695690;
        bh=RAbthy+G2lB0nNHDZTr4dUxOkTT5aKM66BXOrQ6RQ/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btO5qHbpnyrYRJy6kYNATcxP/uT8LXUmWwJI+FrVUCgDscWsUKVuNWWjRyjHnMZq+
         JiI5l/PTPELjVEbVNlKGqPbKdTMovs4XMM5tVGMJm9il+Hxdo0W5pCNhV3iRB18ZlQ
         wRMBTCwPpAarIV1rxEpkdDcLzqHGlHWXInitF4nc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 274/542] reset: uniphier: Add SCSSI reset control for each channel
Date:   Fri, 14 Feb 2020 10:44:26 -0500
Message-Id: <20200214154854.6746-274-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit f4aec227e985e31d2fdc5608daf48e3de19157b7 ]

SCSSI has reset controls for each channel in the SoCs newer than Pro4,
so this adds missing reset controls for channel 1, 2 and 3. And more, this
moves MCSSI reset ID after SCSSI.

Fixes: 6b39fd590aeb ("reset: uniphier: add reset control support for SPI")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Acked-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-uniphier.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/reset/reset-uniphier.c b/drivers/reset/reset-uniphier.c
index 74e589f5dd6a6..279e535bf5d80 100644
--- a/drivers/reset/reset-uniphier.c
+++ b/drivers/reset/reset-uniphier.c
@@ -193,8 +193,8 @@ static const struct uniphier_reset_data uniphier_pro5_sd_reset_data[] = {
 #define UNIPHIER_PERI_RESET_FI2C(id, ch)		\
 	UNIPHIER_RESETX((id), 0x114, 24 + (ch))
 
-#define UNIPHIER_PERI_RESET_SCSSI(id)			\
-	UNIPHIER_RESETX((id), 0x110, 17)
+#define UNIPHIER_PERI_RESET_SCSSI(id, ch)		\
+	UNIPHIER_RESETX((id), 0x110, 17 + (ch))
 
 #define UNIPHIER_PERI_RESET_MCSSI(id)			\
 	UNIPHIER_RESETX((id), 0x114, 14)
@@ -209,7 +209,7 @@ static const struct uniphier_reset_data uniphier_ld4_peri_reset_data[] = {
 	UNIPHIER_PERI_RESET_I2C(6, 2),
 	UNIPHIER_PERI_RESET_I2C(7, 3),
 	UNIPHIER_PERI_RESET_I2C(8, 4),
-	UNIPHIER_PERI_RESET_SCSSI(11),
+	UNIPHIER_PERI_RESET_SCSSI(11, 0),
 	UNIPHIER_RESET_END,
 };
 
@@ -225,8 +225,11 @@ static const struct uniphier_reset_data uniphier_pro4_peri_reset_data[] = {
 	UNIPHIER_PERI_RESET_FI2C(8, 4),
 	UNIPHIER_PERI_RESET_FI2C(9, 5),
 	UNIPHIER_PERI_RESET_FI2C(10, 6),
-	UNIPHIER_PERI_RESET_SCSSI(11),
-	UNIPHIER_PERI_RESET_MCSSI(12),
+	UNIPHIER_PERI_RESET_SCSSI(11, 0),
+	UNIPHIER_PERI_RESET_SCSSI(12, 1),
+	UNIPHIER_PERI_RESET_SCSSI(13, 2),
+	UNIPHIER_PERI_RESET_SCSSI(14, 3),
+	UNIPHIER_PERI_RESET_MCSSI(15),
 	UNIPHIER_RESET_END,
 };
 
-- 
2.20.1


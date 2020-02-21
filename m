Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759DE167301
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbgBUIIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:08:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732205AbgBUII3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:08:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9E7420722;
        Fri, 21 Feb 2020 08:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272508;
        bh=RAbthy+G2lB0nNHDZTr4dUxOkTT5aKM66BXOrQ6RQ/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3H4glbqQEtgQtPuI4mai+VQIs/BnY7WyYCwRJ4YVvb3AJqGDJOIjaImSMniJ0HC6
         jeK6yez4pp3cqo6SPw85EmCNo+VjUgJETFlzYp0UzHwcCKJcJVON/DtygPacWhHYF3
         x//6c2Fgmdo66PXFqeAXgQDujDbfL9T6nxpdA3yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/344] reset: uniphier: Add SCSSI reset control for each channel
Date:   Fri, 21 Feb 2020 08:39:28 +0100
Message-Id: <20200221072404.229926105@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




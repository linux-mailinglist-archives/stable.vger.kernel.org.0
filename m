Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBDEF6225
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfKJCk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726879AbfKJCk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74149214E0;
        Sun, 10 Nov 2019 02:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353627;
        bh=oO0gUUG/vj63i5VoHzt41VVsBO2NgniuaSJlilhfdaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEWhsSV9NiosNOrZLv/YenTHS8tzauTd4M4a4pK+wGJuD37DU7Qpsv7yUIWa/leqr
         dqUhUzZx4tf5l/uVcxKgLoTtTDUw2X1kZWTH2I5AUBEufqo++uJzhi3h55YVfR9sDI
         7vcw/Ldc1D6tE+/bIk3W3kJn41qbpbEvBgPPURVw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 011/191] serial: samsung: Enable baud clock for UART reset procedure in resume
Date:   Sat,  9 Nov 2019 21:37:13 -0500
Message-Id: <20191110024013.29782-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 1ff3652bc7111df26b5807037f624be294cf69d5 ]

Ensure that the baud clock is also enabled for UART register writes in
driver resume. On Exynos5433 SoC this is needed to avoid external abort
issue.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/samsung.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c6058b52d5d59..2a49b6d876b87 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1944,7 +1944,11 @@ static int s3c24xx_serial_resume(struct device *dev)
 
 	if (port) {
 		clk_prepare_enable(ourport->clk);
+		if (!IS_ERR(ourport->baudclk))
+			clk_prepare_enable(ourport->baudclk);
 		s3c24xx_serial_resetport(port, s3c24xx_port_to_cfg(port));
+		if (!IS_ERR(ourport->baudclk))
+			clk_disable_unprepare(ourport->baudclk);
 		clk_disable_unprepare(ourport->clk);
 
 		uart_resume_port(&s3c24xx_uart_drv, port);
@@ -1967,7 +1971,11 @@ static int s3c24xx_serial_resume_noirq(struct device *dev)
 			if (rx_enabled(port))
 				uintm &= ~S3C64XX_UINTM_RXD_MSK;
 			clk_prepare_enable(ourport->clk);
+			if (!IS_ERR(ourport->baudclk))
+				clk_prepare_enable(ourport->baudclk);
 			wr_regl(port, S3C64XX_UINTM, uintm);
+			if (!IS_ERR(ourport->baudclk))
+				clk_disable_unprepare(ourport->baudclk);
 			clk_disable_unprepare(ourport->clk);
 		}
 	}
-- 
2.20.1


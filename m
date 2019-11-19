Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7414B10164E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731397AbfKSFvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:51:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731438AbfKSFvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:51:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6E9C214D9;
        Tue, 19 Nov 2019 05:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142711;
        bh=srycieWXSGszwVJ8ASQMK8t1Lxk8Er2ie0ADMyYiDBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAfVgNF8HM2Wp0mPxugTYcJwrxLw6NR4whZ2q09z4BiOw4oaz3LyvJy0WeRTj996N
         IEQSL5K28PYu3moN8jot+yuMni1AgNLAvYmE9MmYqDpvWoFU15AzMlxyRY/ifAeMhC
         zoDDZ8rhPHweKTcMK0Ye/rwgl4EmtvcWk7iFc3hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 133/239] serial: samsung: Enable baud clock for UART reset procedure in resume
Date:   Tue, 19 Nov 2019 06:18:53 +0100
Message-Id: <20191119051330.835278270@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f4b8e4e17a868..808373d4e37a6 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1922,7 +1922,11 @@ static int s3c24xx_serial_resume(struct device *dev)
 
 	if (port) {
 		clk_prepare_enable(ourport->clk);
+		if (!IS_ERR(ourport->baudclk))
+			clk_prepare_enable(ourport->baudclk);
 		s3c24xx_serial_resetport(port, s3c24xx_port_to_cfg(port));
+		if (!IS_ERR(ourport->baudclk))
+			clk_disable_unprepare(ourport->baudclk);
 		clk_disable_unprepare(ourport->clk);
 
 		uart_resume_port(&s3c24xx_uart_drv, port);
@@ -1945,7 +1949,11 @@ static int s3c24xx_serial_resume_noirq(struct device *dev)
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




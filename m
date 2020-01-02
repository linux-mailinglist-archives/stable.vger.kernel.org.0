Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215D812EF64
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbgABWpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:45:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730312AbgABWbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:31:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF5521D7D;
        Thu,  2 Jan 2020 22:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004301;
        bh=kWYJw8yz98cDlxYMDB+WRSgLhd+BiUXxFTIFTO0ALxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKhdi/rZuLUIrlhzWg8eYyCuBtml9o8yyb/IMyY+IuOdyV6x35N1qKf+CL5LvdDl7
         ijRgX0wPnK0spEmbCTP9XR851kQKxtEHWqh3evLWXw8If0dwWpJ87Pg//C/GCU3WvD
         sTRfkQTuGKqDBFAgQXlrruKcJdOfHuImdJyRxT8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 121/171] clocksource/drivers/asm9260: Add a check for of_clk_get
Date:   Thu,  2 Jan 2020 23:07:32 +0100
Message-Id: <20200102220603.868172548@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 6e001f6a4cc73cd06fc7b8c633bc4906c33dd8ad ]

asm9260_timer_init misses a check for of_clk_get.
Add a check for it and print errors like other clocksource drivers.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20191016124330.22211-1-hslester96@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/asm9260_timer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clocksource/asm9260_timer.c b/drivers/clocksource/asm9260_timer.c
index 1ba871b7fe11..e5717807c00a 100644
--- a/drivers/clocksource/asm9260_timer.c
+++ b/drivers/clocksource/asm9260_timer.c
@@ -198,6 +198,10 @@ static int __init asm9260_timer_init(struct device_node *np)
 	}
 
 	clk = of_clk_get(np, 0);
+	if (IS_ERR(clk)) {
+		pr_err("Failed to get clk!\n");
+		return PTR_ERR(clk);
+	}
 
 	ret = clk_prepare_enable(clk);
 	if (ret) {
-- 
2.20.1




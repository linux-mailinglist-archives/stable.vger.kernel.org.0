Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED9EF12F0BC
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgABWTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728616AbgABWTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:19:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3106A22B48;
        Thu,  2 Jan 2020 22:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003574;
        bh=qgvavfl3RP/Pq37Dz8kMIa4I4h1H9glwWHzNIgnNXVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MA/I5NXLPMsDsrgRC2EsnSFLrrXtjsx2JDvpn4LMZhCgtbHYfd/rbbEW7MMFFO6m5
         tBNJYHLRccDsI+6w6xvK1Z5+MnzGqolOKAO/4INm4XiBYyw+tAuxKcYzaZVo/gFSVk
         l3c3e8h/bBNIX+PCN13Z1i4ltiJv3ngNz8NXE53s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/114] clocksource/drivers/asm9260: Add a check for of_clk_get
Date:   Thu,  2 Jan 2020 23:06:30 +0100
Message-Id: <20200102220030.967811618@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
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
index 38cd2feb87c4..0ce760776406 100644
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




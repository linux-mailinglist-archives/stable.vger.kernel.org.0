Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD4E11B404
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733239AbfLKP1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732720AbfLKP1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:27:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 069A324680;
        Wed, 11 Dec 2019 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078024;
        bh=eEYsWr+eFCuXJVM3sKPLmXj1gpsJq1LjKsaQ+vTQuyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTEbRJn4SdRDpm/QvEvdjaz7khVoeTC+RJNWn4ZNEKusriarrdmwqItKcgkebOa9/
         mtATXeWLbkD1LqEAM7ytt0+l0NXeDEcTJ4i8buyJE39xH1ugVDbttRou0z8D8nngvw
         DMFJd+lstMkX2sh+RRd7lVwajDHybD3DEhcCYEMA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 19/79] clocksource/drivers/asm9260: Add a check for of_clk_get
Date:   Wed, 11 Dec 2019 10:25:43 -0500
Message-Id: <20191211152643.23056-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 38cd2feb87c42..0ce760776406b 100644
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


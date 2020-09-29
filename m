Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB42F27CC4F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgI2MfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729596AbgI2LVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:21:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43B052083B;
        Tue, 29 Sep 2020 11:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378349;
        bh=Q7PDz35zNEzU/WetldDS6SxJcYtRsWaGKywmCulC/WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTObzEV0sWbLbFGgaJWrFUTjzY6w9MxjLSOqCGWH7EhV0Rtpe0ndPLhmJTKJjtZRi
         +uuSYor813XfP++QDUPqMoVPgNfykoedRh9dkg+S4r7xQcOvogNMzzIEyWVzd2ZFdR
         kyWMKYRBz0LvU4m1VzjqZEG+dRGNVwdbpQc3M4HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 148/166] clocksource/drivers/h8300_timer8: Fix wrong return value in h8300_8timer_init()
Date:   Tue, 29 Sep 2020 13:01:00 +0200
Message-Id: <20200929105942.585481149@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 400d033f5a599120089b5f0c54d14d198499af5a ]

In the init function, if the call to of_iomap() fails, the return
value is ENXIO instead of -ENXIO.

Change to the right negative errno.

Fixes: 691f8f878290f ("clocksource/drivers/h8300_timer8: Convert init function to return error")
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200802111541.5429-1-tianjia.zhang@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/h8300_timer8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/h8300_timer8.c b/drivers/clocksource/h8300_timer8.c
index 1d740a8c42ab3..47114c2a7cb54 100644
--- a/drivers/clocksource/h8300_timer8.c
+++ b/drivers/clocksource/h8300_timer8.c
@@ -169,7 +169,7 @@ static int __init h8300_8timer_init(struct device_node *node)
 		return PTR_ERR(clk);
 	}
 
-	ret = ENXIO;
+	ret = -ENXIO;
 	base = of_iomap(node, 0);
 	if (!base) {
 		pr_err("failed to map registers for clockevent\n");
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC3F261C7A
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbgIHTUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731109AbgIHQBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:01:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B2592469E;
        Tue,  8 Sep 2020 15:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579591;
        bh=JIERlWPZq59t8PAI+bTxWU/oU1gNX/FDw8yrp5HCbYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7DZ/V1A0qVdskQc0GxmEKPfJifxcJny5npLkzN4e0AnMNhdu+FMgWzAS5opnOqjL
         0Ksm0td2jZr/q6UW+JPtr9KbosWjOMatPSEqUPqalcmGIzB0RbqfIaMufRlP6ljRR+
         KaG8t1yUoY7RhjaQ3++8lhkrQfspbxF3/e2xsrX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Veera Vegivada <vvegivad@codeaurora.org>,
        Guru Das Srinagesh <gurus@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 112/186] thermal: qcom-spmi-temp-alarm: Dont suppress negative temp
Date:   Tue,  8 Sep 2020 17:24:14 +0200
Message-Id: <20200908152247.062102379@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Veera Vegivada <vvegivad@codeaurora.org>

[ Upstream commit 0ffdab6f2dea9e23ec33230de24e492ff0b186d9 ]

Currently driver is suppressing the negative temperature
readings from the vadc. Consumers of the thermal zones need
to read the negative temperature too. Don't suppress the
readings.

Fixes: c610afaa21d3c6e ("thermal: Add QPNP PMIC temperature alarm driver")
Signed-off-by: Veera Vegivada <vvegivad@codeaurora.org>
Signed-off-by: Guru Das Srinagesh <gurus@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/944856eb819081268fab783236a916257de120e4.1596040416.git.gurus@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/qcom/qcom-spmi-temp-alarm.c b/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
index bf7bae42c141c..6dc879fea9c8a 100644
--- a/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
+++ b/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2011-2015, 2017, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2011-2015, 2017, 2020, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/bitops.h>
@@ -191,7 +191,7 @@ static int qpnp_tm_get_temp(void *data, int *temp)
 		chip->temp = mili_celsius;
 	}
 
-	*temp = chip->temp < 0 ? 0 : chip->temp;
+	*temp = chip->temp;
 
 	return 0;
 }
-- 
2.25.1




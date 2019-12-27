Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D4012B834
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfL0RyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:54:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727934AbfL0Rml (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04D4520740;
        Fri, 27 Dec 2019 17:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468560;
        bh=7/bEWBR228SG8GvLa5XKG2h7lDVFYZfEP4V+HyfEkUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ad7s9LOHvH5VwZdulAX8Kmn+q9Qpo/zB+8YJofykuyhFJDuA3Vzr8toqyZsf/v+fy
         L/embmBIdVIzd+guWXZVn+uc0m+FbgboWQSt+0p/ZALIvSIrrqWGgoiBHg3c6NsiGG
         8XxeWAdpWAK9IWc8SXMMUstoN9dwVwJQe4WB1iGU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Keerthy <j-keerthy@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 086/187] bus: ti-sysc: Fix missing reset delay handling
Date:   Fri, 27 Dec 2019 12:39:14 -0500
Message-Id: <20191227174055.4923-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e709ed70d122e94cb426b1e1f905829eae19a009 ]

We have dts property for "ti,sysc-delay-us", and we're using it, but the
wait after OCP softreset only happens if devices are probed in legacy mode.

Let's add a delay after writing the OCP softreset when specified.

Fixes: e0db94fe87da ("bus: ti-sysc: Make OCP reset work for sysstatus and sysconfig reset bits")
Cc: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 2b6670daf7fc..34bd9bf4e68a 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1594,6 +1594,10 @@ static int sysc_reset(struct sysc *ddata)
 	sysc_val |= sysc_mask;
 	sysc_write(ddata, sysc_offset, sysc_val);
 
+	if (ddata->cfg.srst_udelay)
+		usleep_range(ddata->cfg.srst_udelay,
+			     ddata->cfg.srst_udelay * 2);
+
 	if (ddata->clk_enable_quirk)
 		ddata->clk_enable_quirk(ddata);
 
-- 
2.20.1


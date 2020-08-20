Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C183024B9C5
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgHTLs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730046AbgHTKDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:03:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70BCA22B43;
        Thu, 20 Aug 2020 10:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917814;
        bh=yFQbJc/EOVgnddYLEayofDZFETxGTAIux4q8PSfvB3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RwwNzp46uYliqIWDkbC8pBv6d359uSQ1n8ara9n8lmyGmJrlP3n7/0Alj1t5SH3K
         L9f1p01yNGHmhZk/jN2rR6mcJLo0j7k198w7bhvj6+k4gpuK7+tDDO5It5w5xEZwFz
         ncJ99J/8QlcMfldWPW8dy/6qvmtjdypIq+EGf67Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 137/212] power: supply: check if calc_soc succeeded in pm860x_init_battery
Date:   Thu, 20 Aug 2020 11:21:50 +0200
Message-Id: <20200820091609.273818389@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit ccf193dee1f0fff55b556928591f7818bac1b3b1 ]

clang static analysis flags this error

88pm860x_battery.c:522:19: warning: Assigned value is
  garbage or undefined [core.uninitialized.Assign]
                info->start_soc = soc;
                                ^ ~~~
soc is set by calling calc_soc.
But calc_soc can return without setting soc.

So check the return status and bail similarly to other
checks in pm860x_init_battery and initialize soc to
silence the warning.

Fixes: a830d28b48bf ("power_supply: Enable battery-charger for 88pm860x")

Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/88pm860x_battery.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/88pm860x_battery.c b/drivers/power/supply/88pm860x_battery.c
index 63c57dc82ac1d..4eda5065b5bbc 100644
--- a/drivers/power/supply/88pm860x_battery.c
+++ b/drivers/power/supply/88pm860x_battery.c
@@ -436,7 +436,7 @@ static void pm860x_init_battery(struct pm860x_battery_info *info)
 	int ret;
 	int data;
 	int bat_remove;
-	int soc;
+	int soc = 0;
 
 	/* measure enable on GPADC1 */
 	data = MEAS1_GP1;
@@ -499,7 +499,9 @@ static void pm860x_init_battery(struct pm860x_battery_info *info)
 	}
 	mutex_unlock(&info->lock);
 
-	calc_soc(info, OCV_MODE_ACTIVE, &soc);
+	ret = calc_soc(info, OCV_MODE_ACTIVE, &soc);
+	if (ret < 0)
+		goto out;
 
 	data = pm860x_reg_read(info->i2c, PM8607_POWER_UP_LOG);
 	bat_remove = data & BAT_WU_LOG;
-- 
2.25.1




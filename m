Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B761924B5DC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgHTK3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731273AbgHTKVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:21:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDCE22078D;
        Thu, 20 Aug 2020 10:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918878;
        bh=lzkdhGteIHo8AwsJQRu9trsCU87OtNrMqlRTr1Hhc/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmtgJRIGfu/Dyl9mP/+xLua8Z272D6yS/3pjipPV6/TWGm1WcxDrSQnn0Fl+jnW67
         wJ2VONhmmydes6ydGg4uHg87MQGBYrcALytB0vPRi+Xmoz8SKyPcItQt7T57TA6IgY
         uCcmmkn5ylhzLbfugm+gciWOkymUwP7hg4u46bak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 098/149] power: supply: check if calc_soc succeeded in pm860x_init_battery
Date:   Thu, 20 Aug 2020 11:22:55 +0200
Message-Id: <20200820092130.461949698@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
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
 drivers/power/88pm860x_battery.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/power/88pm860x_battery.c b/drivers/power/88pm860x_battery.c
index 63c57dc82ac1d..4eda5065b5bbc 100644
--- a/drivers/power/88pm860x_battery.c
+++ b/drivers/power/88pm860x_battery.c
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




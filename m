Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1760221CB17
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 21:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgGLTYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 15:24:02 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26379 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729162AbgGLTYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 15:24:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594581841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=b3KrXXJU4xTFoLZxrkdOWqXLXUZ09xiehHzSqm0Pkjg=;
        b=YkTew4p7joE7FRYbi461BYun6QyZXlwl75wFMQ9+dA4pPLMDKVsIl0yM7eqxDOgWoeYszR
        rMcNfg4ZkPvwo8j1JOKdObEHFyCbkbqpAnEFmqoqj1TrHUr0rSyMtI1d0Z2bfweW5bwcHJ
        xET0zNi9DZDNzwxhSQVMt87GynB8ijM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-lQsg-kf_PDuHNIBWXOv8NA-1; Sun, 12 Jul 2020 15:23:59 -0400
X-MC-Unique: lQsg-kf_PDuHNIBWXOv8NA-1
Received: by mail-qv1-f72.google.com with SMTP id g17so6370299qvw.0
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 12:23:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b3KrXXJU4xTFoLZxrkdOWqXLXUZ09xiehHzSqm0Pkjg=;
        b=bXWgjF+Q6rqySBxrCLpJbiwnJtWqXZp4nlZ9LrOV0PxQfASaf8FeKa9mmlN/iOgTyH
         QyFFOiFiOaNgfZZyEBMPcB4UIHSBAnT3pXxrbaDPjPqRKTA3+o6VaZKkuUbx/0WI6eoP
         B8EV6mLxEwJ57/kuJpea5mXxLcbyn8EwlH1aAGxW+jibaG88vRgx8ujQzdj8n3dhy/5H
         U3PnXx0pZGYaxyLeWddn3YINblcPWT7dENRnd2t9ffMvdezsgUo6PlHNjpWbDJsGSWlP
         ZZ+RpR9JCF3KbYjQPl5wL2USr6OB0gI6B7EvMCX/V4dBeSfND6857PndjnL+aoxVEUKL
         UunQ==
X-Gm-Message-State: AOAM532jpjyaAENYxYCCfchLYG5JXEST9QczVkjawN9ipyzj8o61VRwQ
        8tJ05aZF0F3BtY0soKhE5UVJYiQj8a9bj7ppfSmZcoKALO3MmdihiZQHhY/qI8Z3s1XqNoi6qjW
        PxSsWvQz0Pt08FPKn
X-Received: by 2002:aed:2f81:: with SMTP id m1mr81595688qtd.266.1594581838903;
        Sun, 12 Jul 2020 12:23:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFr53b37diI/w/IdeVAqL09teKKMSooWPoLaA53zo+3jg48N0X3U39i0Ti1XPPzdbbAPOSWw==
X-Received: by 2002:aed:2f81:: with SMTP id m1mr81595671qtd.266.1594581838617;
        Sun, 12 Jul 2020 12:23:58 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id p7sm15836151qki.61.2020.07.12.12.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 12:23:57 -0700 (PDT)
From:   trix@redhat.com
To:     sre@kernel.org, anton.vorontsov@linaro.org, jtzhou@marvell.com
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] power: supply: check if calc_soc succeeded in pm860x_init_battery
Date:   Sun, 12 Jul 2020 12:23:51 -0700
Message-Id: <20200712192351.15428-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

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
---
 drivers/power/supply/88pm860x_battery.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/88pm860x_battery.c b/drivers/power/supply/88pm860x_battery.c
index 1308f3a185f3..590da88a17a2 100644
--- a/drivers/power/supply/88pm860x_battery.c
+++ b/drivers/power/supply/88pm860x_battery.c
@@ -433,7 +433,7 @@ static void pm860x_init_battery(struct pm860x_battery_info *info)
 	int ret;
 	int data;
 	int bat_remove;
-	int soc;
+	int soc = 0;
 
 	/* measure enable on GPADC1 */
 	data = MEAS1_GP1;
@@ -496,7 +496,9 @@ static void pm860x_init_battery(struct pm860x_battery_info *info)
 	}
 	mutex_unlock(&info->lock);
 
-	calc_soc(info, OCV_MODE_ACTIVE, &soc);
+	ret = calc_soc(info, OCV_MODE_ACTIVE, &soc);
+	if (ret < 0)
+		goto out;
 
 	data = pm860x_reg_read(info->i2c, PM8607_POWER_UP_LOG);
 	bat_remove = data & BAT_WU_LOG;
-- 
2.18.1


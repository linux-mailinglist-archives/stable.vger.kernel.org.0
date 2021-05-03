Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28EB371C34
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhECQvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234281AbhECQuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15DE261920;
        Mon,  3 May 2021 16:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060037;
        bh=1VaN4Wxy7xbn+C2cf9Zvz5TCuDW+FIp7vIehaSRNNas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZ0GZ5z0xhadqTL29uZS1HMq84JY1d8/BLk17y9GR2CEgaBhz28nsF28H52Fcx4q+
         iKqtIF3WZiWwS+cLpkVg91sJQYUCS0r1jU0rliLSFRLzHDE5Vh8pT6n5euCagf4fk9
         9vBCPWGup35XHXFdZ1EoP50wYhD109i/36r/VTF3muJg0dXM18txc7OfUK6fhuxfUG
         Qu4jpYGtJYbRTwx8upnw+gUWnjDnz3yb4NidAEdRBOYpXnav8JIRozeKW2KWOt4AZJ
         p4ohfoQwLmU4aMzMFH8SMEppA3fR4XtUDygMmVxAAdcSLXrF67Uvd24SjiOMFLvTru
         c684zuqb72u2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 36/57] power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
Date:   Mon,  3 May 2021 12:39:20 -0400
Message-Id: <20210503163941.2853291-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b6cfa007b3b229771d9588970adb4ab3e0487f49 ]

This driver's remove path calls cancel_delayed_work(). However, that
function does not wait until the work function finishes. This means
that the callback function may still be running after the driver's
remove function has finished, which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
the work is properly cancelled, no longer running, and unable
to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index bc462d1ec963..97b0e873e87d 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -382,7 +382,7 @@ static int gab_remove(struct platform_device *pdev)
 	}
 
 	kfree(adc_bat->psy_desc.properties);
-	cancel_delayed_work(&adc_bat->bat_work);
+	cancel_delayed_work_sync(&adc_bat->bat_work);
 	return 0;
 }
 
-- 
2.30.2


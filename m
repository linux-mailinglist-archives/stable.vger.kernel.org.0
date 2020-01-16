Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C399813EB81
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394301AbgAPRuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:50:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406545AbgAPRpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:45:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45991246BA;
        Thu, 16 Jan 2020 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196753;
        bh=tHbXqPODKuv/f1Ix3yAK8rhbDEop+L2eGk+J9IV9Beg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdE1lkpHLVFiZ0eNwq/T8jsPi+Ehkvd88QfQku5YRsMq2P2qvvWbbR1nhEGsOAXsT
         iwDUi/c9TTPrj0ZU9z9o7ccO/8p2xONHwmrJKudNq/QHpG9vaCbepHDHnNJbWDlS7u
         XT10KZ5wS1lHt3S50EdYgSSvRmz+JLBKUlXhtoTY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tri Vo <trong@android.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 129/174] power: supply: Init device wakeup after device_add()
Date:   Thu, 16 Jan 2020 12:42:06 -0500
Message-Id: <20200116174251.24326-129-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 8288022284859acbcc3cf1a073a1e2692d6c2543 ]

We may want to use the device pointer in device_init_wakeup() with
functions that expect the device to already be added with device_add().
For example, if we were to link the device initializing wakeup to
something in sysfs such as a class for wakeups we'll run into an error.
It looks like this code was written with the assumption that the device
would be added before initializing wakeup due to the order of operations
in power_supply_unregister().

Let's change the order of operations so we don't run into problems here.

Fixes: 948dcf966228 ("power_supply: Prevent suspend until power supply events are processed")
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tri Vo <trong@android.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ravi Chandra Sadineni <ravisadineni@chromium.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/power_supply_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index b13cd074c52a..9281e42c9ed5 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -755,14 +755,14 @@ __power_supply_register(struct device *parent,
 	}
 
 	spin_lock_init(&psy->changed_lock);
-	rc = device_init_wakeup(dev, ws);
-	if (rc)
-		goto wakeup_init_failed;
-
 	rc = device_add(dev);
 	if (rc)
 		goto device_add_failed;
 
+	rc = device_init_wakeup(dev, ws);
+	if (rc)
+		goto wakeup_init_failed;
+
 	rc = psy_register_thermal(psy);
 	if (rc)
 		goto register_thermal_failed;
@@ -798,8 +798,8 @@ __power_supply_register(struct device *parent,
 	psy_unregister_thermal(psy);
 register_thermal_failed:
 	device_del(dev);
-device_add_failed:
 wakeup_init_failed:
+device_add_failed:
 check_supplies_failed:
 dev_set_name_failed:
 	put_device(dev);
-- 
2.20.1


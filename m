Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D2E14B9B6
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731810AbgA1OYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:24:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732478AbgA1OYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69DB92468A;
        Tue, 28 Jan 2020 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221447;
        bh=PSD4RbVSO0zobmFR8fcfHskmIxH8NTErBAtGouN9zxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtZR/VQ4IZBD13k+KanoXpX7BXsFk0koMWGsP+fBxRVI0awS765JBR3/y6pVpYlJL
         LORzQhYT/WcSF/syQCwRoCHlvSc932kXvd5oEG/vPqr71+9lf2doR8u8NVLUCPoreN
         kDpJeXgBaiYZHYErCvgUhW5MjRTyTkZVTuszU3UU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tri Vo <trong@android.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 191/271] power: supply: Init device wakeup after device_add()
Date:   Tue, 28 Jan 2020 15:05:40 +0100
Message-Id: <20200128135906.797802182@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/power/supply/power_supply_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 9e05ae0430a99..cb0b3d3d132fc 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -764,14 +764,14 @@ __power_supply_register(struct device *parent,
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
@@ -808,8 +808,8 @@ register_cooler_failed:
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




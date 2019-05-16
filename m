Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884AE20559
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfEPLm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbfEPLl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:41:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1161E2087E;
        Thu, 16 May 2019 11:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006915;
        bh=YBYSrRzFghm+Ic4+Ci6Lzzo7OpODMk6EoSS5x2Xy+c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgoWdKlisO4dVHDLxXs7GEGMhmJu6b8HyKdnb+w3WDyPa8SQ/vkQoN6jpLyhE1onW
         4NO90gv/tpe1BZ5Drkqx4/xX1pViVjALwOS8MNySRGznieyLLyp6j5fmsqGIdi6hOr
         pOG+6DBGR2pyRo7d34IbOTvUf4R5dLVTnjJv6OWQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>, linux-pm@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 6/8] power: supply: sysfs: prevent endless uevent loop with CONFIG_POWER_SUPPLY_DEBUG
Date:   Thu, 16 May 2019 07:41:44 -0400
Message-Id: <20190516114146.9267-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114146.9267-1-sashal@kernel.org>
References: <20190516114146.9267-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Smirnov <andrew.smirnov@gmail.com>

[ Upstream commit 349ced9984ff540ce74ca8a0b2e9b03dc434b9dd ]

Fix a similar endless event loop as was done in commit
8dcf32175b4e ("i2c: prevent endless uevent loop with
CONFIG_I2C_DEBUG_CORE"):

  The culprit is the dev_dbg printk in the i2c uevent handler. If
  this is activated (for instance by CONFIG_I2C_DEBUG_CORE) it results
  in an endless loop with systemd-journald.

  This happens if user-space scans the system log and reads the uevent
  file to get information about a newly created device, which seems
  fair use to me. Unfortunately reading the "uevent" file uses the
  same function that runs for creating the uevent for a new device,
  generating the next syslog entry

Both CONFIG_I2C_DEBUG_CORE and CONFIG_POWER_SUPPLY_DEBUG were reported
in https://bugs.freedesktop.org/show_bug.cgi?id=76886 but only former
seems to have been fixed. Drop debug prints as it was done in I2C
subsystem to resolve the issue.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/power_supply_sysfs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index ed2d7fd0c734d..488dd7eb0aeb7 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -277,15 +277,11 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 	char *prop_buf;
 	char *attrname;
 
-	dev_dbg(dev, "uevent\n");
-
 	if (!psy || !psy->desc) {
 		dev_dbg(dev, "No power supply yet\n");
 		return ret;
 	}
 
-	dev_dbg(dev, "POWER_SUPPLY_NAME=%s\n", psy->desc->name);
-
 	ret = add_uevent_var(env, "POWER_SUPPLY_NAME=%s", psy->desc->name);
 	if (ret)
 		return ret;
@@ -321,8 +317,6 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 			goto out;
 		}
 
-		dev_dbg(dev, "prop %s=%s\n", attrname, prop_buf);
-
 		ret = add_uevent_var(env, "POWER_SUPPLY_%s=%s", attrname, prop_buf);
 		kfree(attrname);
 		if (ret)
-- 
2.20.1


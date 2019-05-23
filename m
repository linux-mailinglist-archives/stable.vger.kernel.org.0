Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCBFB2896E
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390533AbfEWThP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390942AbfEWTYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:24:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3885F2133D;
        Thu, 23 May 2019 19:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639478;
        bh=VZ/qY7gzPf8BKoH4JDs2wBXDuVtj0bdbFzN0l2GOsww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALagHLDuXcXD4IDgsc8KvWdkRDt7UJsqNYVbD74us2kJ0jA66IpXD4trqw/LDCaTD
         I6Z3HhNtp9Ks8rb/eJCqyvg06rWnpDOFs2MYdoDwjQp/HmYbzx3N1XxTZ+ZBzwI0/r
         eJL4+qD8yEpRZhXWERLjNwzJWOGO4U9ggn46X0QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>, linux-pm@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 120/139] power: supply: sysfs: prevent endless uevent loop with CONFIG_POWER_SUPPLY_DEBUG
Date:   Thu, 23 May 2019 21:06:48 +0200
Message-Id: <20190523181735.241791265@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
 drivers/power/supply/power_supply_sysfs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/power/supply/power_supply_sysfs.c b/drivers/power/supply/power_supply_sysfs.c
index dce24f5961609..5358a80d854f9 100644
--- a/drivers/power/supply/power_supply_sysfs.c
+++ b/drivers/power/supply/power_supply_sysfs.c
@@ -383,15 +383,11 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
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
@@ -427,8 +423,6 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 			goto out;
 		}
 
-		dev_dbg(dev, "prop %s=%s\n", attrname, prop_buf);
-
 		ret = add_uevent_var(env, "POWER_SUPPLY_%s=%s", attrname, prop_buf);
 		kfree(attrname);
 		if (ret)
-- 
2.20.1




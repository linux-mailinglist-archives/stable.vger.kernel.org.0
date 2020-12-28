Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B482E415A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439493AbgL1PFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439502AbgL1OLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4128E206D4;
        Mon, 28 Dec 2020 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164661;
        bh=WOyWTKS1/AeQ+4IuzWEwZx+a4HHz9y3tyyN8JZ5E8NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0Moh1yg1U55U3oNByEkT1dKSm/0mpyYSJpNpMNj+bdWQ3I5swRv8r7AH15Knok7N
         8MCh9P9U2UEfiBN516ViMbdGd6HWGEDqVhE6jXJtrEn3AOq2WBCasAdTFo7sgiHq2f
         8lJ9RxZyDXLg/I+TJ3YC0SIPkVpuBvU8pB4eKuzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/717] soundwire: master: use pm_runtime_set_active() on add
Date:   Mon, 28 Dec 2020 13:44:12 +0100
Message-Id: <20201228125033.156662583@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit e04e60fce47e61743a8726d76b0149c1f4ad8957 ]

The 'master' device acts as a glue layer used during bus
initialization only, and it needs to be 'transparent' for pm_runtime
management. Its behavior should be that it becomes active when one of
its children becomes active, and suspends when all of its children are
suspended.

In our tests on Intel platforms, we routinely see these sort of
warnings on the initial boot:

[ 21.447345] rt715 sdw:3:25d:715:0: runtime PM trying to activate
child device sdw:3:25d:715:0 but parent (sdw-master-3) is not active

This is root-caused to a missing setup to make the device 'active' on
probe. Since we don't want the device to remain active forever after
the probe, the autosuspend configuration is also enabled at the end of
the probe - the device will actually autosuspend only in the case
where there are no devices physically attached. In practice, the
master device will suspend when all its children are no longer active.

Fixes: bd84256e86ecf ('soundwire: master: enable pm runtime')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20201124130742.10986-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/master.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/soundwire/master.c b/drivers/soundwire/master.c
index 3488bb824e845..9b05c9e25ebe4 100644
--- a/drivers/soundwire/master.c
+++ b/drivers/soundwire/master.c
@@ -8,6 +8,15 @@
 #include <linux/soundwire/sdw_type.h>
 #include "bus.h"
 
+/*
+ * The 3s value for autosuspend will only be used if there are no
+ * devices physically attached on a bus segment. In practice enabling
+ * the bus operation will result in children devices become active and
+ * the master device will only suspend when all its children are no
+ * longer active.
+ */
+#define SDW_MASTER_SUSPEND_DELAY_MS 3000
+
 /*
  * The sysfs for properties reflects the MIPI description as given
  * in the MIPI DisCo spec
@@ -154,7 +163,12 @@ int sdw_master_device_add(struct sdw_bus *bus, struct device *parent,
 	bus->dev = &md->dev;
 	bus->md = md;
 
+	pm_runtime_set_autosuspend_delay(&bus->md->dev, SDW_MASTER_SUSPEND_DELAY_MS);
+	pm_runtime_use_autosuspend(&bus->md->dev);
+	pm_runtime_mark_last_busy(&bus->md->dev);
+	pm_runtime_set_active(&bus->md->dev);
 	pm_runtime_enable(&bus->md->dev);
+	pm_runtime_idle(&bus->md->dev);
 device_register_err:
 	return ret;
 }
-- 
2.27.0




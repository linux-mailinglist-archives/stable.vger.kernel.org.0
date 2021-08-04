Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8883E0043
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 13:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbhHDLfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 07:35:34 -0400
Received: from foss.arm.com ([217.140.110.172]:59626 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237581AbhHDLfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 07:35:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DABCF13D5;
        Wed,  4 Aug 2021 04:35:20 -0700 (PDT)
Received: from e120937-lin.home (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B33483F719;
        Wed,  4 Aug 2021 04:35:19 -0700 (PDT)
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        cristian.marussi@arm.com, Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH] firmware: arm_scmi: Ensure drivers provide a probe function
Date:   Wed,  4 Aug 2021 12:35:08 +0100
Message-Id: <20210804113508.7131-1-cristian.marussi@arm.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 5e469dac326555d2038d199a6329458cc82a34e5 ]

The bus probe callback calls the driver callback without further
checking. Better be safe than sorry and refuse registration of a driver
without a probe function to prevent a NULL pointer exception.

Cc: <stable@vger.kernel.org> # v4.19+
Link: https://lore.kernel.org/r/20210624095059.4010157-2-sudeep.holla@arm.com
Fixes: 933c504424a2 ("firmware: arm_scmi: add scmi protocol bus to enumerate protocol devices")
Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
Upstream commit 5e469dac326555d2038d199a6329458cc82a34e5 has been already
applied to stable/linux-5.13.y, this is a backport with conflicts resolved
for v4.19, v5.4 and v5.10. (SCMI stack did not even exist before 4.19)
---
 drivers/firmware/arm_scmi/bus.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 7a30952b463d..66d445b14e51 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -100,6 +100,9 @@ int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
 {
 	int retval;
 
+	if (!driver->probe)
+		return -EINVAL;
+
 	driver->driver.bus = &scmi_bus_type;
 	driver->driver.name = driver->name;
 	driver->driver.owner = owner;
-- 
2.17.1


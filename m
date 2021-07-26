Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F173D6168
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhGZPbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237857AbhGZP30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAD1061055;
        Mon, 26 Jul 2021 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315739;
        bh=+8MRPLCYnkuxgtHkVaX8KPGreU4W61RC4jdCxc67wuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXkUlQS8S6GWwHQXYBZ58Vs6VNsnZ76p20voMi0kNkz703hJ3YP8su6QzNVN78V5D
         dbC1KDpkPP5+u9w8G5zvduZC3TpBOV0m4WbYqm5lDY7h15N5Y+4ysvr7FY5dvapCG1
         lu8oPwmniArSGDPpC2OU+6scWyJeEUgDnlfUj8/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 048/223] firmware: arm_scmi: Ensure drivers provide a probe function
Date:   Mon, 26 Jul 2021 17:37:20 +0200
Message-Id: <20210726153847.842147348@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
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

Link: https://lore.kernel.org/r/20210624095059.4010157-2-sudeep.holla@arm.com
Fixes: 933c504424a2 ("firmware: arm_scmi: add scmi protocol bus to enumerate protocol devices")
Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 784cf0027da3..9184a0d5acbe 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -139,6 +139,9 @@ int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
 {
 	int retval;
 
+	if (!driver->probe)
+		return -EINVAL;
+
 	retval = scmi_protocol_device_request(driver->id_table);
 	if (retval)
 		return retval;
-- 
2.30.2




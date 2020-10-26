Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9E8299F67
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410957AbgJZXzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410555AbgJZXys (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:54:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41433221F8;
        Mon, 26 Oct 2020 23:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756487;
        bh=XOT4BP4zrkog+Kww/PDxHK0xEUh2pPVDmi/fHsax6mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTq7vB5eg6/dRe0JoJ8bpu9EmTJnEzhcWCMy/zf6HcX0a0dcbj8Q1B68h1sL8aG+6
         cRJHXu12V9la6ovsXxpkr9Doi0Q/eAwS6HiOYwdDvCsYz0KIN3vt2z7Un4x49ZE5Vx
         Gu0DLuYK7bcTMzq1LgbUEdJmXQBwbLqzK3xO59+M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 129/132] firmware: arm_scmi: Move scmi bus init and exit calls into the driver
Date:   Mon, 26 Oct 2020 19:52:01 -0400
Message-Id: <20201026235205.1023962-129-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 5a2f0a0bdf201e2183904b6217f9c74774c961a8 ]

In preparation to enable building scmi as a single module, let us move
the scmi bus {de-,}initialisation call into the driver.

The main reason for this is to keep it simple instead of maintaining
it as separate modules and dealing with all possible initcall races
and deferred probe handling. We can move it as separate modules if
needed in future.

Link: https://lore.kernel.org/r/20200907195046.56615-3-sudeep.holla@arm.com
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c    |  6 ++----
 drivers/firmware/arm_scmi/common.h |  3 +++
 drivers/firmware/arm_scmi/driver.c | 16 +++++++++++++++-
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index db55c43a2cbda..1377ec76a45db 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -230,7 +230,7 @@ static void scmi_devices_unregister(void)
 	bus_for_each_dev(&scmi_bus_type, NULL, NULL, __scmi_devices_unregister);
 }
 
-static int __init scmi_bus_init(void)
+int __init scmi_bus_init(void)
 {
 	int retval;
 
@@ -240,12 +240,10 @@ static int __init scmi_bus_init(void)
 
 	return retval;
 }
-subsys_initcall(scmi_bus_init);
 
-static void __exit scmi_bus_exit(void)
+void __exit scmi_bus_exit(void)
 {
 	scmi_devices_unregister();
 	bus_unregister(&scmi_bus_type);
 	ida_destroy(&scmi_bus_id);
 }
-module_exit(scmi_bus_exit);
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 31fe5a22a0112..927b216e371d8 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -154,6 +154,9 @@ void scmi_setup_protocol_implemented(const struct scmi_handle *handle,
 
 int scmi_base_protocol_init(struct scmi_handle *h);
 
+int __init scmi_bus_init(void);
+void __exit scmi_bus_exit(void);
+
 /* SCMI Transport */
 /**
  * struct scmi_chan_info - Structure representing a SCMI channel information
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 7483cacf63f97..82fa9e4db2272 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -919,7 +919,21 @@ static struct platform_driver scmi_driver = {
 	.remove = scmi_remove,
 };
 
-module_platform_driver(scmi_driver);
+static int __init scmi_driver_init(void)
+{
+	scmi_bus_init();
+
+	return platform_driver_register(&scmi_driver);
+}
+module_init(scmi_driver_init);
+
+static void __exit scmi_driver_exit(void)
+{
+	scmi_bus_exit();
+
+	platform_driver_unregister(&scmi_driver);
+}
+module_exit(scmi_driver_exit);
 
 MODULE_ALIAS("platform: arm-scmi");
 MODULE_AUTHOR("Sudeep Holla <sudeep.holla@arm.com>");
-- 
2.25.1


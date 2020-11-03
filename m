Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3362A58F3
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbgKCUog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:44:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730332AbgKCUof (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86D85223C6;
        Tue,  3 Nov 2020 20:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436274;
        bh=JsmQ9OVNjhucQFocIRIjIuGwMkMozGNDogSy5i9vlw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1hhzAOQo31aWHCM34g9UkPlG4b2DACMULJhHH+TvaTyAYEX6o8f3pDARsNL2f77F
         wMg6gm3mZr3mEyp7MhZA6YINmNG8wAmw5ETRcSBEsrUHVT+K7ucFglYImbY4o9gYzL
         8DFOtpGz7liNVB9vODnpXY1INgRhE/DG7ZlZQIz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 177/391] firmware: arm_scmi: Move scmi bus init and exit calls into the driver
Date:   Tue,  3 Nov 2020 21:33:48 +0100
Message-Id: <20201103203358.816605180@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6db59a7ac8531..124080955c4a0 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -158,6 +158,9 @@ void scmi_setup_protocol_implemented(const struct scmi_handle *handle,
 
 int scmi_base_protocol_init(struct scmi_handle *h);
 
+int __init scmi_bus_init(void);
+void __exit scmi_bus_exit(void);
+
 /* SCMI Transport */
 /**
  * struct scmi_chan_info - Structure representing a SCMI channel information
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 28a3e4902ea4e..5c2f4fab40994 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -936,7 +936,21 @@ static struct platform_driver scmi_driver = {
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
2.27.0




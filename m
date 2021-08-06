Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4F3E2548
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241348AbhHFITB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243918AbhHFISD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:18:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8306B611B0;
        Fri,  6 Aug 2021 08:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237868;
        bh=LGdwMPGAArhAr7M+aDTGi+jhjUT4W9+pivQr2HyCql0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPWxxTB/7z7Dpe7xWl8PW+fgTUJ+1TdTTO3nyTBoc7pO1kj74y9MwI2+vZ7NJtz2O
         MzDPdzYvbQK1ehouHb92zCniuj5QSzBTXNwm0G4nfH2HtBEM+KO+rNg6kMVWH3cbW8
         ca9lgacC1Jk+kg2ByGaJjYlrmdcQvrRgkV48Q/t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.4 15/23] firmware: arm_scmi: Ensure drivers provide a probe function
Date:   Fri,  6 Aug 2021 10:16:47 +0200
Message-Id: <20210806081112.658666445@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

commit 5e469dac326555d2038d199a6329458cc82a34e5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/bus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -100,6 +100,9 @@ int scmi_driver_register(struct scmi_dri
 {
 	int retval;
 
+	if (!driver->probe)
+		return -EINVAL;
+
 	driver->driver.bus = &scmi_bus_type;
 	driver->driver.name = driver->name;
 	driver->driver.owner = owner;



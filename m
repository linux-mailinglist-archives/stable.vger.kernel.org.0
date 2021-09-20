Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77B94125A4
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384147AbhITSqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383441AbhITSoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C37A663354;
        Mon, 20 Sep 2021 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159168;
        bh=a2GYrwtribkspGkRHkt0yQ2etdjNv4Afdw4PoYL+LCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynOcPac5RYn5YSgoolwu8ekaKyP0SU4c1vAvXl9RvV/qDcaitkzMAInMnqlsNr+W0
         I4lEZhWtLw366Q/gM9W+j81lD8mo3EbzkayvbnJOV1AkQ2Ipvr0OsucCz/D+LvJeAI
         7ADSTIFuL5KkK+R9ffLVSUeiIpX4ex3rXd6ZU5TU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 108/168] watchdog: Start watchdog in watchdog_set_last_hw_keepalive only if appropriate
Date:   Mon, 20 Sep 2021 18:44:06 +0200
Message-Id: <20210920163925.186081733@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit dbe80cf471f940db3063197b7adb1169f89be9ed ]

We must not pet a running watchdog when handle_boot_enabled is off
because this will kick off automatic triggering before userland is
running, defeating the purpose of the handle_boot_enabled control.
Furthermore, don't ping in case watchdog_set_last_hw_keepalive was
called incorrectly when the hardware watchdog is actually not running.

Fixed: cef9572e9af3 ("watchdog: add support for adjusting last known HW keepalive time")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/93d56386-6e37-060b-55ce-84de8cde535f@web.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 3bab32485273..6c73160386b9 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1172,7 +1172,10 @@ int watchdog_set_last_hw_keepalive(struct watchdog_device *wdd,
 
 	wd_data->last_hw_keepalive = ktime_sub(now, ms_to_ktime(last_ping_ms));
 
-	return __watchdog_ping(wdd);
+	if (watchdog_hw_running(wdd) && handle_boot_enabled)
+		return __watchdog_ping(wdd);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(watchdog_set_last_hw_keepalive);
 
-- 
2.30.2




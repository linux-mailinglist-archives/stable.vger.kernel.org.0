Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C5841247C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347648AbhITSfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379113AbhITSaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11EA1632E6;
        Mon, 20 Sep 2021 17:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158817;
        bh=8YZEMHsLG3BuOCuXFZG8Zydc7f/xFEd6Ys2Rg4ECE7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzJK17KvWIYDbg4A0b3xbwMyTtAAcBN2Wi3ahzbvs1T6b8WEA654UV7fpoytILqTZ
         tWQQ9sv8IkHYxbObI55sM2wjqGA2r77TPm9GaEvplj/QUWvZz1wj5VJ2PvpOD/GNVA
         XOY7HKrAR8Zhq6gHXZb+VPoEkOWfE7FF9cbmpfrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/122] watchdog: Start watchdog in watchdog_set_last_hw_keepalive only if appropriate
Date:   Mon, 20 Sep 2021 18:44:02 +0200
Message-Id: <20210920163918.069355595@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
index 2946f3a63110..2ee017442dfc 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1164,7 +1164,10 @@ int watchdog_set_last_hw_keepalive(struct watchdog_device *wdd,
 
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




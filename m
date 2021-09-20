Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030D7412616
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349706AbhITSxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385523AbhITSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5381C6338B;
        Mon, 20 Sep 2021 17:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159302;
        bh=vm7Cj2oac6VorMDPdEAf6cBcfXiPSvGL0veQ00zxkp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evT4sw7/+ymuNaEJZ/3iOEZzQSpKIjKEOJdV0wmk55/ocYaZmIfp1LUTuILRVrJPw
         ZeWSITPf+H3QkMtaSdlDVJhScRqdzFVDLWsjurekF16u63XjqBJeaVlN3AY7Lzmlkg
         1wTEy9KOkKfx8L296hCHWTQS6Db6YfSFqC5/Sqf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Curtis Klein <curtis.klein@hpe.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 137/168] watchdog: Fix NULL pointer dereference when releasing cdev
Date:   Mon, 20 Sep 2021 18:44:35 +0200
Message-Id: <20210920163926.163900838@linuxfoundation.org>
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

From: Curtis Klein <curtis.klein@hpe.com>

[ Upstream commit c7b178dae139f8857edc50888cfbf251cd974a38 ]

watchdog_hrtimer_pretimeout_stop needs the watchdog device to have a
valid pointer to the watchdog core data to stop the pretimeout hrtimer.
Therefore it needs to be called before the pointers are cleared in
watchdog_cdev_unregister.

Fixes: 7b7d2fdc8c3e ("watchdog: Add hrtimer-based pretimeout feature")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Curtis Klein <curtis.klein@hpe.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/1624429583-5720-1-git-send-email-curtis.klein@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 6c73160386b9..0cc07d957b64 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1096,6 +1096,8 @@ static void watchdog_cdev_unregister(struct watchdog_device *wdd)
 		watchdog_stop(wdd);
 	}
 
+	watchdog_hrtimer_pretimeout_stop(wdd);
+
 	mutex_lock(&wd_data->lock);
 	wd_data->wdd = NULL;
 	wdd->wd_data = NULL;
@@ -1103,7 +1105,6 @@ static void watchdog_cdev_unregister(struct watchdog_device *wdd)
 
 	hrtimer_cancel(&wd_data->timer);
 	kthread_cancel_work_sync(&wd_data->work);
-	watchdog_hrtimer_pretimeout_stop(wdd);
 
 	put_device(&wd_data->dev);
 }
-- 
2.30.2




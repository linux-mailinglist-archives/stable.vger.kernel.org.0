Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B9429C3EA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758826AbgJ0RvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901562AbgJ0OYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:24:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 137BD2072D;
        Tue, 27 Oct 2020 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808660;
        bh=qkNgZTzaZqgu4Jm+irzi72+A194jbi7ZT+pK3Gi5M7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0a6uNldG88pwjbYAZPMNy0j0v3EuOKONMVLeQKPE95lK7CsgTpJ54oxOsf2jblwSg
         qnHepOOKGdpxvGnR/eC/myjkOLExUXiDTyT0mNZo+TB20C6937o2KNWNBZ1T2T4F0O
         gcz0fJGAoz8gYPQO4UctXQuZ9pBgIA9ZjsePsYTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 174/264] watchdog: Fix memleak in watchdog_cdev_register
Date:   Tue, 27 Oct 2020 14:53:52 +0100
Message-Id: <20201027135438.860643991@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 5afb6d203d0293512aa2c6ae098274a2a4f6ed02 ]

When watchdog_kworker is NULL, we should free wd_data
before the function returns to prevent memleak.

Fixes: 664a39236e718 ("watchdog: Introduce hardware maximum heartbeat in watchdog core")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200824024001.25474-1-dinghao.liu@zju.edu.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 1c322caecf7f1..1e4921f89fb52 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -944,8 +944,10 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 	wd_data->wdd = wdd;
 	wdd->wd_data = wd_data;
 
-	if (IS_ERR_OR_NULL(watchdog_kworker))
+	if (IS_ERR_OR_NULL(watchdog_kworker)) {
+		kfree(wd_data);
 		return -ENODEV;
+	}
 
 	device_initialize(&wd_data->dev);
 	wd_data->dev.devt = MKDEV(MAJOR(watchdog_devt), wdd->id);
-- 
2.25.1




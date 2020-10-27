Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B022D29BE37
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794164AbgJ0PKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794150AbgJ0PKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7DD320657;
        Tue, 27 Oct 2020 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811411;
        bh=EKMWqLGBnLiY7sqt7IKcLRfn/DcBW76AQ/2iXxwXAhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssUrVTXoBtBGi58fN+Swhyc8fq0q+WGOb5MiijLU667VEHT7tBx5zY++tSTLAWyng
         XGhRpXdK11y4EkG42LNcN4wkc04sCJ8h1/k6dabPHes9gGkaH6WtKprZl42O/mEnc/
         JAr4+H4RACGmjsyL8yJdrLaIVyjnYexSBpz6I554=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 453/633] watchdog: Fix memleak in watchdog_cdev_register
Date:   Tue, 27 Oct 2020 14:53:16 +0100
Message-Id: <20201027135543.969296720@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index b535f5fa279b9..d772dff789f3c 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -991,8 +991,10 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
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




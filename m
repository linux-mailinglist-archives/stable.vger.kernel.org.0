Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACE429BCCA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811083AbgJ0QhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801953AbgJ0PpP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:45:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7E9C2231B;
        Tue, 27 Oct 2020 15:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813515;
        bh=vxcihQOeyEabxho5zF5Hhbaduzei4BRWwmvFPxXmTcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+7/ae5gSb7xXhhcbX4rFvPBkEdmvQjdgF4t/7ESNCtxlaCeQbLK1JprV4SqMvg5Y
         PB4j6u+65krtyHnmNGjO4R/iiHL6x3iRw3HnUNvM2SwJ9B2Et/N04czE+h2cafiIAO
         AIcTjMdScttLNLT/w7ky0JvAkH/EsSw83uVx/S5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 546/757] watchdog: Use put_device on error
Date:   Tue, 27 Oct 2020 14:53:16 +0100
Message-Id: <20201027135516.115127674@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 937425d4cd3ae4e2882b41e332bbbab616bcf0ad ]

We should use put_device() instead of freeing device
directly after device_initialize().

Fixes: cb36e29bb0e4b ("watchdog: initialize device before misc_register")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200824031230.31050-1-dinghao.liu@zju.edu.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 785270ee337cb..bcf01af3fa6a8 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1023,7 +1023,7 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 				pr_err("%s: a legacy watchdog module is probably present.\n",
 					wdd->info->identity);
 			old_wd_data = NULL;
-			kfree(wd_data);
+			put_device(&wd_data->dev);
 			return err;
 		}
 	}
-- 
2.25.1




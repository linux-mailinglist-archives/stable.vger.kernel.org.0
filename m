Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2060529C3E6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758773AbgJ0OYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754014AbgJ0OYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:24:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D68220773;
        Tue, 27 Oct 2020 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808663;
        bh=x4/W+EqyE8cRLC70C0gguX4Izs1KXoSwMfj8JfATk8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycEbNV7CwWJB1usDwVx5uOiEkA+ey0RG8o51MHqS0mnfX11OmRK3QTBECpn0Dhv2g
         JXoXNe9b3VcJ8HSeGg+xUvnH2NJJI1ObEtZMo/ovrV3+5jwxj9ar76SrxhjtJ+IwEL
         RFwLkv2s1DfK6qwMCfu4Rqzh4WgNOLzzTILex5vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/264] watchdog: Use put_device on error
Date:   Tue, 27 Oct 2020 14:53:53 +0100
Message-Id: <20201027135438.902025761@linuxfoundation.org>
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
index 1e4921f89fb52..8fe59b7d8eec8 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -973,7 +973,7 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
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




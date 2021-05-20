Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E1838A26A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhETJlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233425AbhETJjW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:39:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADC7E61436;
        Thu, 20 May 2021 09:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503080;
        bh=1VaN4Wxy7xbn+C2cf9Zvz5TCuDW+FIp7vIehaSRNNas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNEhaGrZ96vjJRergXvOQgNw48/EWWZtNDDjcmunHNnYB0+SccNAClShtgxz+ug5i
         3sA/nY+KAaUgdR3HaWXNHw9TxanjFGrOmEhj+Um8gSjY+2VyTvI1ogZs2Fkz7NhrIj
         zReB3EQAoLbb7x2RXXXM6Wr2UqzHk6ENZC2FBsx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/425] power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
Date:   Thu, 20 May 2021 11:17:08 +0200
Message-Id: <20210520092133.382349361@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b6cfa007b3b229771d9588970adb4ab3e0487f49 ]

This driver's remove path calls cancel_delayed_work(). However, that
function does not wait until the work function finishes. This means
that the callback function may still be running after the driver's
remove function has finished, which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
the work is properly cancelled, no longer running, and unable
to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index bc462d1ec963..97b0e873e87d 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -382,7 +382,7 @@ static int gab_remove(struct platform_device *pdev)
 	}
 
 	kfree(adc_bat->psy_desc.properties);
-	cancel_delayed_work(&adc_bat->bat_work);
+	cancel_delayed_work_sync(&adc_bat->bat_work);
 	return 0;
 }
 
-- 
2.30.2




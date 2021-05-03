Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A59371D4D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhECQ6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235374AbhECQ4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A53C61423;
        Mon,  3 May 2021 16:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060221;
        bh=DKurEqkRn6cfph3aDC6+V3HTGwnsta1k7RlNAI8lM5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVX//0h25lZBTqV9hnZLbQlNFGkNHQkfOII0stRZu50GLBlPojmDPpt0TL+XdYs2J
         xNaNJGlGFHVuTOUyn/otqG4Q9zJ0kF7CnohRc1nIdWG7ZuWEi50zk4sbPUHk1wsHaL
         Fy2TsCKJnrNyniOyAl2Q7dIe67KuoqWfeMmAIDLIOlH1NRvrEKBfUMYAYh0hgypWkW
         vLgIyFY/aEo8swLOCAnpuTi8PWicJWR5FdqXO7oc1B7n4AzTP8PKG2htXV1GZe2C1Y
         zyhNlFQFHl/oRnMBz2oUbNQaakyN7/Zfj5OU4Kxc3HJcz10Ulpyu2LBkH/vLhwtnss
         JeiowBp3t9asw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 08/16] power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
Date:   Mon,  3 May 2021 12:43:21 -0400
Message-Id: <20210503164329.2854739-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164329.2854739-1-sashal@kernel.org>
References: <20210503164329.2854739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/power/generic-adc-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
index fedc5818fab7..86289f9da85a 100644
--- a/drivers/power/generic-adc-battery.c
+++ b/drivers/power/generic-adc-battery.c
@@ -379,7 +379,7 @@ static int gab_remove(struct platform_device *pdev)
 	}
 
 	kfree(adc_bat->psy_desc.properties);
-	cancel_delayed_work(&adc_bat->bat_work);
+	cancel_delayed_work_sync(&adc_bat->bat_work);
 	return 0;
 }
 
-- 
2.30.2


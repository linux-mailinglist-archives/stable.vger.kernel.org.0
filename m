Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453B2371D2B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhECQ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235233AbhECQ4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FE476195C;
        Mon,  3 May 2021 16:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060193;
        bh=JuJvN2X8mgQ++fbj0+mQZeOSw5hFw90gldP9RMnAi8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgmU9Xkig1v8c8MKDJhOQUq9dmwEr1jGCUHc6lxCyO9CO4lUue0FPkqr60iZ3defI
         Dzvk4vyB9EHYYmxfxLXxoRbIaffFfLMfApLiV0bX7/LGg6kMMUP/Zn6K1JDOinGRlu
         7LyyXBTw18YwMU7IK0kMo9KbecZOklbTmpZnHYW9KuYpHkP5I4KF4YWJrk4lRK429/
         +z9RRLRW4bYu/bDj4ofGJzrHeyo2NscvLqOmhwplELBQHZXUPbf1Ej/4OjW1b9QvuF
         KWia47WKcUU3izAkKeI2uGfjYWRrfUN0NY81WaWqQZ5d1pGxaTz6snn6SVVJtnXAad
         SBuwj3uR4CnGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 14/24] power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
Date:   Mon,  3 May 2021 12:42:42 -0400
Message-Id: <20210503164252.2854487-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164252.2854487-1-sashal@kernel.org>
References: <20210503164252.2854487-1-sashal@kernel.org>
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
 drivers/power/supply/generic-adc-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index f627b39f64bf..b77fd751945d 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -384,7 +384,7 @@ static int gab_remove(struct platform_device *pdev)
 	}
 
 	kfree(adc_bat->psy_desc.properties);
-	cancel_delayed_work(&adc_bat->bat_work);
+	cancel_delayed_work_sync(&adc_bat->bat_work);
 	return 0;
 }
 
-- 
2.30.2


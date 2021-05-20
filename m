Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B16E38A637
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbhETKZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236290AbhETKWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35E94619FE;
        Thu, 20 May 2021 09:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504109;
        bh=hereJ0RyJy+lofiGg9BMhXrGaktzxvAE3AhkPHBnmZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRvOqi9MDgiLCVlW23yFw2z3rTCwzSr+QJHGRm9F+pp2WzbolRb3oFO6CSMGdOoiy
         WaWUFc20tNREe9QhuAImbiYdzWPQ5FsQteo6Ww6cQcM+lvqbbr2s1ckjabUqLclmxD
         SefbvpQWvE4lOMz1bKDaz7PcSrEPKWD4+9bC2o/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 062/323] power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()
Date:   Thu, 20 May 2021 11:19:14 +0200
Message-Id: <20210520092122.238707521@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 68ae256945d2abe9036a7b68af4cc65aff79d5b7 ]

This driver's remove path calls cancel_delayed_work(). However, that
function does not wait until the work function finishes. This means
that the callback function may still be running after the driver's
remove function has finished, which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
the work is properly cancelled, no longer running, and unable
to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/s3c_adc_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/s3c_adc_battery.c b/drivers/power/supply/s3c_adc_battery.c
index 0ffe5cd3abf6..06b412c43aa7 100644
--- a/drivers/power/supply/s3c_adc_battery.c
+++ b/drivers/power/supply/s3c_adc_battery.c
@@ -392,7 +392,7 @@ static int s3c_adc_bat_remove(struct platform_device *pdev)
 		gpio_free(pdata->gpio_charge_finished);
 	}
 
-	cancel_delayed_work(&bat_work);
+	cancel_delayed_work_sync(&bat_work);
 
 	if (pdata->exit)
 		pdata->exit();
-- 
2.30.2




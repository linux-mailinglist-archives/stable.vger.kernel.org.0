Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBC5371D2D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhECQ6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235284AbhECQ4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93CB561979;
        Mon,  3 May 2021 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060194;
        bh=hereJ0RyJy+lofiGg9BMhXrGaktzxvAE3AhkPHBnmZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gq/aXrsTLS9bOUEgU8Nm7PHlWNvqe5P/jKQB0tlR5Z4UAhHT0hHMb1+TUzAkJyJ3U
         2fIZ5rj3BHrYwR1NzulmiTlTuCnLfL4fcEn/OcjKOvoLnMTEHZsoATd+7DHD7zJmeT
         INiH49kvj422XNHdJ6NQEsyEWbm7mtXsNH95ZLjX5+TEzxf7YjZcT+MH8l2E50/i80
         G/ySJOINqqAiWYUPPFwCFJKrhthtfOAj/ZHqUs0RB9qbkgyzjizpsyptLoQfwCQPks
         waEoQLMWZ3mBd4jAODnEQHGaP+jU5uxyOIFjV/HAlkE5sT4GC1Bq83L8owURI/tIgW
         pNf7Skv4zdzoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/24] power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()
Date:   Mon,  3 May 2021 12:42:43 -0400
Message-Id: <20210503164252.2854487-15-sashal@kernel.org>
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


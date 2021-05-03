Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0993E371C35
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhECQvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234295AbhECQuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 732E86191C;
        Mon,  3 May 2021 16:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060038;
        bh=79pK7TmZDHM2zM9KunmO+9dPd6s23JE8ac9oGGBUk24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCl/XyT5TFYbdZ4FkzNHtxmHkA87fvRy8dUbCsJjnFlIixEFB0J7GnO9AWGLyeqCE
         5qS3Xm9V5yNuSY1EjKfEySw29UXTqMVkmqGBK51GWmQX10EOJ/AaHKBQ1MeJCORRvo
         aDoxxbSFh520LeL/pimkOXVGFpvxx9b+7qne9NBP7/W4PmyeiZI2BoRGQFwfZZPzrK
         F4pJKNJR+fmxOfYYgbbDBNsR3U/xApMX4iU9GeZdbwfhM7QJCA6Q6plECE4zm4iwSD
         dQzISH0CgpusM0r2IxDUyqEyiGZ2rvEFoojp3KYiU3nC/h4TJWYouBA1BiWTa4zvr2
         thd85DYbxWwuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 37/57] power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()
Date:   Mon,  3 May 2021 12:39:21 -0400
Message-Id: <20210503163941.2853291-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
index 3d00b35cafc9..8be31f80035c 100644
--- a/drivers/power/supply/s3c_adc_battery.c
+++ b/drivers/power/supply/s3c_adc_battery.c
@@ -394,7 +394,7 @@ static int s3c_adc_bat_remove(struct platform_device *pdev)
 		gpio_free(pdata->gpio_charge_finished);
 	}
 
-	cancel_delayed_work(&bat_work);
+	cancel_delayed_work_sync(&bat_work);
 
 	if (pdata->exit)
 		pdata->exit();
-- 
2.30.2


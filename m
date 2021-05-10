Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72503788BA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhEJLXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237179AbhEJLLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 051E461919;
        Mon, 10 May 2021 11:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644864;
        bh=/PZsmNOAHWc+djAPVac4wuQz4zH8jRh/xYnwOEZUpFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHMEmXWVATF2N3afCOGk7OAlTir5u7YH7EDqiYCO3u7Slht8FI4u+oY/gQ5ja2w+M
         ZVIPcezCg4qZLLZ6gG8yyBgPDvZnQeg63F1R2KiFEZWGXMc0BZJaanzNS8PjYXNbry
         dj1SjjNQvPDBazO0fXh2pqG/Ut8WZ/JeSIuBD8Us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 228/384] power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()
Date:   Mon, 10 May 2021 12:20:17 +0200
Message-Id: <20210510102022.416886661@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
index a2addc24ee8b..3e3a598f114d 100644
--- a/drivers/power/supply/s3c_adc_battery.c
+++ b/drivers/power/supply/s3c_adc_battery.c
@@ -395,7 +395,7 @@ static int s3c_adc_bat_remove(struct platform_device *pdev)
 	if (main_bat.charge_finished)
 		free_irq(gpiod_to_irq(main_bat.charge_finished), NULL);
 
-	cancel_delayed_work(&bat_work);
+	cancel_delayed_work_sync(&bat_work);
 
 	if (pdata->exit)
 		pdata->exit();
-- 
2.30.2




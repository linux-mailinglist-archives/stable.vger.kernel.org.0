Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC6B371CB4
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhECQ4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233961AbhECQwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:52:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 963FC6101D;
        Mon,  3 May 2021 16:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060101;
        bh=1VaN4Wxy7xbn+C2cf9Zvz5TCuDW+FIp7vIehaSRNNas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRiVbfqZOteoPqlacyXGRLsLcWC3mnqRxOTTLLRbhV8OJOCBHexRIEQyJOAM91zUe
         bCqKeekxRnYgbWUloJNFJs6s3SFiQfhuTI/++7ZF2rYrGGU5+riKTLmmgpUVmFNrDe
         rybQkVKzI49Lq8ucXz8QSSUqqdIQeMkz+03uSUz+7c0QBooFgeqsyOEkmxbRoGtz66
         Lo5+423xpoCXsOu45eRvNoLlWXDFAUeHW4aym0qXxA1PJj7xtaYOSV6Lcci4ZcS5gY
         rGFnTACaG2MCWmBI322sVXHFrvKee27Jq9J4EV+gSpTN5Tjt4+KVYDz75/MOgSHX58
         VJloncWzPf3MA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/35] power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
Date:   Mon,  3 May 2021 12:40:55 -0400
Message-Id: <20210503164109.2853838-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
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


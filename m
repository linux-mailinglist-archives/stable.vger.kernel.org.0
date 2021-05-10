Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79796378874
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhEJLVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237122AbhEJLLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23D476108B;
        Mon, 10 May 2021 11:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644837;
        bh=QjSBw+Y6XhXQaB/vrBFpm1kDfUcD7FqR92r8Xtah6ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNVyEJoSak5Lse5SF81coFp3WTNcS5jexiQ4fGqAiYkEUBHONo2RwfTw07YwRbVCU
         rmNDo0Ks8oH92chHuebIZrNmc9wSdjLQlt24gtXQWcaH8ZGPJSVihz7I2B1cYxIFOg
         x2n/nHfaOvBsaVK0fAyhIoUe8CkmTfRM26TuxpKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 227/384] power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
Date:   Mon, 10 May 2021 12:20:16 +0200
Message-Id: <20210510102022.387202690@linuxfoundation.org>
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
index 0032069fbc2b..66039c665dd1 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -373,7 +373,7 @@ static int gab_remove(struct platform_device *pdev)
 	}
 
 	kfree(adc_bat->psy_desc.properties);
-	cancel_delayed_work(&adc_bat->bat_work);
+	cancel_delayed_work_sync(&adc_bat->bat_work);
 	return 0;
 }
 
-- 
2.30.2




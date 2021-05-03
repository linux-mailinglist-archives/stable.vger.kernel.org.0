Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6D3371CF5
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhECQ5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234877AbhECQzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBA7D61950;
        Mon,  3 May 2021 16:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060154;
        bh=9NXcl2QLLPSP09uPy+3hBBSYPkx27uTwu3P5s/p5jig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXY+Mw4m3CZeEAJbrn3OTw0d4JDsuCQZ+td3d0pmQvpocsR+s/+F/Fn/v8bZzGbKR
         TaDhHizYjQO23Ze08XvqH6AgfUnHbTXE7/MsKvMtLP1Foh40dPB8kSVYKFtr7/nSFw
         euLweNFWLhcNu1gfir01pZR8kg6Lf5HIDfQ+io7xJ5L3As4wzyOZaS15NuEUCCbZjf
         UyU0pfVRTbuxWrEzH/tW18NIFnejvOh8XXntJQuCiFGYtnTAt/wMgUa9CyGoXrBHgJ
         qJSp14CAFkD7VWTuXwoL/hDZqAwuiiOLHVjsyT3NAa4+1V8dnqVVtjUIpgmO/fE4ac
         ne/ht6DwCdHNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 20/31] power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()
Date:   Mon,  3 May 2021 12:41:53 -0400
Message-Id: <20210503164204.2854178-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
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
index 371b5ec70087..c5bde3c24c31 100644
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


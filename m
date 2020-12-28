Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B366B2E403C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441631AbgL1OT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440677AbgL1OT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E95620791;
        Mon, 28 Dec 2020 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165152;
        bh=C4Vspwt1iBhs04ZgSjdE9/sf0p9HMj2D5pe5BswkYc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgPggfKSH6DYieCtMw6lR2nZo4eeHnzuQHWtqC6SxGmo7k6GHzqzAFqCLu8zNhOys
         rDVbOUoAKYk+8aPwfe/danS9DxcKNgIWA92V/KSlhSRJBvVcLsEPd2drKeS2GpErSg
         zlrefstXIW1FpXVd8HB73USPOr9RLfROsLT8Y5OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lingling Xu <ling_ling.xu@unisoc.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/717] watchdog: sprd: remove watchdog disable from resume fail path
Date:   Mon, 28 Dec 2020 13:47:08 +0100
Message-Id: <20201228125041.568891057@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lingling Xu <ling_ling.xu@unisoc.com>

[ Upstream commit f61a59acb462840bebcc192f754fe71b6a16ff99 ]

sprd_wdt_start() would return fail if the loading operation is not completed
in a certain time, disabling watchdog for that case would probably cause
the kernel crash when kick watchdog later, that's too bad, so remove the
watchdog disable operation for the fail case to make sure other parts in
the kernel can run normally.

[ chunyan: Massaged changelog ]

Fixes: 477603467009 ("watchdog: Add Spreadtrum watchdog driver")
Signed-off-by: Lingling Xu <ling_ling.xu@unisoc.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20201029023933.24548-2-zhang.lyra@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sprd_wdt.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/watchdog/sprd_wdt.c b/drivers/watchdog/sprd_wdt.c
index 65cb55f3916fc..f3c90b4afead1 100644
--- a/drivers/watchdog/sprd_wdt.c
+++ b/drivers/watchdog/sprd_wdt.c
@@ -345,15 +345,10 @@ static int __maybe_unused sprd_wdt_pm_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	if (watchdog_active(&wdt->wdd)) {
+	if (watchdog_active(&wdt->wdd))
 		ret = sprd_wdt_start(&wdt->wdd);
-		if (ret) {
-			sprd_wdt_disable(wdt);
-			return ret;
-		}
-	}
 
-	return 0;
+	return ret;
 }
 
 static const struct dev_pm_ops sprd_wdt_pm_ops = {
-- 
2.27.0




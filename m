Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6F82E99CC
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbhADQDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:03:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbhADQDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4688C2250E;
        Mon,  4 Jan 2021 16:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776164;
        bh=TYS9CyxV609M0wdg5tRs0/P/rV4X+CfCd2orivUlb5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjngF34IKOpbM9R7ifqKX7/ZvroE1fM2eO9hJK6J0CpZxZuljy9Bgs5/AnFvYiVdP
         Fgc5LTm5iWLtoSlG3rBw5sxpPn+RVg+bmFU6O+0J/UWreJI4V41+wprbySMUv6fbNb
         jwpwp/OpQZNMItjcRGfVJLOEW0aqfaccx9BLTyq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/63] watchdog: rti-wdt: fix reference leak in rti_wdt_probe
Date:   Mon,  4 Jan 2021 16:57:44 +0100
Message-Id: <20210104155711.287734172@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 8711071e9700b67045fe5518161d63f7a03e3c9e ]

pm_runtime_get_sync() will increment pm usage counter even it
failed. Forgetting to call pm_runtime_put_noidle will result
in reference leak in rti_wdt_probe, so we should fix it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20201030154909.100023-1-zhangqilong3@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rti_wdt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/rti_wdt.c b/drivers/watchdog/rti_wdt.c
index 836319cbaca9d..359302f71f7ef 100644
--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -227,8 +227,10 @@ static int rti_wdt_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_noidle(dev);
 		return dev_err_probe(dev, ret, "runtime pm failed\n");
+	}
 
 	platform_set_drvdata(pdev, wdt);
 
-- 
2.27.0




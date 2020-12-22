Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA3D2D9F87
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438061AbgLNStX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502266AbgLNRhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:45 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 027/105] can: c_can: c_can_power_up(): fix error handling
Date:   Mon, 14 Dec 2020 18:28:01 +0100
Message-Id: <20201214172556.585137877@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 44cef0c0ffbd8d61143712ce874be68a273b7884 ]

In the error handling in c_can_power_up(), there are two bugs:

1) c_can_pm_runtime_get_sync() will increase usage counter if device is not
   empty. Forgetting to call c_can_pm_runtime_put_sync() will result in a
   reference leak here.

2) c_can_reset_ram() operation will set start bit when enable is true. We
   should clear it in the error handling.

We fix it by adding c_can_pm_runtime_put_sync() for 1), and
c_can_reset_ram(enable is false) for 2) in the error handling.

Fixes: 8212003260c60 ("can: c_can: Add d_can suspend resume support")
Fixes: 52cde85acc23f ("can: c_can: Add d_can raminit support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201128133922.3276973-2-zhangqilong3@huawei.com
[mkl: return "0" instead of "ret"]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/c_can/c_can.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 8e9f5620c9a21..095505fa09de3 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -1304,12 +1304,22 @@ int c_can_power_up(struct net_device *dev)
 				time_after(time_out, jiffies))
 		cpu_relax();
 
-	if (time_after(jiffies, time_out))
-		return -ETIMEDOUT;
+	if (time_after(jiffies, time_out)) {
+		ret = -ETIMEDOUT;
+		goto err_out;
+	}
 
 	ret = c_can_start(dev);
-	if (!ret)
-		c_can_irq_control(priv, true);
+	if (ret)
+		goto err_out;
+
+	c_can_irq_control(priv, true);
+
+	return 0;
+
+err_out:
+	c_can_reset_ram(priv, false);
+	c_can_pm_runtime_put_sync(priv);
 
 	return ret;
 }
-- 
2.27.0




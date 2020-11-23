Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A9D2C09B2
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732710AbgKWNKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732798AbgKWMrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE0F20888;
        Mon, 23 Nov 2020 12:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135623;
        bh=nNABfFqu3dRi6l5jlUzVhtu8VeeI9xrYEz7Ernf6O1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4KTX0cCMhYrmCFmEpklg3B4Suj04Mug96ZpqUrEIllK2OMx9zzEmFeSMIhIUBctK
         HS6BLSk/c/1yXgT+nWgl3IsjxYutDnkB0qRcexLdcmIOv2hDw36oADVYpQRcc5t43V
         vdKWxER0F6gH+7zaW7r2/0jOYAayJf12SDxYxkDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 135/252] can: flexcan: fix failure handling of pm_runtime_get_sync()
Date:   Mon, 23 Nov 2020 13:21:25 +0100
Message-Id: <20201123121842.111021208@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit b7ee5bc3e1006433601a058a6a7c24c5272635f4 ]

pm_runtime_get_sync() will increment pm usage at first and it will resume the
device later. If runtime of the device has error or device is in inaccessible
state(or other error state), resume operation will fail. If we do not call put
operation to decrease the reference, it will result in reference leak in the
two functions flexcan_get_berr_counter() and flexcan_open().

Moreover, this device cannot enter the idle state and always stay busy or other
non-idle state later. So we should fix it through adding
pm_runtime_put_noidle().

Fixes: ca10989632d88 ("can: flexcan: implement can Runtime PM")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201108083000.2599705-1-zhangqilong3@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index a330d6c56242e..20a56f389c20c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -614,8 +614,10 @@ static int flexcan_get_berr_counter(const struct net_device *dev,
 	int err;
 
 	err = pm_runtime_get_sync(priv->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_noidle(priv->dev);
 		return err;
+	}
 
 	err = __flexcan_get_berr_counter(dev, bec);
 
@@ -1310,8 +1312,10 @@ static int flexcan_open(struct net_device *dev)
 	int err;
 
 	err = pm_runtime_get_sync(priv->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_noidle(priv->dev);
 		return err;
+	}
 
 	err = open_candev(dev);
 	if (err)
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75122B64CC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbgKQNtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732369AbgKQNdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EAD8207BC;
        Tue, 17 Nov 2020 13:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619987;
        bh=FhelXD50GTExay7XPYUh/K4uWzVw66OudU3KAuCU0ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=la3Q6WFnVsmJlWbn/zasNlVh46xPb1B7suBzAU1NcUWmE1TO4fpp+CqINUIol8q22
         vZsMoHT9YC03l9sZd6tiOR6Z2Y6Wamoy76UMPjr0BIppZgb2auLDA2bhJ51WRMGVDw
         j/Z+xPKAIFgOIYGAYFmJ+iwMdunHIsLWgf7/ZYhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 071/255] USB: apple-mfi-fastcharge: fix reference leak in apple_mfi_fc_set_property
Date:   Tue, 17 Nov 2020 14:03:31 +0100
Message-Id: <20201117122142.405375545@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 00bd6bca3fb1e98190a24eda2583062803c9e8b5 ]

pm_runtime_get_sync() will increment pm usage at first and it
will resume the device later. If runtime of the device has
error or device is in inaccessible state(or other error state),
resume operation will fail. If we do not call put operation to
decrease the reference, the result is that this device cannot
enter the idle state and always stay busy or other non-idle
state.

Fixes: 249fa8217b846 ("USB: Add driver to control USB fast charge for iOS devices")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201102022650.67115-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/apple-mfi-fastcharge.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/apple-mfi-fastcharge.c b/drivers/usb/misc/apple-mfi-fastcharge.c
index 579d8c84de42c..9de0171b51776 100644
--- a/drivers/usb/misc/apple-mfi-fastcharge.c
+++ b/drivers/usb/misc/apple-mfi-fastcharge.c
@@ -120,8 +120,10 @@ static int apple_mfi_fc_set_property(struct power_supply *psy,
 	dev_dbg(&mfi->udev->dev, "prop: %d\n", psp);
 
 	ret = pm_runtime_get_sync(&mfi->udev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(&mfi->udev->dev);
 		return ret;
+	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_CHARGE_TYPE:
-- 
2.27.0




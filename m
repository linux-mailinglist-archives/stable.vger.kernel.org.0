Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B16370C7D
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhEBOG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233167AbhEBOF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8EB3613CB;
        Sun,  2 May 2021 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964305;
        bh=Rxx7QQiEMwx5ectBXmoX2TNIsjxxoayW2YdY6kOtLZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPiboLbv2AUvP7spaxYkgbL5yeeX6O79qyNi8+HWDXxDRoDlc5jTYY0ORQizWRh3B
         MjzrpLZdpILe455cRB6wddc9EGoD1WgbsX8gCM0c3dVp3F7NcgbI73s1QsU+TGtRw1
         3cLb+m8TTLZ5MttpN9Z2CfKzNSxTcmYx6vwJeoiCQ1hfuwxslrAbdk1H7gPj36G/y3
         uDpLe9K7OcpQm13ygvxYk2Nyrq1z+gveLs3p7Z3ePf6JA24cDVd0pO8E6W4hA/CtZg
         UVKkyUvLRQMgsxYyI1LaJ5WgvD29rENOoaz6Dya0w5DonS148qKvLpnSwPUxHfjAJH
         irlsl9igaGWDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 25/34] usb: core: hub: Fix PM reference leak in usb_port_resume()
Date:   Sun,  2 May 2021 10:04:25 -0400
Message-Id: <20210502140434.2719553-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 025f97d188006eeee4417bb475a6878d1e0eed3f ]

pm_runtime_get_sync will increment pm usage counter even it failed.
thus a pairing decrement is needed.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Link: https://lore.kernel.org/r/20210408130831.56239-1-cuibixuan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 4d3de33885ff..cd61860cada5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3537,7 +3537,7 @@ int usb_port_resume(struct usb_device *udev, pm_message_t msg)
 	u16		portchange, portstatus;
 
 	if (!test_and_set_bit(port1, hub->child_usage_bits)) {
-		status = pm_runtime_get_sync(&port_dev->dev);
+		status = pm_runtime_resume_and_get(&port_dev->dev);
 		if (status < 0) {
 			dev_dbg(&udev->dev, "can't resume usb port, status %d\n",
 					status);
-- 
2.30.2


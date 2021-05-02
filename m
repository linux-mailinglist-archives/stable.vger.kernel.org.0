Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C68370D1E
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbhEBOIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233872AbhEBOIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64CF4613D7;
        Sun,  2 May 2021 14:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964395;
        bh=vcXjnd0RVtjp9wv8OGxIBH6Btu3mKLehj10zJxynX8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuCpSzIRAKIq58QUWKAuOvfbduZ61dixdMOB9hsLDyxcjergc74TGbUellDtNV79K
         dljE1sd+fpCiwS6O7p9sv7bNiiUMy8xah15nSoiKQn8syOCyL1y+KDRAAPxfqRxYVk
         p3atNMxs1pWeHZoDyl1BXblOq5ATFuqXGaowW/kzbdxTE0musZOcp9hrqPNY4PFjNm
         fsPpUoyVO4Huy/kBbqcv4ki5ERnXC8nqGWD2gqYVnMm5bOAdZQHukVI77lFraBveTj
         456KCgY6X92iGRkPVtlJ92PNhYI//mvOIAb0BehrqTy85l7Jer4BZVHraxdXaGozwu
         DA30wuUpRSiyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 09/10] phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()
Date:   Sun,  2 May 2021 10:06:21 -0400
Message-Id: <20210502140623.2720479-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140623.2720479-1-sashal@kernel.org>
References: <20210502140623.2720479-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e1723d8b87b73ab363256e7ca3af3ddb75855680 ]

This driver's remove path calls cancel_delayed_work(). However, that
function does not wait until the work function finishes. This means
that the callback function may still be running after the driver's
remove function has finished, which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
the work is properly cancelled, no longer running, and unable
to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210407092716.3270248-1-yangyingliang@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-twl4030-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index f96065a81d1e..168780eb29aa 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -753,7 +753,7 @@ static int twl4030_usb_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&twl->phy);
 	pm_runtime_get_sync(twl->dev);
-	cancel_delayed_work(&twl->id_workaround_work);
+	cancel_delayed_work_sync(&twl->id_workaround_work);
 	device_remove_file(twl->dev, &dev_attr_vbus);
 
 	/* set transceiver mode to power on defaults */
-- 
2.30.2


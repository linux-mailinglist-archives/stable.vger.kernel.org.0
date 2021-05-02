Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7E0370CEF
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhEBOIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233762AbhEBOHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59D79613AA;
        Sun,  2 May 2021 14:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964364;
        bh=QAT7/DpyHeJMZMdN80nWXT2iJv4L2bS1nhzR0FOK+k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8nQkyX+QsqAqH1V5mpG6yC/uax31vrS4xE3f2znQJUz29EeG4WWIY5HC10ahobKP
         ExPlmCfSnz9xsvkLD7Bqo7g0cr0Hy7nIxyazmay7Er/Xp8Q50kEWncnoDlESLcCTGE
         xuueZdaI+Zs06sShaK+gJcAsuUyDmL5JOYB64aaoHHvqhcekM0swsIWOSpu1EDyMJX
         BBPGakd72U32D50ZVNECwxf4LstCfrjiNDSEQ52hvSLrRTFJvBLvch/qYTCuoYKkFI
         Ly8eWmpqt+VAXnS2i4L0gMFnu+MqyY19rByzYCnaTzeoCcj24+xZViix6s33i8NqkO
         c80vL4+7agPSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 15/16] phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()
Date:   Sun,  2 May 2021 10:05:43 -0400
Message-Id: <20210502140544.2720138-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140544.2720138-1-sashal@kernel.org>
References: <20210502140544.2720138-1-sashal@kernel.org>
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
 drivers/phy/ti/phy-twl4030-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/ti/phy-twl4030-usb.c b/drivers/phy/ti/phy-twl4030-usb.c
index c267afb68f07..ea7564392108 100644
--- a/drivers/phy/ti/phy-twl4030-usb.c
+++ b/drivers/phy/ti/phy-twl4030-usb.c
@@ -801,7 +801,7 @@ static int twl4030_usb_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&twl->phy);
 	pm_runtime_get_sync(twl->dev);
-	cancel_delayed_work(&twl->id_workaround_work);
+	cancel_delayed_work_sync(&twl->id_workaround_work);
 	device_remove_file(twl->dev, &dev_attr_vbus);
 
 	/* set transceiver mode to power on defaults */
-- 
2.30.2


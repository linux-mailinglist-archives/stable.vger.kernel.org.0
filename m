Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E1D370CC0
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhEBOHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232646AbhEBOGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26500613CD;
        Sun,  2 May 2021 14:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964341;
        bh=QAT7/DpyHeJMZMdN80nWXT2iJv4L2bS1nhzR0FOK+k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKEVYCmjwvuDIjYCtqqO6OBnGc+/7c0TQq3PCaHhjjGSKr9ws6JTHTmAPDDE6rdBU
         7KjgDxYY2A0cNWtRHjBTIIoiirS1usVJ3VmQx6maBl5YhxDgqIiNMwPQpsQXMYY6R9
         XnsQ2tewYJhauR/LrVE6XgqgtiHG31FnqerLlPtowpfULd4bubO54NfO3MXlLAZ4Pr
         7AwUwg9ebVNncLWlzu4oncdTwhGXdZ7YZJlSiXZOGqdMMlQbQLDwaOms9y5ipN7ubJ
         fmz7VsQZmRKQA/UuFlYx0JKpAOOt3IYYyABad9LSqHzbiMJC3+smzO1Sfh6ly2KU7i
         fhQt9rsHfez7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 19/21] phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()
Date:   Sun,  2 May 2021 10:05:15 -0400
Message-Id: <20210502140517.2719912-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C173370C83
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhEBOGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233244AbhEBOGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4ADF613D8;
        Sun,  2 May 2021 14:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964310;
        bh=s++pOuEuj5uVGNpgdbWGjOD4K3Kud/91J//OAfiA/aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrBZK327T7bTeu3CRgojME+D3kFHTItuTDfbIFcNk2w8cuP6KL31AknQmNgx99Sac
         2UhNhA7Vr1aSnaCebTbw9Y4CuqjzRaCpSH3vevuwtynrioXgJ6uxVo//5L674lDhs5
         z8CRWHWmh/FML/Wp2bD/HWQL+ys0LlwnXeqOzhz9HWae7g+Fx/PzAP8XBXYRq2/49K
         PihmA3Y2JUptveK368+bh8w48TNbragt4A/P50Xs9M/mQgsG9M933/iSlQ8l3h5orD
         QjD94DSGbHuwNAj4Kfg+KV0ZX6gIPrcJoRMfdacKDlstt6HgQRgc1kDJ5T/zR8MHQG
         9g7zt9M8YoXWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 29/34] phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()
Date:   Sun,  2 May 2021 10:04:29 -0400
Message-Id: <20210502140434.2719553-29-sashal@kernel.org>
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
index 9887f908f540..812e5409d359 100644
--- a/drivers/phy/ti/phy-twl4030-usb.c
+++ b/drivers/phy/ti/phy-twl4030-usb.c
@@ -779,7 +779,7 @@ static int twl4030_usb_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&twl->phy);
 	pm_runtime_get_sync(twl->dev);
-	cancel_delayed_work(&twl->id_workaround_work);
+	cancel_delayed_work_sync(&twl->id_workaround_work);
 	device_remove_file(twl->dev, &dev_attr_vbus);
 
 	/* set transceiver mode to power on defaults */
-- 
2.30.2


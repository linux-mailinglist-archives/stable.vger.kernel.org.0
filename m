Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B00370D0C
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhEBOIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233822AbhEBOHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17993613E1;
        Sun,  2 May 2021 14:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964380;
        bh=XXiP8hIl8j9SfARZKtshWyoRYEFRCqGySqGCWLow8yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2p83LnFoBHJanBcS96OC2EirFnXccHj1U9JYfyaQU+Gw7Xm/003QfpbZlbcH3/DQ
         yYS4l5vD1xWNIIbHeulVLe+lfndSGmLwXshQTdqCq5RkkKnQBcNnW6bjxLRKCJhK2Y
         nfyOB744daGJVIQy5w25Skrdbb5nzV7BZm0aI+ydybZShTN7nMtBR3Dzyjm2eWucHk
         un4QQFHw6YaCFvEpek9hMXu/nRqNAjZdLPLC1hty1v1+LVBdg/H5POA3ptFfh1VVnI
         taA14cpvICMuLELgSEAuBC97ZujdrSdaazqMkSqXO6d/085Z6VZhaFFpscrIUEcSHf
         /sRfIiC4oygLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-phy@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 11/12] phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()
Date:   Sun,  2 May 2021 10:06:05 -0400
Message-Id: <20210502140606.2720323-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140606.2720323-1-sashal@kernel.org>
References: <20210502140606.2720323-1-sashal@kernel.org>
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
index ddb530ee2255..9d57695e1f21 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -798,7 +798,7 @@ static int twl4030_usb_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&twl->phy);
 	pm_runtime_get_sync(twl->dev);
-	cancel_delayed_work(&twl->id_workaround_work);
+	cancel_delayed_work_sync(&twl->id_workaround_work);
 	device_remove_file(twl->dev, &dev_attr_vbus);
 
 	/* set transceiver mode to power on defaults */
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A94144B6EC
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344820AbhKIWat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344874AbhKIW2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:28:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74B3661208;
        Tue,  9 Nov 2021 22:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496428;
        bh=wywaTOUg4rQhajJSmVTWOlOkW6JYAOE/z69eL1ZC92g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRdFFf5MNMSCXX9qLE2B6DXoQdb6cYBfJKdbCi7eqmF8D02TwZCyqi7tqWnNgPcQ1
         FtEcu0FueIN6XnxnLbjwMc5xkAkVM6L7hfoVRJgFalJYS0rTFIJEHXs9qTVi02f71o
         Sawq+GzgHKO4BR2Pkw4Ny+3NYgL4eNV7RjqddjolDf06OyrLiHVUv9GsHeG1kS3sPJ
         JSkYgCVlzFjL/i+iwR501kTT6Pca6N/3kaiTjzUXnyc4VKnrgM+cv2ULehBHR3tO1N
         4w3DTqFXFioGZXAHrMsnonRNjHWRGgsS89qmPFDsK8rmBobzvyptKlkMfA+pdqKplR
         VLITeHkbxvAbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 51/75] usb: host: ohci-tmio: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:18:41 -0500
Message-Id: <20211109221905.1234094-51-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9eff2b2e59fda25051ab36cd1cb5014661df657b ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211011134920.118477-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-tmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index 08ec2ab0d95a5..3f3d62dc06746 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -199,7 +199,7 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 	if (usb_disabled())
 		return -ENODEV;
 
-	if (!cell)
+	if (!cell || !regs || !config || !sram)
 		return -EINVAL;
 
 	if (irq < 0)
-- 
2.33.0


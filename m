Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAD545C10B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346264AbhKXNOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:14:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348101AbhKXNMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:12:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 923BA61A87;
        Wed, 24 Nov 2021 12:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757766;
        bh=r1WmjwjlC6jxKn/YidomiPIH0ZoPKcK7bHjyxb/w5Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOmjYxf7cA3pHMOVIf4YGs8FBVQbzyDHzR/hb7wM3A1MNtX/QVjx+KOkwxHp8+HEG
         4RmCXMxB09bohT98bHNz++n1aaqxrpzzUsfozodgo0FfQ+NosJw21MyVdH2JeQY7sX
         gxlcYwQv7Q+p5ylKfh4QC2glL1kQnq0ReuysjdH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 270/323] usb: host: ohci-tmio: check return value after calling platform_get_resource()
Date:   Wed, 24 Nov 2021 12:57:40 +0100
Message-Id: <20211124115727.985767242@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 983a00e2988dc..702d78e0d903a 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -196,7 +196,7 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 	if (usb_disabled())
 		return -ENODEV;
 
-	if (!cell)
+	if (!cell || !regs || !config || !sram)
 		return -EINVAL;
 
 	if (irq < 0)
-- 
2.33.0




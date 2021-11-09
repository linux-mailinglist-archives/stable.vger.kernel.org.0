Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461E444B84F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344322AbhKIWmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:42:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345111AbhKIWjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:39:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E17261B00;
        Tue,  9 Nov 2021 22:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496611;
        bh=r1WmjwjlC6jxKn/YidomiPIH0ZoPKcK7bHjyxb/w5Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJX/2j6PedeKyEhw+gxYDLyI033cmNhXnjEDR6vCkjAaO1DH+YbVHkYDEgiBJt48S
         O08OAop44GCz56YkXfwI5aerDjtEchRUZPG6Ai2J9epUN9236IYMaKCdozdbCxIg9U
         66xIlZBGLRGT4uhbzrzMOUa28+/c/Sl4LJKblVvTNXwEPYlQzqy/45RVLfaNzCtJNv
         +APMl+OlEjFbcOXTfT0OdeowAXlzD+NhPZnv5+nn2D7U8nBDMPxC3EmkRnFFAyaZLm
         Vlt9RjT/ygJlwbURXhj18i/u36ETmkmRQu1jVYVqHYXl26v1XgXLl5iMPdkXMbjpqy
         Z7+r4ICdNuh/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/21] usb: host: ohci-tmio: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:23:02 -0500
Message-Id: <20211109222311.1235686-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222311.1235686-1-sashal@kernel.org>
References: <20211109222311.1235686-1-sashal@kernel.org>
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C13D44B88B
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346328AbhKIWoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235273AbhKIWmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:42:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9071261B50;
        Tue,  9 Nov 2021 22:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496654;
        bh=9L5S1wNQqgRAGnTg268+P/TH/VccBWxuhv9lCpuuxG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5E7SQxdEj3iDT4BVhMU1T0IJT8Ssw7ZCac23JIbAHliVSk92lrtTnrjkhBDkmKww
         2ekl8ez/rDGmefJDI4Bd/LvOfXTc4hDBYrqY4hP0FtwOS1Wq1zwgQCSl53yfwyTN8h
         i99TX6Sgv7ydp3V1T9sq2MYpNSgN5zzKKL6RswxCdb0hVJU3RGTUZp/5xjK100u8Ma
         kdGs6hQBjJ6ZmuTx5UI5VLmU7Z4ulWI6nbyVSSehUCTbhyKatXmARc7dqsQGcZf5iN
         qdom5aXOfPfi78qP3ldB6In30KHUCt64Q/H125Ds2gDJG+pnVzXxZHZyoQZ6e7BDfU
         pT8O2UqfhPyYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/13] usb: host: ohci-tmio: check return value after calling platform_get_resource()
Date:   Tue,  9 Nov 2021 17:23:57 -0500
Message-Id: <20211109222405.1236040-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222405.1236040-1-sashal@kernel.org>
References: <20211109222405.1236040-1-sashal@kernel.org>
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
index 9c9e97294c18d..4d42ae3b2fd6d 100644
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


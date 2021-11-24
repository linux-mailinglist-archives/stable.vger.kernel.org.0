Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0F245C4A8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354442AbhKXNur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:50:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354220AbhKXNtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:49:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 872AC63343;
        Wed, 24 Nov 2021 13:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758957;
        bh=wywaTOUg4rQhajJSmVTWOlOkW6JYAOE/z69eL1ZC92g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T602ar24G+hN7+mF8TWTU3y9Nryt/hvn4bl/jFL2C1lnc0d3c8gTCmLIvDK9p13ro
         2fqFAQN2aHfYOzPX3OEKEIIG4sJJCj3wHkShwvyJMR5dNC+OCQKVtjBhnkY0uMS0qo
         kOnPdLyOGfTQ/u24qro3vny2SxU9JPy2H6uWOSUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/279] usb: host: ohci-tmio: check return value after calling platform_get_resource()
Date:   Wed, 24 Nov 2021 12:55:40 +0100
Message-Id: <20211124115720.559521791@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
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




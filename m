Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B99811994E
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbfLJVdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:33:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729591AbfLJVc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:32:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68B9E2464B;
        Tue, 10 Dec 2019 21:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013579;
        bh=gzsRijTBLbGffTkr/3RSSwqpOYqXsGL36XWokYSnePQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CwiXpEi86yr9b+rRzh9i3okMyLIdog3J5LT830ma9aMsM7xuozg4mE0ZqjDH6Vzy
         OnhtxYLbnKp9W+lmFUoOD2ufBXF+MkIJASw2lUTpv8LXaoc4GNrF6/9Rc5x4aSnZ7c
         fkAwszoph/FPrgMUzP7nUm+Zjho63atC5zhwA/VM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 031/177] media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()
Date:   Tue, 10 Dec 2019 16:29:55 -0500
Message-Id: <20191210213221.11921-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 649cd16c438f51d4cd777e71ca1f47f6e0c5e65d ]

If usb_set_interface() failed, iface->cur_altsetting will
not be assigned and it will be used in flexcop_usb_transfer_init()
It may lead a NULL pointer dereference.

Check usb_set_interface() return value in flexcop_usb_init()
and return failed to avoid using this NULL pointer.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index ac4fddfd0a43f..f1807c16438dd 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -503,7 +503,13 @@ static int flexcop_usb_transfer_init(struct flexcop_usb *fc_usb)
 static int flexcop_usb_init(struct flexcop_usb *fc_usb)
 {
 	/* use the alternate setting with the larges buffer */
-	usb_set_interface(fc_usb->udev,0,1);
+	int ret = usb_set_interface(fc_usb->udev, 0, 1);
+
+	if (ret) {
+		err("set interface failed.");
+		return ret;
+	}
+
 	switch (fc_usb->udev->speed) {
 	case USB_SPEED_LOW:
 		err("cannot handle USB speed because it is too slow.");
-- 
2.20.1


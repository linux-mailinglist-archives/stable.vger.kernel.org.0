Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7F6D12CA10
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfL2RYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:24:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbfL2RYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:24:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A88E3207FD;
        Sun, 29 Dec 2019 17:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640253;
        bh=PbejQvt92Lv8EXKEFReHeQaUQoigtn6bvBp6eI1MK3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QozpblgfUXl/NvBSnetolHKQwXILct6IXxQt8VidccBdhVQFDdt9k+rjG5mhXWgJ
         bxrQ5YIftqwAENBDXyA3oxu6dWq7ObhjWvSSL9CnVk7Oa3NU7eqehNPour/VRPO7gZ
         NzUR1l4JTPYZRUsHgHgNhhGct8nI/yoRUPeS9ZUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 043/161] media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()
Date:   Sun, 29 Dec 2019 18:18:11 +0100
Message-Id: <20191229162412.934047252@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ac4fddfd0a43..f1807c16438d 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -503,7 +503,13 @@ urb_error:
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




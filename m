Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E753CE2C7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbhGSPcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347142AbhGSP2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:28:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17312613C3;
        Mon, 19 Jul 2021 16:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710937;
        bh=+cUaXs9SZyH/ZrXGu4wPjqlTNqEvKvvC7K1OSUMyATE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fO5qi+LG02x/GQc712lXkFwxmNz+gOCjKhvHaLwZIdi9ofqgdKY6jq+jqtW7xI82l
         v4XZMr3R8xcWk81EDEeEjCFEJWnnEKXAmPiXAqZBpAiTVfpBFUExqueSwa/2r42YC/
         GOjcHQFjo2nkmBvKM++yxGBjWTGwbV5vR4Vcz5lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 132/351] usb: gadget: hid: fix error return code in hid_bind()
Date:   Mon, 19 Jul 2021 16:51:18 +0200
Message-Id: <20210719144948.850455530@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 88693f770bb09c196b1eb5f06a484a254ecb9924 ]

Fix to return a negative error code from the error handling
case instead of 0.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210618043835.2641360-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/legacy/hid.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/hid.c b/drivers/usb/gadget/legacy/hid.c
index c4eda7fe7ab4..5b27d289443f 100644
--- a/drivers/usb/gadget/legacy/hid.c
+++ b/drivers/usb/gadget/legacy/hid.c
@@ -171,8 +171,10 @@ static int hid_bind(struct usb_composite_dev *cdev)
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto put;
+		}
 		usb_otg_descriptor_init(gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;
-- 
2.30.2




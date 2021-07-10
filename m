Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E42A3C3086
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhGJCfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235309AbhGJCen (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B11FD613EE;
        Sat, 10 Jul 2021 02:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884309;
        bh=+cUaXs9SZyH/ZrXGu4wPjqlTNqEvKvvC7K1OSUMyATE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJbwRh+qG544X7LoP4z5PLLspYgWOeifAI8L10le3PUX47ye/wsGy942W83f8FwSJ
         Xyrp+m48DT5hM0pS0S6WrOAFPvpT1N1/rsD1snOjyux1smOejAcy6tOWW86WpJQ8Pm
         K2YYMIzIqMWhdH/7NfItStxK6CatQixZhHVFcJzGn5Xveh+4nwAUbbKznhAYC70EoL
         Gs+VKBdG9f4GP65OwyLkfUfgfuOaU2+ZroUq6cj5MQavJ2OLO1D+he7IIfLhNGHW2Y
         IavfdHKfWzvnTt1lNgk4Cg9BJP/coRd8O4R3B82PNsUgP2OSgTD2YSPM430i2ONcuf
         6MWA41cp0/Gfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 53/63] usb: gadget: hid: fix error return code in hid_bind()
Date:   Fri,  9 Jul 2021 22:26:59 -0400
Message-Id: <20210710022709.3170675-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


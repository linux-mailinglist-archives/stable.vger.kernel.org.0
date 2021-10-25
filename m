Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD74F4395E9
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhJYMTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233070AbhJYMTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:19:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E477B6108C;
        Mon, 25 Oct 2021 12:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635164240;
        bh=yeLLjKIkG2yxf3NFQJnoNHi8BdfnAnLKwOhTGVC/QpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwycEgIdGDVbktrnIz1VAXAi6iTQ0cmJb+s2STktxHn0zF3pZdhvVoKgIN8sYr/br
         +wWM2YuO/NnYh2v6154oqUMq4ZsKN5JhL1NBjLwLd+RivwFOyPDbT1dhUJa7031GLs
         bRuYvaYY6VdTRsyCbNFe3QRRKMtEywITulQBnp+HsWgHKy74bPTH8Kd59R+6Ps1Ep6
         AcrKYQsuE9kACLLsxBmpyiuDp6nAoXtP+P9p16Low9QywVjtB+QOZDJUIFKflC0LDD
         bzTHPLcQt4PCCN9ZVUWXumKam3qh2aUSKWJjOFZzqGn62I2PYRxU4nSP/YtNVkKEl+
         B961yX0lgIMfg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyuV-0001mZ-0b; Mon, 25 Oct 2021 14:17:03 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 8/8] media: stk1160: fix control-message timeouts
Date:   Mon, 25 Oct 2021 14:16:41 +0200
Message-Id: <20211025121641.6759-9-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025121641.6759-1-johan@kernel.org>
References: <20211025121641.6759-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 9cb2173e6ea8 ("[media] media: Add stk1160 new driver (easycap replacement)")
Cc: stable@vger.kernel.org      # 3.7
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/stk1160/stk1160-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index b4f8bc5db138..4e1698f78818 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -65,7 +65,7 @@ int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
 		return -ENOMEM;
 	ret = usb_control_msg(dev->udev, pipe, 0x00,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0x00, reg, buf, sizeof(u8), HZ);
+			0x00, reg, buf, sizeof(u8), 1000);
 	if (ret < 0) {
 		stk1160_err("read failed on reg 0x%x (%d)\n",
 			reg, ret);
@@ -85,7 +85,7 @@ int stk1160_write_reg(struct stk1160 *dev, u16 reg, u16 value)
 
 	ret =  usb_control_msg(dev->udev, pipe, 0x01,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, reg, NULL, 0, HZ);
+			value, reg, NULL, 0, 1000);
 	if (ret < 0) {
 		stk1160_err("write failed on reg 0x%x (%d)\n",
 			reg, ret);
-- 
2.32.0


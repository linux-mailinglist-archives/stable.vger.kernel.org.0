Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55DB4395DA
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhJYMTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232838AbhJYMTm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD1A060ED4;
        Mon, 25 Oct 2021 12:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635164239;
        bh=L0WJ7+5+qewdB7If++5UO/OXlrBLv8K7CfrRjdsjZGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0zhdSrm88MzrpZEGr47ltIFcbqARd7v3mGvuH+4Noqnnq4UfmCmzlFMeUGorDzBW
         G5DV0V/RKq9QB/NuvEtPhUDMlzORi/vRVVtIUW2sNuQyNfByhH3GFfHx16yJ0JCnRz
         p7VJJGYdayVmQR3KE0Y9eDJB+fiUY9gRC4qhwP/W8R1AlnvC19yGryLv3aEMHepsH2
         W1NDrOKmK6kDoievkOhw0LWAlMcYmCU/mijoN66iHCQnuf08RJUysDKWz3LBblgFUb
         kQBR8I/wBJ6sNriOyUGB5Yw1TQ36pQ/pL8v1zCYgIm+gFU14TJf0f+Rv0gk5d42ewe
         OdpeaO5IlJboQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyuU-0001mP-Oa; Mon, 25 Oct 2021 14:17:02 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 5/8] media: em28xx: fix control-message timeouts
Date:   Mon, 25 Oct 2021 14:16:38 +0200
Message-Id: <20211025121641.6759-6-johan@kernel.org>
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

Fixes: a6c2ba283565 ("[PATCH] v4l: 716: support for em28xx board family")
Cc: stable@vger.kernel.org      # 2.6.16
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 584fa400cd7d..f366bb47ec6d 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -89,7 +89,7 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 	mutex_lock(&dev->ctrl_urb_lock);
 	ret = usb_control_msg(udev, pipe, req,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			      0x0000, reg, dev->urb_buf, len, HZ);
+			      0x0000, reg, dev->urb_buf, len, 1000);
 	if (ret < 0) {
 		em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x  failed with error %i\n",
 			      pipe,
@@ -158,7 +158,7 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 	memcpy(dev->urb_buf, buf, len);
 	ret = usb_control_msg(udev, pipe, req,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			      0x0000, reg, dev->urb_buf, len, HZ);
+			      0x0000, reg, dev->urb_buf, len, 1000);
 	mutex_unlock(&dev->ctrl_urb_lock);
 
 	if (ret < 0) {
-- 
2.32.0


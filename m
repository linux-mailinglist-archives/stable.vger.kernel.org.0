Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4F2439561
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhJYL5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230407AbhJYL5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C5AA61029;
        Mon, 25 Oct 2021 11:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635162929;
        bh=bZdzlKe/LWb4p4XJYCbaVFHmbJVo/uY8GPyInnmu2XU=;
        h=From:To:Cc:Subject:Date:From;
        b=JfAFMxwml2BbPBUd1ZqoN4L95sT6Egbps/ouFqehZRe1109RpDHXGKQu4VBp2Zg+F
         klsxEAjBkQLfUs+JWcgeeVwabwtiFwu3RBRyEuikWkg+5aTGTKmJFvJzClhgr5d9QF
         EvURcRwb7RUa9dU9/TfestKliI3ICm6HMNNoY0Q+APSA0c+gTBVGnDZtYr8kjpT9St
         CtwtmWBz96VW/VTk68Rr5qboQKSGHZ9+lv84BfFMCoU8AMj7fZGNR+fK/QNvBJG/MT
         YAV987k1AUt/p6XaypdZUYv1I9Dzn6V9FvqTnqCexjQz+HJnVG4288WUZ1qdBB2sWs
         uS+o2M/7DoUlQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyZM-0001MU-8Q; Mon, 25 Oct 2021 13:55:12 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] Input: iforce - fix control-message timeout
Date:   Mon, 25 Oct 2021 13:55:01 +0200
Message-Id: <20211025115501.5190-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 487358627825 ("Input: iforce - use DMA-safe buffer when getting IDs from USB")
Cc: stable@vger.kernel.org      # 5.3
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/input/joystick/iforce/iforce-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/joystick/iforce/iforce-usb.c b/drivers/input/joystick/iforce/iforce-usb.c
index 6c554c11a7ac..ea58805c480f 100644
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -92,7 +92,7 @@ static int iforce_usb_get_id(struct iforce *iforce, u8 id,
 				 id,
 				 USB_TYPE_VENDOR | USB_DIR_IN |
 					USB_RECIP_INTERFACE,
-				 0, 0, buf, IFORCE_MAX_LENGTH, HZ);
+				 0, 0, buf, IFORCE_MAX_LENGTH, 1000);
 	if (status < 0) {
 		dev_err(&iforce_usb->intf->dev,
 			"usb_submit_urb failed: %d\n", status);
-- 
2.32.0


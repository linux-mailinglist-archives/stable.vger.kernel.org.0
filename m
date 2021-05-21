Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A1438C828
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 15:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhEUNdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 09:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233143AbhEUNdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 09:33:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A00096023D;
        Fri, 21 May 2021 13:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621603917;
        bh=Il0NJuHMbBcpy+zchLo6gEH5+9R6BpMwY5I2nbfdy1I=;
        h=From:To:Cc:Subject:Date:From;
        b=M4+GRoc+jqmzyHM3SmSaww5WIv4H+mC0Zso/LdmefBsW5rD8jrubBURkYH/wH5yRr
         KVvW9u6NUo5LruC7oWK4BeZJqEa4FboJwwhzIhTdo68rWQxQF2zL1yyh2Ez6LuDGAY
         BY0m9fCFuP83n6w0LGuBpTV5xYSJpq0nGHUVdF0yoO5wAks8l8j+Z7X0ZMx+M6qwPM
         5ZgZjK41mHDKVPe2ZYweJjcqd2YAq25aNM0SjRd9BvXU3juVD2hh1nU18He40KzHbo
         /aa9jQYJd2mjPTKIIci83vzFlSIkngwHByLT4riorkGzQMfzZQtlmx4AXp12V56dj5
         0gTbygAhXWZVQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lk5Fu-0004XY-QY; Fri, 21 May 2021 15:31:58 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] USB: trancevibrator: fix control-request direction
Date:   Fri, 21 May 2021 15:31:09 +0200
Message-Id: <20210521133109.17396-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the set-speed request which erroneously used USB_DIR_IN and update
the default timeout argument to match (same value).

Fixes: 5638e4d92e77 ("USB: add PlayStation 2 Trance Vibrator driver")
Cc: stable@vger.kernel.org      # 2.6.19
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/trancevibrator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/trancevibrator.c b/drivers/usb/misc/trancevibrator.c
index a3dfc77578ea..26baba3ab7d7 100644
--- a/drivers/usb/misc/trancevibrator.c
+++ b/drivers/usb/misc/trancevibrator.c
@@ -61,9 +61,9 @@ static ssize_t speed_store(struct device *dev, struct device_attribute *attr,
 	/* Set speed */
 	retval = usb_control_msg(tv->udev, usb_sndctrlpipe(tv->udev, 0),
 				 0x01, /* vendor request: set speed */
-				 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_OTHER,
+				 USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
 				 tv->speed, /* speed value */
-				 0, NULL, 0, USB_CTRL_GET_TIMEOUT);
+				 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
 	if (retval) {
 		tv->speed = old;
 		dev_dbg(&tv->udev->dev, "retval = %d\n", retval);
-- 
2.26.3


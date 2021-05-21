Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C1038C815
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 15:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhEUNay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 09:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235439AbhEUNat (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 09:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4846E613D8;
        Fri, 21 May 2021 13:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621603766;
        bh=qO4SLfrW1W78bLSZRB/dcva+XP0knpmkyOnmLhDkIo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBxWl4F8qtQ8vxah7ELt8ou/YTjNMd/PXn3b6ldEZROchGHQnUVglsz6lyYpR+pRF
         YgyzcSqrIU4rG3uQoYjpKXwZz0sIvkHXeNnIXIHrobifR8qVbncuVAvRASVaE895+M
         uUvc87T2/UZxqmmPNy9LzuF4rhaRNmns5uTHaghuchqxF6rvd7+KHD6YSpCoSoKwOV
         WqtY0xLk1KO6V9CN7BNy9VU66JpobqnJSzEqEnNvVgzlOkOCTOUoc802Bf9n8Gwgrr
         wVIOpuB93gL3xMEDhTieLDu0m/M6j4Vis8yXq40HDa5A59vYFjN+e/u8KJZY6sQ5xW
         +lsmcGavZ88nQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lk5DT-0004Ts-E0; Fri, 21 May 2021 15:29:27 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] media: gspca/sq905: fix control-request direction
Date:   Fri, 21 May 2021 15:28:39 +0200
Message-Id: <20210521132839.17163-3-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210521132839.17163-1-johan@kernel.org>
References: <20210521132839.17163-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the USB_REQ_SYNCH_FRAME request which erroneously used
usb_sndctrlpipe().

Fixes: 27d35fc3fb06 ("V4L/DVB (10639): gspca - sq905: New subdriver.")
Cc: stable@vger.kernel.org      # 2.6.30
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/gspca/sq905.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index 949111070971..32504ebcfd4d 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -116,7 +116,7 @@ static int sq905_command(struct gspca_dev *gspca_dev, u16 index)
 	}
 
 	ret = usb_control_msg(gspca_dev->dev,
-			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      usb_rcvctrlpipe(gspca_dev->dev, 0),
 			      USB_REQ_SYNCH_FRAME,                /* request */
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      SQ905_PING, 0, gspca_dev->usb_buf, 1,
-- 
2.26.3


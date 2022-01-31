Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424964A47EE
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 14:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378660AbiAaNUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 08:20:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50086 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378634AbiAaNUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 08:20:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5459F61222
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 13:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E31C340E8;
        Mon, 31 Jan 2022 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643635221;
        bh=2rqKrnMEeSN8j+IbkYub0WNAduz+/BadhTgQ7aW6sp8=;
        h=Subject:To:From:Date:From;
        b=XRGZkiuFSjd3bI6nzno1b+sAVkIkmdXeO8SvWdDlE3y3kFoV3meXBk1Yf+4BGzS0/
         sZCtAA8panzLFic7503HFKSpEedzdGDANzRp++Z/bRu0X7t15msAN6S1jXy35LkQ3Y
         Z6f5QXSvlWL7YVBgaXFSqbNOLS71tcpyn3TOx+lQ=
Subject: patch "usb: raw-gadget: fix handling of dual-direction-capable endpoints" added to usb-testing
To:     jannh@google.com, andreyknvl@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 14:20:19 +0100
Message-ID: <164363521925212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: raw-gadget: fix handling of dual-direction-capable endpoints

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From d2d1bfa1e422242c3a794007857b463c081f3d5f Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Wed, 26 Jan 2022 21:52:14 +0100
Subject: usb: raw-gadget: fix handling of dual-direction-capable endpoints

Under dummy_hcd, every available endpoint is *either* IN or OUT capable.
But with some real hardware, there are endpoints that support both IN and
OUT. In particular, the PLX 2380 has four available endpoints that each
support both IN and OUT.

raw-gadget currently gets confused and thinks that any endpoint that is
usable as an IN endpoint can never be used as an OUT endpoint.

Fix it by looking at the direction in the configured endpoint descriptor
instead of looking at the hardware capabilities.

With this change, I can use the PLX 2380 with raw-gadget.

Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
Cc: stable <stable@vger.kernel.org>
Tested-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20220126205214.2149936-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index c5a2c734234a..d86c3a36441e 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -1004,7 +1004,7 @@ static int raw_process_ep_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	if ((in && !ep->ep->caps.dir_in) || (!in && ep->ep->caps.dir_in)) {
+	if (in != usb_endpoint_dir_in(ep->ep->desc)) {
 		dev_dbg(&dev->gadget->dev, "fail, wrong direction\n");
 		ret = -EINVAL;
 		goto out_unlock;
-- 
2.35.1



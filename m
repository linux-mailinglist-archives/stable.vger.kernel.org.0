Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED6C3E8162
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbhHJR67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237163AbhHJR4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F8F0610FC;
        Tue, 10 Aug 2021 17:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617512;
        bh=sJcqfH1Q4IrnK/z7vHlXFzLXPIrHRa2rRBS6dIPiPA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mO94tx+Ou0B6cXNbF0lluSz4layUZKbGybdULBKViaEmjoeXo0k5/mdHpZxUI+2cl
         5I6bJEHGVjE9YWRT/Jpl7sVirqWJHn6SBSagnjHcZgHwPOc5Uk3a78H17SbloMUIMx
         WCCraXe6/NPQfyqaFY4gLc/L+0YeSUXj2VO3uD4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.13 090/175] usb: dwc3: gadget: Avoid runtime resume if disabling pullup
Date:   Tue, 10 Aug 2021 19:29:58 +0200
Message-Id: <20210810173003.905650577@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

commit cb10f68ad8150f243964b19391711aaac5e8ff42 upstream.

If the device is already in the runtime suspended state, any call to
the pullup routine will issue a runtime resume on the DWC3 core
device.  If the USB gadget is disabling the pullup, then avoid having
to issue a runtime resume, as DWC3 gadget has already been
halted/stopped.

This fixes an issue where the following condition occurs:

usb_gadget_remove_driver()
-->usb_gadget_disconnect()
 -->dwc3_gadget_pullup(0)
  -->pm_runtime_get_sync() -> ret = 0
  -->pm_runtime_put() [async]
-->usb_gadget_udc_stop()
 -->dwc3_gadget_stop()
  -->dwc->gadget_driver = NULL
...

dwc3_suspend_common()
-->dwc3_gadget_suspend()
 -->DWC3 halt/stop routine skipped, driver_data == NULL

This leads to a situation where the DWC3 gadget is not properly
stopped, as the runtime resume would have re-enabled EP0 and event
interrupts, and since we avoided the DWC3 gadget suspend, these
resources were never disabled.

Fixes: 77adb8bdf422 ("usb: dwc3: gadget: Allow runtime suspend if UDC unbinded")
Cc: stable <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1628058245-30692-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2257,6 +2257,17 @@ static int dwc3_gadget_pullup(struct usb
 	}
 
 	/*
+	 * Avoid issuing a runtime resume if the device is already in the
+	 * suspended state during gadget disconnect.  DWC3 gadget was already
+	 * halted/stopped during runtime suspend.
+	 */
+	if (!is_on) {
+		pm_runtime_barrier(dwc->dev);
+		if (pm_runtime_suspended(dwc->dev))
+			return 0;
+	}
+
+	/*
 	 * Check the return value for successful resume, or error.  For a
 	 * successful resume, the DWC3 runtime PM resume routine will handle
 	 * the run stop sequence, so avoid duplicate operations here.



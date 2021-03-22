Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEBE344178
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhCVMdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231472AbhCVMcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20E31619A1;
        Mon, 22 Mar 2021 12:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416374;
        bh=RxPl6/jiqexNBGfTT6X4uA9A03ucKHyGnrIVxBeqF+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlOKHWeyHWOhHFn59BygM4mY9uCR0qAzeiQo4n/ZgISrzCVmM13agICMLTb4+QCWl
         Be+R4H7xgAOazV5iuevIT/zCqwBFkJQBTqpEq4SMawzjXV+7L3I1e9AUMpC7tkE/kP
         iRacrg2XHNYgpX77tMhTl4sO58hdQLPY//pPwmdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.11 083/120] usb: dwc3: gadget: Allow runtime suspend if UDC unbinded
Date:   Mon, 22 Mar 2021 13:27:46 +0100
Message-Id: <20210322121932.444455792@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

commit 77adb8bdf4227257e26b7ff67272678e66a0b250 upstream.

The DWC3 runtime suspend routine checks for the USB connected parameter to
determine if the controller can enter into a low power state.  The
connected state is only set to false after receiving a disconnect event.
However, in the case of a device initiated disconnect (i.e. UDC unbind),
the controller is halted and a disconnect event is never generated.  Set
the connected flag to false if issuing a device initiated disconnect to
allow the controller to be suspended.

Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1609283136-22140-2-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2126,6 +2126,17 @@ static int dwc3_gadget_pullup(struct usb
 	}
 
 	/*
+	 * Check the return value for successful resume, or error.  For a
+	 * successful resume, the DWC3 runtime PM resume routine will handle
+	 * the run stop sequence, so avoid duplicate operations here.
+	 */
+	ret = pm_runtime_get_sync(dwc->dev);
+	if (!ret || ret < 0) {
+		pm_runtime_put(dwc->dev);
+		return 0;
+	}
+
+	/*
 	 * Synchronize any pending event handling before executing the controller
 	 * halt routine.
 	 */
@@ -2163,12 +2174,14 @@ static int dwc3_gadget_pullup(struct usb
 			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
 						dwc->ev_buf->length;
 		}
+		dwc->connected = false;
 	} else {
 		__dwc3_gadget_start(dwc);
 	}
 
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	pm_runtime_put(dwc->dev);
 
 	return ret;
 }



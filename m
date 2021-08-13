Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8D83EB8B2
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242493AbhHMPP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242506AbhHMPOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C0E60F51;
        Fri, 13 Aug 2021 15:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867634;
        bh=zuRilsIRSEesbf7v7ankndhGatN2FVYNrlVZq7HniQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buXPMLzg0RXb7TIU4II72TszJHFiDgADi3sqU4fPfh6bbyoxv8VqsUJJLCkw3YicP
         Yw3VJAQu9i9QYQfJlmBSWpyUae0LTGx46CY3OY2ip4qj3eLQCEimSEQVwAPdf5q67+
         K0lPYIZriYiJH06a38s0nhbZMGjuNNe1BDgVo5Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Wesley Cheng" <wcheng@codeaurora.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 06/27] usb: dwc3: gadget: Allow runtime suspend if UDC unbinded
Date:   Fri, 13 Aug 2021 17:07:04 +0200
Message-Id: <20210813150523.580367784@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit 77adb8bdf4227257e26b7ff67272678e66a0b250 ]

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
@@ -2018,6 +2018,17 @@ static int dwc3_gadget_pullup(struct usb
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
@@ -2055,10 +2066,12 @@ static int dwc3_gadget_pullup(struct usb
 			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
 						dwc->ev_buf->length;
 		}
+		dwc->connected = false;
 	}
 
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	pm_runtime_put(dwc->dev);
 
 	return ret;
 }



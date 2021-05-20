Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4840538A50A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhETKMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236026AbhETKKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:10:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4902B6142D;
        Thu, 20 May 2021 09:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503782;
        bh=yyouw4ANJaF3nE2IJKqG0tuz2BEuU1ePiRNPEvd+2gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fiCldZ2eN/EF9N5l9Fym0lImhkuaRa9fBp5lb/TQL1pdoziUrbEAoKHlagTnoRilF
         b7RljZhvnSlhwLJe8ihJ08SyxOmHDqczTSH4IrUzC2zIKC2nByodEbM4QAOJ09ffrw
         Hco+lsZbEuidaav0vZoHbZLBMTau3MSvYECc5wBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 4.19 378/425] usb: dwc3: gadget: Return success always for kick transfer in ep queue
Date:   Thu, 20 May 2021 11:22:27 +0200
Message-Id: <20210520092143.818252662@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

commit 18ffa988dbae69cc6e9949cddd9606f6fe533894 upstream.

If an error is received when issuing a start or update transfer
command, the error handler will stop all active requests (including
the current USB request), and call dwc3_gadget_giveback() to notify
function drivers of the requests which have been stopped.  Avoid
returning an error for kick transfer during EP queue, to remove
duplicate cleanup operations on the request being queued.

Fixes: 8d99087c2db8 ("usb: dwc3: gadget: Properly handle failed kick_transfer")
cc: stable@vger.kernel.org
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1620410119-24971-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1413,7 +1413,9 @@ static int __dwc3_gadget_ep_queue(struct
 		}
 	}
 
-	return __dwc3_gadget_kick_transfer(dep);
+	__dwc3_gadget_kick_transfer(dep);
+
+	return 0;
 }
 
 static int dwc3_gadget_ep_queue(struct usb_ep *ep, struct usb_request *request,



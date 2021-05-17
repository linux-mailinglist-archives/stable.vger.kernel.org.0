Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E19383709
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245001AbhEQPi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244314AbhEQPg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:36:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE1AF6193E;
        Mon, 17 May 2021 14:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262420;
        bh=G0ZouCx4KY8m+lgR/uSo9qQJuuWGppTL+4CPKntMjnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Elp4+GaN1YBrIsXHF751jiVgoI61O0Ar83/A5ujS504qiEC9C12PkrVyOokouDGhq
         kUfPKSYHXYR9qjg7Ucotot8f+vvGU0KH6HDL02W9oONv7lTYpTs7Hx0k6gdU+k9sVV
         baiLmXrXIVPNBazX/zfXd/vFrJMBhAtl78VoUuqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.11 287/329] usb: dwc3: gadget: Return success always for kick transfer in ep queue
Date:   Mon, 17 May 2021 16:03:18 +0200
Message-Id: <20210517140311.812102781@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
@@ -1676,7 +1676,9 @@ static int __dwc3_gadget_ep_queue(struct
 		}
 	}
 
-	return __dwc3_gadget_kick_transfer(dep);
+	__dwc3_gadget_kick_transfer(dep);
+
+	return 0;
 }
 
 static int dwc3_gadget_ep_queue(struct usb_ep *ep, struct usb_request *request,



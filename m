Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2702444C801
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhKJS5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233027AbhKJSzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:55:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57F1E61279;
        Wed, 10 Nov 2021 18:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570176;
        bh=JNdynLpeDmu9NFBKceo37u4Nd1rMzCB8lZ4lphLDOWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MT5PXV8+JsdbWC5vrlM95Q9w9CDQ+qTFvIIgIyHqgJftcOIRWJgRPPDK1ZRNtCEwX
         I7jtyXbJznixhNBz88sovhtcQYdilvM9AYRm3VGyPGybXnIHtghECJ6/84aCrygVvb
         jXxs1AazkocMzXJN+Pcdc8uDkv73/QllW6lU2jSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viraj Shah <viraj.shah@linutronix.de>
Subject: [PATCH 5.14 07/24] usb: musb: Balance list entry in musb_gadget_queue
Date:   Wed, 10 Nov 2021 19:43:59 +0100
Message-Id: <20211110182003.568255857@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viraj Shah <viraj.shah@linutronix.de>

commit 21b5fcdccb32ff09b6b63d4a83c037150665a83f upstream.

musb_gadget_queue() adds the passed request to musb_ep::req_list. If the
endpoint is idle and it is the first request then it invokes
musb_queue_resume_work(). If the function returns an error then the
error is passed to the caller without any clean-up and the request
remains enqueued on the list. If the caller enqueues the request again
then the list corrupts.

Remove the request from the list on error.

Fixes: ea2f35c01d5ea ("usb: musb: Fix sleeping function called from invalid context for hdrc glue")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Viraj Shah <viraj.shah@linutronix.de>
Link: https://lore.kernel.org/r/20211021093644.4734-1-viraj.shah@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_gadget.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1247,9 +1247,11 @@ static int musb_gadget_queue(struct usb_
 		status = musb_queue_resume_work(musb,
 						musb_ep_restart_resume_work,
 						request);
-		if (status < 0)
+		if (status < 0) {
 			dev_err(musb->controller, "%s resume work: %i\n",
 				__func__, status);
+			list_del(&request->list);
+		}
 	}
 
 unlock:



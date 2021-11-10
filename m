Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C264944C79C
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhKJSxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:53:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233010AbhKJSuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:50:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 890BD61361;
        Wed, 10 Nov 2021 18:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570019;
        bh=1jwbG5JvQnwVZJOTrihR3UoYDfVzfY9qH4ncG3kh3WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0Ar+3PL3pP3sTlvA6DLUSnI8TrusmhuZlhmGnELCePQ6o5xnGxS9GelPZ5xptZIf
         5wi5Bh7k1ftaVjAtYLRrmanoaEZPtomWO/uAT6A2maI65vn5vdhK2PYeINR7G7ChPO
         +GH1N4lIJpsF2IVmZhB/nRwE7dg+uD8lX0Gc9Xgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viraj Shah <viraj.shah@linutronix.de>
Subject: [PATCH 4.19 05/16] usb: musb: Balance list entry in musb_gadget_queue
Date:   Wed, 10 Nov 2021 19:43:38 +0100
Message-Id: <20211110182002.167181265@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.994215976@linuxfoundation.org>
References: <20211110182001.994215976@linuxfoundation.org>
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
@@ -1248,9 +1248,11 @@ static int musb_gadget_queue(struct usb_
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



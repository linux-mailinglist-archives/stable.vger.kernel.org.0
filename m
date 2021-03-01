Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D5A3287E4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbhCARaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:30:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234286AbhCARYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:24:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD8B06507D;
        Mon,  1 Mar 2021 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617415;
        bh=Vf/mP1BLKmacIa0agHRI821sFIg0zv3CWRh5oIfZ7wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcY7yoEL/2BBvMYMuo3ilBKyCel1ksPLwjdoYqZugJORtgCnWEpZYzMkrvFyRHuxf
         7wncigrdDyGsza+TxKrrkRFN0t8BSiLhQNDdwSj8v9o3sQhp3811TiujjQrt8Ks2iP
         ykf7J5RT8L8rTXg9iMKGGIBxo3A3oTACOF1eaP1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Jack Pham <jackp@codeaurora.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, Ferry Toth <fntoth@gmail.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.4 036/340] usb: gadget: u_audio: Free requests only after callback
Date:   Mon,  1 Mar 2021 17:09:40 +0100
Message-Id: <20210301161050.091326273@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

[ Upstream commit 7de8681be2cde9f6953d3be1fa6ce05f9fe6e637 ]

As per the kernel doc for usb_ep_dequeue(), it states that "this
routine is asynchronous, that is, it may return before the completion
routine runs". And indeed since v5.0 the dwc3 gadget driver updated
its behavior to place dequeued requests on to a cancelled list to be
given back later after the endpoint is stopped.

The free_ep() was incorrectly assuming that a request was ready to
be freed after calling dequeue which results in a use-after-free
in dwc3 when it traverses its cancelled list. Fix this by moving
the usb_ep_free_request() call to the callback itself in case the
ep is disabled.

Fixes: eb9fecb9e69b0 ("usb: gadget: f_uac2: split out audio core")
Reported-and-tested-by: Ferry Toth <fntoth@gmail.com>
Reviewed-and-tested-by: Peter Chen <peter.chen@nxp.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20210118084642.322510-2-jbrunet@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_audio.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 56906d15fb551..223029fa84459 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -89,7 +89,12 @@ static void u_audio_iso_complete(struct usb_ep *ep, struct usb_request *req)
 	struct snd_uac_chip *uac = prm->uac;
 
 	/* i/f shutting down */
-	if (!prm->ep_enabled || req->status == -ESHUTDOWN)
+	if (!prm->ep_enabled) {
+		usb_ep_free_request(ep, req);
+		return;
+	}
+
+	if (req->status == -ESHUTDOWN)
 		return;
 
 	/*
@@ -351,8 +356,14 @@ static inline void free_ep(struct uac_rtd_params *prm, struct usb_ep *ep)
 
 	for (i = 0; i < params->req_number; i++) {
 		if (prm->ureq[i].req) {
-			usb_ep_dequeue(ep, prm->ureq[i].req);
-			usb_ep_free_request(ep, prm->ureq[i].req);
+			if (usb_ep_dequeue(ep, prm->ureq[i].req))
+				usb_ep_free_request(ep, prm->ureq[i].req);
+			/*
+			 * If usb_ep_dequeue() cannot successfully dequeue the
+			 * request, the request will be freed by the completion
+			 * callback.
+			 */
+
 			prm->ureq[i].req = NULL;
 		}
 	}
-- 
2.27.0




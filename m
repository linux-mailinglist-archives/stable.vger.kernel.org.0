Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6ED99DDC
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393027AbfHVRp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391694AbfHVRW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:59 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D198223406;
        Thu, 22 Aug 2019 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494579;
        bh=4gWfYNzBnOxEGicvWI82+pjLANlhKX0clIolvnuZ+Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPMM0ZP1SxNI1SoBSrYbuWqObmOP4H0NTjNtM64FMmrcSRwVUwMKMzI+/vX7VPjO4
         7+IZLBUowgq5+5Z93IKMeDd5H67V/0+RwicpJAKkPBb8Uqsd8GIwQ0NHt5tVJ/qBtL
         1yGf10bxG/9IeHL4CVol0/TsfJiGjn83mi1eTkpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tuba Yavuz <tuba@ece.ufl.edu>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 35/78] USB: gadget: f_midi: fixing a possible double-free in f_midi
Date:   Thu, 22 Aug 2019 10:18:39 -0700
Message-Id: <20190822171833.060423953@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yavuz, Tuba <tuba@ece.ufl.edu>

commit 7fafcfdf6377b18b2a726ea554d6e593ba44349f upstream.

It looks like there is a possibility of a double-free vulnerability on an
error path of the f_midi_set_alt function in the f_midi driver. If the
path is feasible then free_ep_req gets called twice:

         req->complete = f_midi_complete;
         err = usb_ep_queue(midi->out_ep, req, GFP_ATOMIC);
            => ...
             usb_gadget_giveback_request
               =>
                 f_midi_complete (CALLBACK)
                   (inside f_midi_complete, for various cases of status)
                   free_ep_req(ep, req); // first kfree
         if (err) {
                 ERROR(midi, "%s: couldn't enqueue request: %d\n",
                             midi->out_ep->name, err);
                 free_ep_req(midi->out_ep, req); // second kfree
                 return err;
         }

The double-free possibility was introduced with commit ad0d1a058eac
("usb: gadget: f_midi: fix leak on failed to enqueue out requests").

Found by MOXCAFE tool.

Signed-off-by: Tuba Yavuz <tuba@ece.ufl.edu>
Fixes: ad0d1a058eac ("usb: gadget: f_midi: fix leak on failed to enqueue out requests")
Acked-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_midi.c |    3 ++-
 drivers/usb/gadget/u_f.h             |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -366,7 +366,8 @@ static int f_midi_set_alt(struct usb_fun
 		if (err) {
 			ERROR(midi, "%s: couldn't enqueue request: %d\n",
 				    midi->out_ep->name, err);
-			free_ep_req(midi->out_ep, req);
+			if (req->buf != NULL)
+				free_ep_req(midi->out_ep, req);
 			return err;
 		}
 	}
--- a/drivers/usb/gadget/u_f.h
+++ b/drivers/usb/gadget/u_f.h
@@ -65,7 +65,9 @@ struct usb_request *alloc_ep_req(struct
 /* Frees a usb_request previously allocated by alloc_ep_req() */
 static inline void free_ep_req(struct usb_ep *ep, struct usb_request *req)
 {
+	WARN_ON(req->buf == NULL);
 	kfree(req->buf);
+	req->buf = NULL;
 	usb_ep_free_request(ep, req);
 }
 



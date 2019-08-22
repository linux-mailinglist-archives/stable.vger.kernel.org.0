Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A93D699DF8
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393110AbfHVRqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391620AbfHVRWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:51 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA2F9233FE;
        Thu, 22 Aug 2019 17:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494570;
        bh=ucRkhBH+L2tLAUfazZFq0LToclejLtrPTmuM4DcQjec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5qRSUEOPl172LKLZT/cGTwXfy8JQAZBfzUYJ6cj5vddAQauai1N7lQCdA75dIlj3
         Wns/wHfOY2GrCnXTmDWQx+5RssSuCsDBJmZfn39ReJlqxXq4cKTxz8XxGVNxVJTGlw
         2MQIoiN2HaRJEYQbGQAtx1S5FhtSx+QpOn8zdQ/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Felipe F. Tonello" <eu@felipetonello.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 4.4 34/78] usb: gadget: f_midi: fail if set_alt fails to allocate requests
Date:   Thu, 22 Aug 2019 10:18:38 -0700
Message-Id: <20190822171833.031560087@linuxfoundation.org>
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

From: Felipe F. Tonello <eu@felipetonello.com>

commit f0f1b8cac4d8d973e95f25d9ea132775fb43c5f4 upstream.

This ensures that the midi function will only work if the proper number of
IN and OUT requrests are allocated. Otherwise the function will work with less
requests then what the user wants.

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
From: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_midi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -364,9 +364,10 @@ static int f_midi_set_alt(struct usb_fun
 		req->complete = f_midi_complete;
 		err = usb_ep_queue(midi->out_ep, req, GFP_ATOMIC);
 		if (err) {
-			ERROR(midi, "%s queue req: %d\n",
+			ERROR(midi, "%s: couldn't enqueue request: %d\n",
 				    midi->out_ep->name, err);
 			free_ep_req(midi->out_ep, req);
+			return err;
 		}
 	}
 



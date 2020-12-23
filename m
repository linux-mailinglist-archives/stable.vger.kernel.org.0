Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C352E1E45
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgLWPgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbgLWPeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F3CD233A1;
        Wed, 23 Dec 2020 15:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737622;
        bh=VSnBL4f5pgjlnXUot2WMuYZ+6vRGmw+BBFwmPtVlQFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOEz/N2tVrEvd73KNSwEwXJ6iuW6dYoYkzWitMsSL383dnNouvXo60m9mj+D65O4Y
         siDqmqm4Vxbgr5ZtdsBFi7T6sOGH4cWTwxKUgHC6Rp77UZHgnyXjdriyOajY2S2gAO
         6mpL+AB3clxUOlIohWnZXWHRF+yopELWhUM2rLA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Will McVicker <willmcvicker@google.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.10 08/40] USB: gadget: f_midi: setup SuperSpeed Plus descriptors
Date:   Wed, 23 Dec 2020 16:33:09 +0100
Message-Id: <20201223150515.971325515@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will McVicker <willmcvicker@google.com>

commit 457a902ba1a73b7720666b21ca038cd19764db18 upstream.

Needed for SuperSpeed Plus support for f_midi.  This allows the
gadget to work properly without crashing at SuperSpeed rates.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20201127140559.381351-4-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_midi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1048,6 +1048,12 @@ static int f_midi_bind(struct usb_config
 		f->ss_descriptors = usb_copy_descriptors(midi_function);
 		if (!f->ss_descriptors)
 			goto fail_f_midi;
+
+		if (gadget_is_superspeed_plus(c->cdev->gadget)) {
+			f->ssp_descriptors = usb_copy_descriptors(midi_function);
+			if (!f->ssp_descriptors)
+				goto fail_f_midi;
+		}
 	}
 
 	kfree(midi_function);



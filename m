Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9032E3865
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbgL1NJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:09:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731228AbgL1NJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:09:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9157D20728;
        Mon, 28 Dec 2020 13:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160953;
        bh=VSnBL4f5pgjlnXUot2WMuYZ+6vRGmw+BBFwmPtVlQFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08gPXtduDAmJGgM0whJ3fvxm0B0JDnTniX6g42Vs13P25iKE+ryFFN49kXKl0E39t
         PXhCMOK6SOG71o58IbVLIQpIVddDRoVbIFycD/3ae25ZM9Q4VbMeOUDmPgt/thLdzz
         5T7rhRLqe+9M0byp9dhGHU9Z7CvZh0HhIqIR+Bbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Will McVicker <willmcvicker@google.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 4.14 051/242] USB: gadget: f_midi: setup SuperSpeed Plus descriptors
Date:   Mon, 28 Dec 2020 13:47:36 +0100
Message-Id: <20201228124907.195840477@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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



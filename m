Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6A26DB78
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbfGSEIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731920AbfGSEIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:08:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8282A2189D;
        Fri, 19 Jul 2019 04:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509329;
        bh=sjrm5f2fQ8z79TJJx53UQ+uXfdj9Q8vaJfurVb6GqNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/HYzGe/dQ687YY8Upw4hcv+31YDRjp9V3TdlG/bSuuPxZPn6FvKRxQrmY24EeFI7
         q/l+fD2LAfF5TPEBT50bUWov6Y4YU09rsVJqELkS/Fc3BDAdfybNDbTpS00xk1iOOK
         htCX3YTIo+LRHpXTRpdjswdceGXXLQj0g2qHxQ+Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     EJ Hsu <ejh@nvidia.com>, Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 036/101] usb: gadget: storage: Remove warning message
Date:   Fri, 19 Jul 2019 00:06:27 -0400
Message-Id: <20190719040732.17285-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: EJ Hsu <ejh@nvidia.com>

[ Upstream commit e70b3f5da00119e057b7faa557753fee7f786f17 ]

This change is to fix below warning message in following scenario:
usb_composite_setup_continue: Unexpected call

When system tried to enter suspend, the fsg_disable() will be called to
disable fsg driver and send a signal to fsg_main_thread. However, at
this point, the fsg_main_thread has already been frozen and can not
respond to this signal. So, this signal will be pended until
fsg_main_thread wakes up.

Once system resumes from suspend, fsg_main_thread will detect a signal
pended and do some corresponding action (in handle_exception()). Then,
host will send some setup requests (get descriptor, set configuration...)
to UDC driver trying to enumerate this device. During the handling of "set
configuration" request, it will try to sync up with fsg_main_thread by
sending a signal (which is the same as the signal sent by fsg_disable)
to it. In a similar manner, once the fsg_main_thread receives this
signal, it will call handle_exception() to handle the request.

However, if the fsg_main_thread wakes up from suspend a little late and
"set configuration" request from Host arrives a little earlier,
fsg_main_thread might come across the request from "set configuration"
when it handles the signal from fsg_disable(). In this case, it will
handle this request as well. So, when fsg_main_thread tries to handle
the signal sent from "set configuration" later, there will nothing left
to do and warning message "Unexpected call" is printed.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: EJ Hsu <ejh@nvidia.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 21 ++++++++++++++------
 drivers/usb/gadget/function/storage_common.h |  1 +
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 1074cb82ec17..c712b338f05f 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2293,8 +2293,7 @@ static int fsg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 static void fsg_disable(struct usb_function *f)
 {
 	struct fsg_dev *fsg = fsg_from_func(f);
-	fsg->common->new_fsg = NULL;
-	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+	raise_exception(fsg->common, FSG_STATE_DISCONNECT);
 }
 
 
@@ -2307,6 +2306,7 @@ static void handle_exception(struct fsg_common *common)
 	enum fsg_state		old_state;
 	struct fsg_lun		*curlun;
 	unsigned int		exception_req_tag;
+	struct fsg_dev		*fsg;
 
 	/*
 	 * Clear the existing signals.  Anything but SIGUSR1 is converted
@@ -2413,9 +2413,19 @@ static void handle_exception(struct fsg_common *common)
 		break;
 
 	case FSG_STATE_CONFIG_CHANGE:
-		do_set_interface(common, common->new_fsg);
-		if (common->new_fsg)
+		fsg = common->new_fsg;
+		/*
+		 * Add a check here to double confirm if a disconnect event
+		 * occurs and common->new_fsg has been cleared.
+		 */
+		if (fsg) {
+			do_set_interface(common, fsg);
 			usb_composite_setup_continue(common->cdev);
+		}
+		break;
+
+	case FSG_STATE_DISCONNECT:
+		do_set_interface(common, NULL);
 		break;
 
 	case FSG_STATE_EXIT:
@@ -2989,8 +2999,7 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	DBG(fsg, "unbind\n");
 	if (fsg->common->fsg == fsg) {
-		fsg->common->new_fsg = NULL;
-		raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+		raise_exception(fsg->common, FSG_STATE_DISCONNECT);
 		/* FIXME: make interruptible or killable somehow? */
 		wait_event(common->fsg_wait, common->fsg != fsg);
 	}
diff --git a/drivers/usb/gadget/function/storage_common.h b/drivers/usb/gadget/function/storage_common.h
index e5e3a2553aaa..12687f7e3de9 100644
--- a/drivers/usb/gadget/function/storage_common.h
+++ b/drivers/usb/gadget/function/storage_common.h
@@ -161,6 +161,7 @@ enum fsg_state {
 	FSG_STATE_ABORT_BULK_OUT,
 	FSG_STATE_PROTOCOL_RESET,
 	FSG_STATE_CONFIG_CHANGE,
+	FSG_STATE_DISCONNECT,
 	FSG_STATE_EXIT,
 	FSG_STATE_TERMINATED
 };
-- 
2.20.1


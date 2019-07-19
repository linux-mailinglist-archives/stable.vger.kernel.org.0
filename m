Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 174D16DD23
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbfGSELx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388508AbfGSELv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:11:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6629121873;
        Fri, 19 Jul 2019 04:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509510;
        bh=sacn3cJ+R1kePnKDNwAsaeKzn1gYRQe/keIiGUCKDbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tENu29knR0I0/Z2ckylTzUic5JYHiQkMCui/B9BEuFD05Pqsl2rDIbg9ZiyDO6we6
         LuBNSXxCu5iWB7GAzmADSdpqxjIw7VKGAy9zTXKaedEAr0m/yTy8QONvc5or7I4ZSy
         q0G6QBOWdWnk77SHpj74wdCcCgJt6R7tLgpOSaaQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     EJ Hsu <ejh@nvidia.com>, Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 22/60] usb: gadget: storage: Remove warning message
Date:   Fri, 19 Jul 2019 00:10:31 -0400
Message-Id: <20190719041109.18262-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
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
index 25ba30329533..a74639289760 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2295,8 +2295,7 @@ static int fsg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 static void fsg_disable(struct usb_function *f)
 {
 	struct fsg_dev *fsg = fsg_from_func(f);
-	fsg->common->new_fsg = NULL;
-	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+	raise_exception(fsg->common, FSG_STATE_DISCONNECT);
 }
 
 
@@ -2309,6 +2308,7 @@ static void handle_exception(struct fsg_common *common)
 	enum fsg_state		old_state;
 	struct fsg_lun		*curlun;
 	unsigned int		exception_req_tag;
+	struct fsg_dev		*fsg;
 
 	/*
 	 * Clear the existing signals.  Anything but SIGUSR1 is converted
@@ -2415,9 +2415,19 @@ static void handle_exception(struct fsg_common *common)
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
@@ -3007,8 +3017,7 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 
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


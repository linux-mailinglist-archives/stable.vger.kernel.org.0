Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6555296079
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbfHTNlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbfHTNlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:41:08 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF8C2087E;
        Tue, 20 Aug 2019 13:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308467;
        bh=raOrY5VcQCrpTE9XAV1IsbgMSyjwTSUi9PHXz5s6vRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuPNAxmgfC+Zxeicy2pYkRiFsUexi2+Nz3ZdOzjBasJLTBiVaxkMTqJqIEsmckGe8
         Z4k2xhzfMWiLTURi2G+pAyf++MMD3hClBnGpajmrV0e4vwRloLdgVf3brycr166TII
         yZ6D1rAP/cRzuNzwo5DbcEiJfNX1EH4gPvZdcpFI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 29/44] usb: gadget: mass_storage: Fix races between fsg_disable and fsg_set_alt
Date:   Tue, 20 Aug 2019 09:40:13 -0400
Message-Id: <20190820134028.10829-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

[ Upstream commit 4a56a478a525d6427be90753451c40e1327caa1a ]

If fsg_disable() and fsg_set_alt() are called too closely to each
other (for example due to a quick reset/reconnect), what can happen
is that fsg_set_alt sets common->new_fsg from an interrupt while
handle_exception is trying to process the config change caused by
fsg_disable():

	fsg_disable()
	...
	handle_exception()
		sets state back to FSG_STATE_NORMAL
		hasn't yet called do_set_interface()
		or is inside it.

 ---> interrupt
	fsg_set_alt
		sets common->new_fsg
		queues a new FSG_STATE_CONFIG_CHANGE
 <---

Now, the first handle_exception can "see" the updated
new_fsg, treats it as if it was a fsg_set_alt() response,
call usb_composite_setup_continue() etc...

But then, the thread sees the second FSG_STATE_CONFIG_CHANGE,
and goes back down the same path, wipes and reattaches a now
active fsg, and .. calls usb_composite_setup_continue() which
at this point is wrong.

Not only we get a backtrace, but I suspect the second set_interface
wrecks some state causing the host to get upset in my case.

This fixes it by replacing "new_fsg" by a "state argument" (same
principle) which is set in the same lock section as the state
update, and retrieved similarly.

That way, there is never any discrepancy between the dequeued
state and the observed value of it. We keep the ability to have
the latest reconfig operation take precedence, but we guarantee
that once "dequeued" the argument (new_fsg) will not be clobbered
by any new event.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 28 +++++++++++++-------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 043f97ad8f226..f2bc8d0370676 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -261,7 +261,7 @@ struct fsg_common;
 struct fsg_common {
 	struct usb_gadget	*gadget;
 	struct usb_composite_dev *cdev;
-	struct fsg_dev		*fsg, *new_fsg;
+	struct fsg_dev		*fsg;
 	wait_queue_head_t	io_wait;
 	wait_queue_head_t	fsg_wait;
 
@@ -290,6 +290,7 @@ struct fsg_common {
 	unsigned int		bulk_out_maxpacket;
 	enum fsg_state		state;		/* For exception handling */
 	unsigned int		exception_req_tag;
+	void			*exception_arg;
 
 	enum data_direction	data_dir;
 	u32			data_size;
@@ -391,7 +392,8 @@ static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
 
 /* These routines may be called in process context or in_irq */
 
-static void raise_exception(struct fsg_common *common, enum fsg_state new_state)
+static void __raise_exception(struct fsg_common *common, enum fsg_state new_state,
+			      void *arg)
 {
 	unsigned long		flags;
 
@@ -404,6 +406,7 @@ static void raise_exception(struct fsg_common *common, enum fsg_state new_state)
 	if (common->state <= new_state) {
 		common->exception_req_tag = common->ep0_req_tag;
 		common->state = new_state;
+		common->exception_arg = arg;
 		if (common->thread_task)
 			send_sig_info(SIGUSR1, SEND_SIG_PRIV,
 				      common->thread_task);
@@ -411,6 +414,10 @@ static void raise_exception(struct fsg_common *common, enum fsg_state new_state)
 	spin_unlock_irqrestore(&common->lock, flags);
 }
 
+static void raise_exception(struct fsg_common *common, enum fsg_state new_state)
+{
+	__raise_exception(common, new_state, NULL);
+}
 
 /*-------------------------------------------------------------------------*/
 
@@ -2285,16 +2292,16 @@ static int do_set_interface(struct fsg_common *common, struct fsg_dev *new_fsg)
 static int fsg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 {
 	struct fsg_dev *fsg = fsg_from_func(f);
-	fsg->common->new_fsg = fsg;
-	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+
+	__raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE, fsg);
 	return USB_GADGET_DELAYED_STATUS;
 }
 
 static void fsg_disable(struct usb_function *f)
 {
 	struct fsg_dev *fsg = fsg_from_func(f);
-	fsg->common->new_fsg = NULL;
-	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+
+	__raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE, NULL);
 }
 
 
@@ -2307,6 +2314,7 @@ static void handle_exception(struct fsg_common *common)
 	enum fsg_state		old_state;
 	struct fsg_lun		*curlun;
 	unsigned int		exception_req_tag;
+	struct fsg_dev		*new_fsg;
 
 	/*
 	 * Clear the existing signals.  Anything but SIGUSR1 is converted
@@ -2360,6 +2368,7 @@ static void handle_exception(struct fsg_common *common)
 	common->next_buffhd_to_fill = &common->buffhds[0];
 	common->next_buffhd_to_drain = &common->buffhds[0];
 	exception_req_tag = common->exception_req_tag;
+	new_fsg = common->exception_arg;
 	old_state = common->state;
 	common->state = FSG_STATE_NORMAL;
 
@@ -2413,8 +2422,8 @@ static void handle_exception(struct fsg_common *common)
 		break;
 
 	case FSG_STATE_CONFIG_CHANGE:
-		do_set_interface(common, common->new_fsg);
-		if (common->new_fsg)
+		do_set_interface(common, new_fsg);
+		if (new_fsg)
 			usb_composite_setup_continue(common->cdev);
 		break;
 
@@ -2989,8 +2998,7 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	DBG(fsg, "unbind\n");
 	if (fsg->common->fsg == fsg) {
-		fsg->common->new_fsg = NULL;
-		raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+		__raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE, NULL);
 		/* FIXME: make interruptible or killable somehow? */
 		wait_event(common->fsg_wait, common->fsg != fsg);
 	}
-- 
2.20.1


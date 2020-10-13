Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD0A28CBF7
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 12:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgJMKsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 06:48:32 -0400
Received: from z5.mailgun.us ([104.130.96.5]:24524 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgJMKsY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Oct 2020 06:48:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602586103; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=GrK4ODUxeO6+CHYnqlMkafnXojyiMQ4l9xMK/kqWIb8=; b=MmcqB+nP3Pnt5Kp5TA7L224d6d9xqpRC0tDqdNEI1AzyJyOjsv6WsZyLTm/NC4yLCyBg3LX1
 kVADqBjctrL7YlAN87B/xDMqNe1J7QZpldDbJv0hp8sGbSEHuR69+U6iR0nQJTURIp1/BOLe
 mzF52gzHS/5u5ks8WP9L2RmVdlw=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f8585b9ad37af35ec09ef60 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 13 Oct 2020 10:47:21
 GMT
Sender: prathampratap=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C946FC433CB; Tue, 13 Oct 2020 10:47:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from ppratap-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: prathampratap)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 56A3AC433C9;
        Tue, 13 Oct 2020 10:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 56A3AC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=prathampratap@codeaurora.org
From:   Pratham Pratap <prathampratap@codeaurora.org>
To:     gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        rafael.j.wysocki@intel.com, mathias.nyman@linux.intel.com,
        andriy.shevchenko@linux.intel.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sallenki@codeaurora.org, mgautam@codeaurora.org,
        jackp@codeaurora.org,
        Pratham Pratap <prathampratap@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH] usb: core: Don't wait for completion of urbs
Date:   Tue, 13 Oct 2020 16:17:02 +0530
Message-Id: <1602586022-13239-1-git-send-email-prathampratap@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Consider a case where host is trying to submit urbs to the
connected device while holding the us->dev_mutex and due to
some reason it is stuck while waiting for the completion of
the urbs. Now the scsi error mechanism kicks in and it calls
the device reset handler which is trying to acquire the same
mutex causing a deadlock situation.

Below is the call stack of the task which acquired the mutex
(0xFFFFFFC660447460) and waiting for completion.

B::v.f_/task_0xFFFFFFC6604DB280
-000|__switch_to(prev = 0xFFFFFFC6604DB280, ?)
-001|prepare_lock_switch(inline)
-001|context_switch(inline)
-001|__schedule(?)
-002|schedule()
-003|schedule_timeout(timeout = 9223372036854775807)
-004|do_wait_for_common(x = 0xFFFFFFC660447570,
action = 0xFFFFFF98ED5A7398, timeout = 9223372036854775807, ?)
-005|spin_unlock_irq(inline)
-005|__wait_for_common(inline)
-005|wait_for_common(inline)
-005|wait_for_completion(x = 0xFFFFFFC660447570)
-006|sg_clean(inline)
-006|usb_sg_wait()
-007|atomic64_andnot(inline)
-007|atomic_long_andnot(inline)
-007|clear_bit(inline)
-007|usb_stor_bulk_transfer_sglist(us = 0xFFFFFFC660447460,
pipe = 3221291648, sg = 0xFFFFFFC65D6415D0, ?, length = 512,
act_len = 0xFFFFFF801258BC90)
-008|scsi_bufflen(inline)
-008|usb_stor_bulk_srb(inline)
-008|usb_stor_Bulk_transport(srb = 0xFFFFFFC65D641438,
us = 0xFFFFFFC660447460)
-009|test_bit(inline)
-009|usb_stor_invoke_transport(srb = 0xFFFFFFC65D641438,
us = 0xFFFFFFC660447460)
-010|usb_stor_transparent_scsi_command(?, ?)
-011|usb_stor_control_thread(__us = 0xFFFFFFC660447460)  //us->dev_mutex
-012|kthread(_create = 0xFFFFFFC6604C5E80)
-013|ret_from_fork(asm)
 ---|end of frame

Below is the call stack of the task which trying to acquire the same
mutex(0xFFFFFFC660447460) in the error handling path.

B::v.f_/task_0xFFFFFFC6609AA1C0
-000|__switch_to(prev = 0xFFFFFFC6609AA1C0, ?)
-001|prepare_lock_switch(inline)
-001|context_switch(inline)
-001|__schedule(?)
-002|schedule()
-003|schedule_preempt_disabled()
-004|__mutex_lock_common(lock = 0xFFFFFFC660447460, state = 2, ?, ?, ?,
?, ?)
-005|__mutex_lock_slowpath(?)
-006|__cmpxchg_acq(inline)
-006|__mutex_trylock_fast(inline)
-006|mutex_lock(lock = 0xFFFFFFC660447460)   //us->dev_mutex
-007|device_reset(?)
-008|scsi_try_bus_device_reset(inline)
-008|scsi_eh_bus_device_reset(inline)
-008|scsi_eh_ready_devs(shost = 0xFFFFFFC660446C80,
work_q = 0xFFFFFF80191C3DE8, done_q = 0xFFFFFF80191C3DD8)
-009|scsi_error_handler(data = 0xFFFFFFC660446C80)
-010|kthread(_create = 0xFFFFFFC66042C080)
-011|ret_from_fork(asm)
 ---|end of frame

Fix this by adding 5 seconds timeout while waiting for completion.

Fixes: 3e35bf39e (USB: fix codingstyle issues in drivers/usb/core/message.c)
Cc: stable@vger.kernel.org
Signed-off-by: Pratham Pratap <prathampratap@codeaurora.org>
---
 drivers/usb/core/message.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index ae1de9c..b1e839c 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -515,15 +515,13 @@ EXPORT_SYMBOL_GPL(usb_sg_init);
  */
 void usb_sg_wait(struct usb_sg_request *io)
 {
-	int i;
+	int i, retval;
 	int entries = io->entries;
 
 	/* queue the urbs.  */
 	spin_lock_irq(&io->lock);
 	i = 0;
 	while (i < entries && !io->status) {
-		int retval;
-
 		io->urbs[i]->dev = io->dev;
 		spin_unlock_irq(&io->lock);
 
@@ -569,7 +567,13 @@ void usb_sg_wait(struct usb_sg_request *io)
 	 * So could the submit loop above ... but it's easier to
 	 * solve neither problem than to solve both!
 	 */
-	wait_for_completion(&io->complete);
+	retval = wait_for_completion_timeout(&io->complete,
+						msecs_to_jiffies(5000));
+	if (retval == 0) {
+		dev_err(&io->dev->dev, "%s, timed out while waiting for io_complete\n",
+				__func__);
+		usb_sg_cancel(io);
+	}
 
 	sg_clean(io);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


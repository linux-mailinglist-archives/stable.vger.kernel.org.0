Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC4053EAF5
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbiFFOyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240086AbiFFOyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:54:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126A123E83C
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 802F1CE1BED
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 14:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6EBC385A9;
        Mon,  6 Jun 2022 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654527272;
        bh=r3aLsoLmNFKIZPyhgYxSvY7gIdCs7yYtawOnlwz4RbE=;
        h=Subject:To:Cc:From:Date:From;
        b=e4XlEprWTus+kqJ806qlOfZILX/pOMR0x+4D1wnqZB1vI5Fp2hb8PbTTfkYhvSU2C
         qFs7zjMtKujHWwVLR0DuQ/y2bBGC385muuz5C/T5rsHOqyA1wgv6E87BWa7fv+FXoz
         C15hGGt/jVBnxnzt2jM3PZ9/KtG3rKWwhNI4IPHo=
Subject: FAILED: patch "[PATCH] um: virtio_uml: Fix broken device handling in time-travel" failed to apply to 5.15-stable tree
To:     johannes.berg@intel.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 16:54:30 +0200
Message-ID: <165452727086220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From af9fb41ed315ce95f659f0b10b4d59a71975381d Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Tue, 17 May 2022 22:52:50 +0200
Subject: [PATCH] um: virtio_uml: Fix broken device handling in time-travel

If a device implementation crashes, virtio_uml will mark it
as dead by calling virtio_break_device() and scheduling the
work that will remove it.

This still seems like the right thing to do, but it's done
directly while reading the message, and if time-travel is
used, this is in the time-travel handler, outside of the
normal Linux machinery. Therefore, we cannot acquire locks
or do normal "linux-y" things because e.g. lockdep will be
confused about the context.

Move handling this situation out of the read function and
into the actual IRQ handler and response handling instead,
so that in the case of time-travel we don't call it in the
wrong context.

Chances are the system will still crash immediately, since
the device implementation crashing may also cause the time-
travel controller to go down, but at least all of that now
happens without strange warnings from lockdep.

Fixes: c8177aba37ca ("um: time-travel: rework interrupt handling in ext mode")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index ba562d68dc04..82ff3785bf69 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -63,6 +63,7 @@ struct virtio_uml_device {
 
 	u8 config_changed_irq:1;
 	uint64_t vq_irq_vq_map;
+	int recv_rc;
 };
 
 struct virtio_uml_vq_info {
@@ -148,14 +149,6 @@ static int vhost_user_recv(struct virtio_uml_device *vu_dev,
 
 	rc = vhost_user_recv_header(fd, msg);
 
-	if (rc == -ECONNRESET && vu_dev->registered) {
-		struct virtio_uml_platform_data *pdata;
-
-		pdata = vu_dev->pdata;
-
-		virtio_break_device(&vu_dev->vdev);
-		schedule_work(&pdata->conn_broken_wk);
-	}
 	if (rc)
 		return rc;
 	size = msg->header.size;
@@ -164,6 +157,21 @@ static int vhost_user_recv(struct virtio_uml_device *vu_dev,
 	return full_read(fd, &msg->payload, size, false);
 }
 
+static void vhost_user_check_reset(struct virtio_uml_device *vu_dev,
+				   int rc)
+{
+	struct virtio_uml_platform_data *pdata = vu_dev->pdata;
+
+	if (rc != -ECONNRESET)
+		return;
+
+	if (!vu_dev->registered)
+		return;
+
+	virtio_break_device(&vu_dev->vdev);
+	schedule_work(&pdata->conn_broken_wk);
+}
+
 static int vhost_user_recv_resp(struct virtio_uml_device *vu_dev,
 				struct vhost_user_msg *msg,
 				size_t max_payload_size)
@@ -171,8 +179,10 @@ static int vhost_user_recv_resp(struct virtio_uml_device *vu_dev,
 	int rc = vhost_user_recv(vu_dev, vu_dev->sock, msg,
 				 max_payload_size, true);
 
-	if (rc)
+	if (rc) {
+		vhost_user_check_reset(vu_dev, rc);
 		return rc;
+	}
 
 	if (msg->header.flags != (VHOST_USER_FLAG_REPLY | VHOST_USER_VERSION))
 		return -EPROTO;
@@ -369,6 +379,7 @@ static irqreturn_t vu_req_read_message(struct virtio_uml_device *vu_dev,
 				 sizeof(msg.msg.payload) +
 				 sizeof(msg.extra_payload));
 
+	vu_dev->recv_rc = rc;
 	if (rc)
 		return IRQ_NONE;
 
@@ -412,7 +423,9 @@ static irqreturn_t vu_req_interrupt(int irq, void *data)
 	if (!um_irq_timetravel_handler_used())
 		ret = vu_req_read_message(vu_dev, NULL);
 
-	if (vu_dev->vq_irq_vq_map) {
+	if (vu_dev->recv_rc) {
+		vhost_user_check_reset(vu_dev, vu_dev->recv_rc);
+	} else if (vu_dev->vq_irq_vq_map) {
 		struct virtqueue *vq;
 
 		virtio_device_for_each_vq((&vu_dev->vdev), vq) {


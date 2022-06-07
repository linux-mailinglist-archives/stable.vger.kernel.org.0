Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9595C541696
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377317AbiFGUxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378690AbiFGUwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:52:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90BF6146;
        Tue,  7 Jun 2022 11:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8245AB82182;
        Tue,  7 Jun 2022 18:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDA5C385A2;
        Tue,  7 Jun 2022 18:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627367;
        bh=5W7m88KiTZvHvoWjyOt0GpGQuUxzdpHJkRGENQfNYDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNm5uATOucfBJ9wWIqyvwlEihts0v15j13QYm/aF4eQb0kMFqoQstA+NvXFRLidpT
         qAGusUmZttG4xyJBrYSTBQUOH9/dCG5Cr7dMDQthtAw/62O5XON4KNfRtaCUKJapK6
         GLOLneMm5QYmV7XJOlwPrO5lfoy/i6KnMKVjYcYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.17 714/772] um: virtio_uml: Fix broken device handling in time-travel
Date:   Tue,  7 Jun 2022 19:05:06 +0200
Message-Id: <20220607165010.083869783@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Johannes Berg <johannes.berg@intel.com>

commit af9fb41ed315ce95f659f0b10b4d59a71975381d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/virtio_uml.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -63,6 +63,7 @@ struct virtio_uml_device {
 
 	u8 config_changed_irq:1;
 	uint64_t vq_irq_vq_map;
+	int recv_rc;
 };
 
 struct virtio_uml_vq_info {
@@ -148,14 +149,6 @@ static int vhost_user_recv(struct virtio
 
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
@@ -164,6 +157,21 @@ static int vhost_user_recv(struct virtio
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
@@ -171,8 +179,10 @@ static int vhost_user_recv_resp(struct v
 	int rc = vhost_user_recv(vu_dev, vu_dev->sock, msg,
 				 max_payload_size, true);
 
-	if (rc)
+	if (rc) {
+		vhost_user_check_reset(vu_dev, rc);
 		return rc;
+	}
 
 	if (msg->header.flags != (VHOST_USER_FLAG_REPLY | VHOST_USER_VERSION))
 		return -EPROTO;
@@ -369,6 +379,7 @@ static irqreturn_t vu_req_read_message(s
 				 sizeof(msg.msg.payload) +
 				 sizeof(msg.extra_payload));
 
+	vu_dev->recv_rc = rc;
 	if (rc)
 		return IRQ_NONE;
 
@@ -412,7 +423,9 @@ static irqreturn_t vu_req_interrupt(int
 	if (!um_irq_timetravel_handler_used())
 		ret = vu_req_read_message(vu_dev, NULL);
 
-	if (vu_dev->vq_irq_vq_map) {
+	if (vu_dev->recv_rc) {
+		vhost_user_check_reset(vu_dev, vu_dev->recv_rc);
+	} else if (vu_dev->vq_irq_vq_map) {
 		struct virtqueue *vq;
 
 		virtio_device_for_each_vq((&vu_dev->vdev), vq) {



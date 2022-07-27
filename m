Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955AA582F5C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241868AbiG0RYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241956AbiG0RXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:23:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39117AB3C;
        Wed, 27 Jul 2022 09:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6834FB8200C;
        Wed, 27 Jul 2022 16:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86F4C433D7;
        Wed, 27 Jul 2022 16:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940342;
        bh=FP2F7zyyKo6KwfdNeVpY3GPe5U5gotHLjQ3RQIvnQQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YlhmCiiGGdZWnRpMfueYGIXgmqc2sYATgKm9Ayo3oloGeDEKPUGzwb/nTu+vZDL0
         +y/WM898aJ1K7R94iHojM5EIpTAFDVXPjlb7zzgfB+95RFSoiNrMXzNJpHn4+jut3p
         AwwX457MzXpB2Vdv3+nB8f/ksXtMOGvf2swlcBIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/201] um: virtio_uml: Fix broken device handling in time-travel
Date:   Wed, 27 Jul 2022 18:11:17 +0200
Message-Id: <20220727161034.977809905@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit af9fb41ed315ce95f659f0b10b4d59a71975381d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

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
-- 
2.35.1




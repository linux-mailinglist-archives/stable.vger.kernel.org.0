Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3771A461EF5
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbhK2SmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:42:05 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55202 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379807AbhK2SkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:40:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20990CE13DB;
        Mon, 29 Nov 2021 18:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F25C53FC7;
        Mon, 29 Nov 2021 18:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211002;
        bh=Bu40b1IDMXtfWt1r6mOek9GvWLTecgxrHieWMVD9GYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6nOBZaiyBQyKpQ/e8PZRrDWkR3NlDHTq5szqbb0X3rbvDwez5XbxXr+A8g37mgbz
         XuOuHpQ/e5oOM/u7e6xJ1z6GLofVFiWEjieWTzq8pyMeZ2zPGx7QFWCKxNfBTcMTk3
         ea9QPxsixXfqph98YE2ORaJadfRnVwUpQz+zUYcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/179] firmware: arm_scmi: Fix null de-reference on error path
Date:   Mon, 29 Nov 2021 19:17:44 +0100
Message-Id: <20211129181721.253046132@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 95161165727650a707bc34ecfac286a418b6bb00 ]

During channel setup a failure in the call of scmi_vio_feed_vq_rx() leads
to an attempt to access a dev pointer by dereferencing vioch->cinfo at
a time when vioch->cinfo has still to be initialized.

Fix it by providing the device reference directly to scmi_vio_feed_vq_rx.

Link: https://lore.kernel.org/r/20211112180705.41601-1-cristian.marussi@arm.com
Fixes: 46abe13b5e3db ("firmware: arm_scmi: Add virtio transport")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/virtio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/virtio.c b/drivers/firmware/arm_scmi/virtio.c
index 11e8efb713751..87039c5c03fdb 100644
--- a/drivers/firmware/arm_scmi/virtio.c
+++ b/drivers/firmware/arm_scmi/virtio.c
@@ -82,7 +82,8 @@ static bool scmi_vio_have_vq_rx(struct virtio_device *vdev)
 }
 
 static int scmi_vio_feed_vq_rx(struct scmi_vio_channel *vioch,
-			       struct scmi_vio_msg *msg)
+			       struct scmi_vio_msg *msg,
+			       struct device *dev)
 {
 	struct scatterlist sg_in;
 	int rc;
@@ -94,8 +95,7 @@ static int scmi_vio_feed_vq_rx(struct scmi_vio_channel *vioch,
 
 	rc = virtqueue_add_inbuf(vioch->vqueue, &sg_in, 1, msg, GFP_ATOMIC);
 	if (rc)
-		dev_err_once(vioch->cinfo->dev,
-			     "failed to add to virtqueue (%d)\n", rc);
+		dev_err_once(dev, "failed to add to virtqueue (%d)\n", rc);
 	else
 		virtqueue_kick(vioch->vqueue);
 
@@ -108,7 +108,7 @@ static void scmi_finalize_message(struct scmi_vio_channel *vioch,
 				  struct scmi_vio_msg *msg)
 {
 	if (vioch->is_rx) {
-		scmi_vio_feed_vq_rx(vioch, msg);
+		scmi_vio_feed_vq_rx(vioch, msg, vioch->cinfo->dev);
 	} else {
 		/* Here IRQs are assumed to be already disabled by the caller */
 		spin_lock(&vioch->lock);
@@ -269,7 +269,7 @@ static int virtio_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 			list_add_tail(&msg->list, &vioch->free_list);
 			spin_unlock_irqrestore(&vioch->lock, flags);
 		} else {
-			scmi_vio_feed_vq_rx(vioch, msg);
+			scmi_vio_feed_vq_rx(vioch, msg, cinfo->dev);
 		}
 	}
 
-- 
2.33.0




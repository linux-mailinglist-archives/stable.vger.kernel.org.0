Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB19A126C1B
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfLSTBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:01:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbfLSSun (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:50:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E47120674;
        Thu, 19 Dec 2019 18:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781442;
        bh=xf96ZbC6yw4bCBoOHjGyBoY1EnpZYxBLsAWBZYbLfeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1f3CT6m/l9qLp2bt+rwMNhGmEjXKoqdsbs6qYbx8T/FovehPtmUNvSYd647U9OrVw
         e6SAxtfRu0YNLpwQ0IlpNEB9U2iiuvJ0C1l0XKM8hnC6ILmO9jIsBb1AJs9qPitOmi
         6uKQ3iUpYd4RmODp/8tv8yJODr08/L+VQnrdNwdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Lew <clew@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 4.14 24/36] rpmsg: glink: Dont send pending rx_done during remove
Date:   Thu, 19 Dec 2019 19:34:41 +0100
Message-Id: <20191219182914.780050416@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182848.708141124@linuxfoundation.org>
References: <20191219182848.708141124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit c3dadc19b7564c732598b30d637c6f275c3b77b6 upstream.

Attempting to transmit rx_done messages after the GLINK instance is
being torn down will cause use after free and memory leaks. So cancel
the intent_work and free up the pending intents.

With this there are no concurrent accessors of the channel left during
qcom_glink_native_remove() and there is therefor no need to hold the
spinlock during this operation - which would prohibit the use of
cancel_work_sync() in the release function. So remove this.

Fixes: 1d2ea36eead9 ("rpmsg: glink: Add rx done command")
Cc: stable@vger.kernel.org
Acked-by: Chris Lew <clew@codeaurora.org>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rpmsg/qcom_glink_native.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -243,11 +243,23 @@ static void qcom_glink_channel_release(s
 {
 	struct glink_channel *channel = container_of(ref, struct glink_channel,
 						     refcount);
+	struct glink_core_rx_intent *intent;
 	struct glink_core_rx_intent *tmp;
 	unsigned long flags;
 	int iid;
 
+	/* cancel pending rx_done work */
+	cancel_work_sync(&channel->intent_work);
+
 	spin_lock_irqsave(&channel->intent_lock, flags);
+	/* Free all non-reuse intents pending rx_done work */
+	list_for_each_entry_safe(intent, tmp, &channel->done_intents, node) {
+		if (!intent->reuse) {
+			kfree(intent->data);
+			kfree(intent);
+		}
+	}
+
 	idr_for_each_entry(&channel->liids, tmp, iid) {
 		kfree(tmp->data);
 		kfree(tmp);
@@ -1597,7 +1609,6 @@ void qcom_glink_native_remove(struct qco
 	struct glink_channel *channel;
 	int cid;
 	int ret;
-	unsigned long flags;
 
 	disable_irq(glink->irq);
 	cancel_work_sync(&glink->rx_work);
@@ -1606,7 +1617,6 @@ void qcom_glink_native_remove(struct qco
 	if (ret)
 		dev_warn(glink->dev, "Can't remove GLINK devices: %d\n", ret);
 
-	spin_lock_irqsave(&glink->idr_lock, flags);
 	/* Release any defunct local channels, waiting for close-ack */
 	idr_for_each_entry(&glink->lcids, channel, cid)
 		kref_put(&channel->refcount, qcom_glink_channel_release);
@@ -1617,7 +1627,6 @@ void qcom_glink_native_remove(struct qco
 
 	idr_destroy(&glink->lcids);
 	idr_destroy(&glink->rcids);
-	spin_unlock_irqrestore(&glink->idr_lock, flags);
 	mbox_free_channel(glink->mbox_chan);
 }
 EXPORT_SYMBOL_GPL(qcom_glink_native_remove);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932E423FE54
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 14:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgHIMyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 08:54:10 -0400
Received: from crapouillou.net ([89.234.176.41]:33422 "EHLO crapouillou.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgHIMyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Aug 2020 08:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1596977646; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=cnkmqD3TG3gz8m5XcYrWDZ+GrLOHBws185ObzDx76W4=;
        b=koKnTka2TQh1Pi5bezaIUxvSZNqIOH73m0JLB50SXT/kS7HRy7RE3eYCxF0kylxdMBaKtz
        r9SBDWb9XR5VPe1KBCjk0EHZ5Hw2sMjWvsHqhuynBpq810w3G5kunugipyx8SQ0lKVHCmG
        tn2xrwbelnBWR2TEEIiThPD3FT4ktgo=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Bin Liu <b-liu@ti.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>,
        Johan Hovold <johan@kernel.org>, od@zcrc.me,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH] usb: musb: Fix runtime PM race in musb_queue_resume_work
Date:   Sun,  9 Aug 2020 14:53:59 +0200
Message-Id: <20200809125359.31025-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

musb_queue_resume_work() would call the provided callback if the runtime
PM status was 'active'. Otherwise, it would enqueue the request if the
hardware was still suspended (musb->is_runtime_suspended is true).

This causes a race with the runtime PM handlers, as it is possible to be
in the case where the runtime PM status is not yet 'active', but the
hardware has been awaken (PM resume function has been called).

When hitting the race, the resume work was not enqueued, which probably
triggered other bugs further down the stack. For instance, a telnet
connection on Ingenic SoCs would result in a 50/50 chance of a
segmentation fault somewhere in the musb code.

Rework the code so that either we call the callback directly if
(musb->is_runtime_suspended == 0), or enqueue the query otherwise.

Fixes: ea2f35c01d5e ("usb: musb: Fix sleeping function called from invalid context for hdrc glue")
Cc: stable@vger.kernel.org # v4.9
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/usb/musb/musb_core.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 384a8039a7fd..462c10d7455a 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2241,32 +2241,35 @@ int musb_queue_resume_work(struct musb *musb,
 {
 	struct musb_pending_work *w;
 	unsigned long flags;
+	bool is_suspended;
 	int error;
 
 	if (WARN_ON(!callback))
 		return -EINVAL;
 
-	if (pm_runtime_active(musb->controller))
-		return callback(musb, data);
+	spin_lock_irqsave(&musb->list_lock, flags);
+	is_suspended = musb->is_runtime_suspended;
+
+	if (is_suspended) {
+		w = devm_kzalloc(musb->controller, sizeof(*w), GFP_ATOMIC);
+		if (!w) {
+			error = -ENOMEM;
+			goto out_unlock;
+		}
 
-	w = devm_kzalloc(musb->controller, sizeof(*w), GFP_ATOMIC);
-	if (!w)
-		return -ENOMEM;
+		w->callback = callback;
+		w->data = data;
 
-	w->callback = callback;
-	w->data = data;
-	spin_lock_irqsave(&musb->list_lock, flags);
-	if (musb->is_runtime_suspended) {
 		list_add_tail(&w->node, &musb->pending_list);
 		error = 0;
-	} else {
-		dev_err(musb->controller, "could not add resume work %p\n",
-			callback);
-		devm_kfree(musb->controller, w);
-		error = -EINPROGRESS;
 	}
+
+out_unlock:
 	spin_unlock_irqrestore(&musb->list_lock, flags);
 
+	if (!is_suspended)
+		error = callback(musb, data);
+
 	return error;
 }
 EXPORT_SYMBOL_GPL(musb_queue_resume_work);
-- 
2.28.0


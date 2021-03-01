Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551E4328EDA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241759AbhCATjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:39:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241952AbhCATaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:30:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D7ED6507A;
        Mon,  1 Mar 2021 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619626;
        bh=iXSB1mLvwZOSh6THQuyyM06xsZZI9qBHP8A2KsdmkO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJMaH9PR5VuKGNtCd174ahMawJh1c2ru+wiEHQCXduLbwwHm4yPfx0DD5yzpSKbe+
         G4CscJ7VwXZAho34U0mbzLtEM3F5VEX8vog83zig9uh+JUifvZxUuJxFRWeEyzpteQ
         cbJA1+T+X+4f3VajUtTS6kS1WJb1GVdkF4QckQFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 5.10 492/663] usb: musb: Fix runtime PM race in musb_queue_resume_work
Date:   Mon,  1 Mar 2021 17:12:20 +0100
Message-Id: <20210301161206.185122466@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 0eaa1a3714db34a59ce121de5733c3909c529463 upstream.

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
Cc: stable@vger.kernel.org # v4.9+
Tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20210123142502.16980-1-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_core.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2240,32 +2240,35 @@ int musb_queue_resume_work(struct musb *
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
 
-	w = devm_kzalloc(musb->controller, sizeof(*w), GFP_ATOMIC);
-	if (!w)
-		return -ENOMEM;
+	if (is_suspended) {
+		w = devm_kzalloc(musb->controller, sizeof(*w), GFP_ATOMIC);
+		if (!w) {
+			error = -ENOMEM;
+			goto out_unlock;
+		}
+
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



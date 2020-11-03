Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DBE2A3F20
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 09:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgKCIl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 03:41:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:51134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbgKCIly (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 03:41:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604392911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BoXo0vU/l+clTxUbs4bEpnnnJm2Z50z4yZ9YTr6f2A0=;
        b=R5l/ypWkArYxXVESKq2uQEDNNhEQJNORnR/iL1hZSuUzI34WlibspPvBW9XtyVI9r8jarL
        jRq4xpC+fzIrIjy9MQ/+xOa/oAbB3yeIu6pQvqoWvlUEwJ5x5M0Y4Zrm/D4541hSUJaKuD
        w2wY1hgtX0Y8Xl9LuicwS1RexgtqY0k=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 975DDB1EF
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:41:51 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 10/13] xen/events: switch user event channels to lateeoi model
Date:   Tue,  3 Nov 2020 09:41:47 +0100
Message-Id: <20201103084150.8625-11-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103084150.8625-1-jgross@suse.com>
References: <20201103084150.8625-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Instead of disabling the irq when an event is received and enabling
it again when handled by the user process use the lateeoi model.

This is part of XSA-332.

This is upstream commit c44b849cee8c3ac587da3b0980e01f77500d158c

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/xen/evtchn.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index e8c7f09d01be..bcf0b1e60f2c 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -178,7 +178,6 @@ static irqreturn_t evtchn_interrupt(int irq, void *data)
 	     "Interrupt for port %d, but apparently not enabled; per-user %p\n",
 	     evtchn->port, u);
 
-	disable_irq_nosync(irq);
 	evtchn->enabled = false;
 
 	spin_lock(&u->ring_prod_lock);
@@ -304,7 +303,7 @@ static ssize_t evtchn_write(struct file *file, const char __user *buf,
 		evtchn = find_evtchn(u, port);
 		if (evtchn && !evtchn->enabled) {
 			evtchn->enabled = true;
-			enable_irq(irq_from_evtchn(port));
+			xen_irq_lateeoi(irq_from_evtchn(port), 0);
 		}
 	}
 
@@ -404,8 +403,8 @@ static int evtchn_bind_to_user(struct per_user_data *u, int port)
 	if (rc < 0)
 		goto err;
 
-	rc = bind_evtchn_to_irqhandler(port, evtchn_interrupt, 0,
-				       u->name, evtchn);
+	rc = bind_evtchn_to_irqhandler_lateeoi(port, evtchn_interrupt, 0,
+					       u->name, evtchn);
 	if (rc < 0)
 		goto err;
 
-- 
2.26.2


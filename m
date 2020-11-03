Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AFA2A47B8
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbgKCOPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:15:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:56162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbgKCONZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 09:13:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604412802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQwD02msWehTUmlK1Z3hAscrw7KTtog7EyDMF5TWX7o=;
        b=p65bXMhEFF02NbuWYCiQHe22SkllyV05KurinBe3J78NS9AirPur1D6+ykU9e0uzKA09OQ
        2JCKppj0O0Hhujld/xvbJsSG4ct+J1UwdpFAl2tkwrff2H601DWU7iUGEIJfv9WK9OWnp5
        84s/Jvmk47LZ1d8AXUa3WjQcu4DlkRY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6F8B8B2A8
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 14:13:22 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 10/13] xen/events: switch user event channels to lateeoi model
Date:   Tue,  3 Nov 2020 15:13:18 +0100
Message-Id: <20201103141321.20346-11-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103141321.20346-1-jgross@suse.com>
References: <20201103141321.20346-1-jgross@suse.com>
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
index 052b55a14ebc..a43930191e20 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -166,7 +166,6 @@ static irqreturn_t evtchn_interrupt(int irq, void *data)
 	     "Interrupt for port %d, but apparently not enabled; per-user %p\n",
 	     evtchn->port, u);
 
-	disable_irq_nosync(irq);
 	evtchn->enabled = false;
 
 	spin_lock(&u->ring_prod_lock);
@@ -292,7 +291,7 @@ static ssize_t evtchn_write(struct file *file, const char __user *buf,
 		evtchn = find_evtchn(u, port);
 		if (evtchn && !evtchn->enabled) {
 			evtchn->enabled = true;
-			enable_irq(irq_from_evtchn(port));
+			xen_irq_lateeoi(irq_from_evtchn(port), 0);
 		}
 	}
 
@@ -392,8 +391,8 @@ static int evtchn_bind_to_user(struct per_user_data *u, int port)
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


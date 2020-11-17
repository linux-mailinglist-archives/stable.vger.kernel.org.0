Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6852B66AD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgKQOGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 09:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbgKQNI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:08:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90D8E221EB;
        Tue, 17 Nov 2020 13:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618508;
        bh=WsR2k/rF0cm3YmDATP6Q/YMvfTfqpOq85JxJy+u30oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTntM17WqdkMXBjFI/Nulm1YilrerekfAfCCxz1eUjSuQu/wvBsjqFinwtHyG6e4G
         JlgpDSBtOOCl6iK+1oF8R4aWomzpC5dj+wAAluZ2lyC67nVV0UphR4nenmcrQyJ4r1
         NcqFRYwU9+U00QssWXlBnH5TaBqX5TmkNkl1196k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julien Grall <julien@xen.org>, Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Jan Beulich <jbeulich@suse.com>, Wei Liu <wl@xen.org>
Subject: [PATCH 4.4 56/64] xen/events: switch user event channels to lateeoi model
Date:   Tue, 17 Nov 2020 14:05:19 +0100
Message-Id: <20201117122108.942172526@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit c44b849cee8c3ac587da3b0980e01f77500d158c upstream.

Instead of disabling the irq when an event is received and enabling
it again when handled by the user process use the lateeoi model.

This is part of XSA-332.

Cc: stable@vger.kernel.org
Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/evtchn.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -173,7 +173,6 @@ static irqreturn_t evtchn_interrupt(int
 	     "Interrupt for port %d, but apparently not enabled; per-user %p\n",
 	     evtchn->port, u);
 
-	disable_irq_nosync(irq);
 	evtchn->enabled = false;
 
 	spin_lock(&u->ring_prod_lock);
@@ -299,7 +298,7 @@ static ssize_t evtchn_write(struct file
 		evtchn = find_evtchn(u, port);
 		if (evtchn && !evtchn->enabled) {
 			evtchn->enabled = true;
-			enable_irq(irq_from_evtchn(port));
+			xen_irq_lateeoi(irq_from_evtchn(port), 0);
 		}
 	}
 
@@ -399,8 +398,8 @@ static int evtchn_bind_to_user(struct pe
 	if (rc < 0)
 		goto err;
 
-	rc = bind_evtchn_to_irqhandler(port, evtchn_interrupt, 0,
-				       u->name, evtchn);
+	rc = bind_evtchn_to_irqhandler_lateeoi(port, evtchn_interrupt, 0,
+					       u->name, evtchn);
 	if (rc < 0)
 		goto err;
 



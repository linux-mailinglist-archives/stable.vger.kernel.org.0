Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2242B66B2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgKQNIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbgKQNIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:08:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 330BA2225B;
        Tue, 17 Nov 2020 13:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618487;
        bh=cBaCki1wSPt+czcXSB+QD0oaExPggu2lSlynJL3wzKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMkPwYYLSZtIvHMNMNsj1Xo7NxYrRkH3cf8N8yUZSpp+6LlvcXQlr9gqX1om+yP44
         XDJePKLBoT0sgaKrZ2NwnMvIxd+6NJy9m7Sqv5aNtwfsmX0lBcu84utGD3lsP9UlVi
         Rcz9Otz7b7P30wd2r0BVEZgKyKsOB6ONqobOsunw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julien Grall <julien@xen.org>, Juergen Gross <jgross@suse.com>,
        Julien Grall <jgrall@amazon.com>, Wei Liu <wl@xen.org>
Subject: [PATCH 4.4 49/64] xen/events: add a proper barrier to 2-level uevent unmasking
Date:   Tue, 17 Nov 2020 14:05:12 +0100
Message-Id: <20201117122108.587012647@linuxfoundation.org>
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

commit 4d3fe31bd993ef504350989786858aefdb877daa upstream.

A follow-up patch will require certain write to happen before an event
channel is unmasked.

While the memory barrier is not strictly necessary for all the callers,
the main one will need it. In order to avoid an extra memory barrier
when using fifo event channels, mandate evtchn_unmask() to provide
write ordering.

The 2-level event handling unmask operation is missing an appropriate
barrier, so add it. Fifo event channels are fine in this regard due to
using sync_cmpxchg().

This is part of XSA-332.

Cc: stable@vger.kernel.org
Suggested-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_2l.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -90,6 +90,8 @@ static void evtchn_2l_unmask(unsigned po
 
 	BUG_ON(!irqs_disabled());
 
+	smp_wmb();	/* All writes before unmask must be visible. */
+
 	if (unlikely((cpu != cpu_from_evtchn(port))))
 		do_hypercall = 1;
 	else {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EE32A5622
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbgKCVCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732167AbgKCVCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:02:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 034C620757;
        Tue,  3 Nov 2020 21:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437351;
        bh=nOGdb9uR5h52LS2DyYbrmfF9dn0bqiJYyKU3d5omfJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftB9kqINNEFuSz6HzPoH4MB9OsOmUl2mOqKVirs5KBBNyukzYDFszwS3yuXroxw6w
         gee6WOP5pdIjctqHcVswvzXIVtRw2yeId+NRFD1gpGxk+SP/hPsSwqOqK3ptuGzTQB
         aPWeyEKrbsdwFL8rJgfzF0G1snTggPc0Ps6Ydb6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Julien Grall <jgrall@amazon.com>, Wei Liu <wl@xen.org>
Subject: [PATCH 4.19 038/191] xen/events: add a proper barrier to 2-level uevent unmasking
Date:   Tue,  3 Nov 2020 21:35:30 +0100
Message-Id: <20201103203237.653154050@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
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
@@ -91,6 +91,8 @@ static void evtchn_2l_unmask(unsigned po
 
 	BUG_ON(!irqs_disabled());
 
+	smp_wmb();	/* All writes before unmask must be visible. */
+
 	if (unlikely((cpu != cpu_from_evtchn(port))))
 		do_hypercall = 1;
 	else {



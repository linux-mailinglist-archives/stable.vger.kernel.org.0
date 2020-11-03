Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C568E2A59C9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbgKCWKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:10:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729799AbgKCUho (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:37:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37AB8223AB;
        Tue,  3 Nov 2020 20:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435862;
        bh=aJlYSdk1Jt8bY3ZioFvqUerhdlA1snR2dbKgWVoz78M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzEU/fBynSzYEnzCNRTdVoiQ1A5b45ek09baeBXE3hh9CtAzBuUKg0qzKbNAHjGWo
         ZFeaKc6pJ80Q/mG4Zt7CGddjhTKvXnT2UDPYmql16BceN4MEm3ektyJOa61Dh+0lrm
         +CrOLHvO1dWve/0Lph/ST+1h238k6ycmXZZlwiM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Juergen Gross <jgross@suse.com>,
        Julien Grall <jgrall@amazon.com>, Wei Liu <wl@xen.org>
Subject: [PATCH 5.9 002/391] xen/events: add a proper barrier to 2-level uevent unmasking
Date:   Tue,  3 Nov 2020 21:30:53 +0100
Message-Id: <20201103203348.310892907@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
@@ -91,6 +91,8 @@ static void evtchn_2l_unmask(evtchn_port
 
 	BUG_ON(!irqs_disabled());
 
+	smp_wmb();	/* All writes before unmask must be visible. */
+
 	if (unlikely((cpu != cpu_from_evtchn(port))))
 		do_hypercall = 1;
 	else {



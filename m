Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F12A2EB7
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 16:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKBP5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 10:57:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:39060 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgKBP5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 10:57:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604332626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D5JMDRpr4XQxvKEMDlxF9Pb3B5vWxz5wnOaFOseKtlY=;
        b=BfvkKUdC8Xs+jRGC6Ie6vqDhaN3nOPqFfYhDzMOqJvVKaJNx6u4aVJnccQFmE4xjcC9/w+
        nEmaTIURMTvR7HLd/o/O7uQ/v9fOxiLJpYK45DFCF2ODiBLdSYtp7Lsijw/vw3yCcjU2dy
        uHIaU4otMAZWjLeK4YpeIDfKSkdDxMw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 82F76AFFD
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 15:57:06 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 03/14] xen/events: add a proper barrier to 2-level uevent unmasking
Date:   Mon,  2 Nov 2020 16:56:54 +0100
Message-Id: <20201102155705.8578-4-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102155705.8578-1-jgross@suse.com>
References: <20201102155705.8578-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

This is upstream commit 4d3fe31bd993ef504350989786858aefdb877daa

Cc: stable@vger.kernel.org
Suggested-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Julien Grall <jgrall@amazon.com>
Reviewed-by: Wei Liu <wl@xen.org>
---
 drivers/xen/events/events_2l.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2l.c
index 8edef51c92e5..e4b75693600e 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -91,6 +91,8 @@ static void evtchn_2l_unmask(unsigned port)
 
 	BUG_ON(!irqs_disabled());
 
+	smp_wmb();	/* All writes before unmask must be visible. */
+
 	if (unlikely((cpu != cpu_from_evtchn(port))))
 		do_hypercall = 1;
 	else {
-- 
2.26.2


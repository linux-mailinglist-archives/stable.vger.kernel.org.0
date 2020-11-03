Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6622A47C1
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgKCOPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:15:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:56018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbgKCONW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 09:13:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604412801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D5JMDRpr4XQxvKEMDlxF9Pb3B5vWxz5wnOaFOseKtlY=;
        b=Vnd+NQtksUdmw6sSkNklQ+rDCEhOxx+HmFquW9chXor25wzsIZvsUT/q9TCGlR6S8ip2MZ
        KMS1eGAS9FMTl49AUnJ1brbl3OgNYZgN2CkqkdLAczM1w1M188DRdsn6qARSWy/5yqUWNU
        Rk2HkJmgzjGvzFfMuBmOuThiRRxwhOU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B297BB298
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 14:13:21 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 02/13] xen/events: add a proper barrier to 2-level uevent unmasking
Date:   Tue,  3 Nov 2020 15:13:10 +0100
Message-Id: <20201103141321.20346-3-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103141321.20346-1-jgross@suse.com>
References: <20201103141321.20346-1-jgross@suse.com>
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


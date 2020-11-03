Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DEA2A4B25
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgKCQWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:22:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:58714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbgKCQWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 11:22:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604420559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YLR7Z5sBM4GIOxaWdo6dXwxgV/jrwbj+6udUxYbLxtM=;
        b=OcN0kxXAue8xL+grpoxPRiO3uy9lNaE9tCw//rzirXNP5cRsEKbv+pmomwTjT6Ljz+Sib+
        YY7Xd8HqIsydzZUAS3nuOWH2FEGoIoj6FmSuzqeuLzXPKejXtzDaCx88BH5+HAtMDA4JF2
        tFmpsGZRmRtgokvSlwwrWUoMY9+pAf8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AB782AD20
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 16:22:39 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 04/13] xen/events: fix race in evtchn_fifo_unmask()
Date:   Tue,  3 Nov 2020 17:22:29 +0100
Message-Id: <20201103162238.30264-5-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103162238.30264-1-jgross@suse.com>
References: <20201103162238.30264-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Unmasking a fifo event channel can result in unmasking it twice, once
directly in the kernel and once via a hypercall in case the event was
pending.

Fix that by doing the local unmask only if the event is not pending.

This is part of XSA-332.

This is upstream commit f01337197419b7e8a492e83089552b77d3b5fb90

Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
---
 drivers/xen/events/events_fifo.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index 96a1b8da5371..ce909d830973 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -227,19 +227,25 @@ static bool evtchn_fifo_is_masked(unsigned port)
 	return sync_test_bit(EVTCHN_FIFO_BIT(MASKED, word), BM(word));
 }
 /*
- * Clear MASKED, spinning if BUSY is set.
+ * Clear MASKED if not PENDING, spinning if BUSY is set.
+ * Return true if mask was cleared.
  */
-static void clear_masked(volatile event_word_t *word)
+static bool clear_masked_cond(volatile event_word_t *word)
 {
 	event_word_t new, old, w;
 
 	w = *word;
 
 	do {
+		if (w & (1 << EVTCHN_FIFO_PENDING))
+			return false;
+
 		old = w & ~(1 << EVTCHN_FIFO_BUSY);
 		new = old & ~(1 << EVTCHN_FIFO_MASKED);
 		w = sync_cmpxchg(word, old, new);
 	} while (w != old);
+
+	return true;
 }
 
 static void evtchn_fifo_unmask(unsigned port)
@@ -248,8 +254,7 @@ static void evtchn_fifo_unmask(unsigned port)
 
 	BUG_ON(!irqs_disabled());
 
-	clear_masked(word);
-	if (evtchn_fifo_is_pending(port)) {
+	if (!clear_masked_cond(word)) {
 		struct evtchn_unmask unmask = { .port = port };
 		(void)HYPERVISOR_event_channel_op(EVTCHNOP_unmask, &unmask);
 	}
-- 
2.26.2


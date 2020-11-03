Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C126E2A52D9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgKCUxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731320AbgKCUxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:53:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1E01223AC;
        Tue,  3 Nov 2020 20:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436832;
        bh=wi0aNJS4t9cijB/GMdL2NsV7IO6FsukuHpXIFapDTYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8jZaGp7DHY0kj8+pA6DuJoo7NwdY4Rux5VM6pYOxkmsk1kwB+HRgwowHg50d/05y
         R0HPwn1eOg3S3a9Vis7kQuLDoZPuiYZjwODdunAy+WJWvnRFcccHvUpU3YA1QNy8tv
         0ouYSjW03ANeyMCRTkFCviHeoZL01USos9rPlKoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.4 003/214] xen/events: fix race in evtchn_fifo_unmask()
Date:   Tue,  3 Nov 2020 21:34:11 +0100
Message-Id: <20201103203249.832354885@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit f01337197419b7e8a492e83089552b77d3b5fb90 upstream.

Unmasking a fifo event channel can result in unmasking it twice, once
directly in the kernel and once via a hypercall in case the event was
pending.

Fix that by doing the local unmask only if the event is not pending.

This is part of XSA-332.

Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events/events_fifo.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -227,19 +227,25 @@ static bool evtchn_fifo_is_masked(unsign
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
@@ -248,8 +254,7 @@ static void evtchn_fifo_unmask(unsigned
 
 	BUG_ON(!irqs_disabled());
 
-	clear_masked(word);
-	if (evtchn_fifo_is_pending(port)) {
+	if (!clear_masked_cond(word)) {
 		struct evtchn_unmask unmask = { .port = port };
 		(void)HYPERVISOR_event_channel_op(EVTCHNOP_unmask, &unmask);
 	}



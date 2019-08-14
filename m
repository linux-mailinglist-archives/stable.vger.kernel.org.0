Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508868DA56
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbfHNRNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:13:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730888AbfHNRNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:13:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BA0F2084D;
        Wed, 14 Aug 2019 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802813;
        bh=kR9+YXvfV2CdPfmskRIsMT9PpxhGNnm4bOzX5JEVLOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4vTL27UvV2wMe8O+21m41zwDNqHesGqsV5BPS+/+zWPlkzQBWfJFLe4dN/fts8jo
         xhjiFPjDnEVYa0/UNvtwJOA9X0bGUsuXeRuEQeUO+uRzP6IRy6Cq2y6tLgxsXZ0dkh
         ervS2fcCO010ChryC4fKK0LztJ80MpruVaFn/JF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/69] s390/qdio: add sanity checks to the fast-requeue path
Date:   Wed, 14 Aug 2019 19:01:33 +0200
Message-Id: <20190814165747.868696497@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a6ec414a4dd529eeac5c3ea51c661daba3397108 ]

If the device driver were to send out a full queue's worth of SBALs,
current code would end up discovering the last of those SBALs as PRIMED
and erroneously skip the SIGA-w. This immediately stalls the queue.

Add a check to not attempt fast-requeue in this case. While at it also
make sure that the state of the previous SBAL was successfully extracted
before inspecting it.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/qdio_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index ab8dd81fbc2b1..1a40c73961b83 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1577,13 +1577,13 @@ static int handle_outbound(struct qdio_q *q, unsigned int callflags,
 		rc = qdio_kick_outbound_q(q, phys_aob);
 	} else if (need_siga_sync(q)) {
 		rc = qdio_siga_sync_q(q);
+	} else if (count < QDIO_MAX_BUFFERS_PER_Q &&
+		   get_buf_state(q, prev_buf(bufnr), &state, 0) > 0 &&
+		   state == SLSB_CU_OUTPUT_PRIMED) {
+		/* The previous buffer is not processed yet, tack on. */
+		qperf_inc(q, fast_requeue);
 	} else {
-		/* try to fast requeue buffers */
-		get_buf_state(q, prev_buf(bufnr), &state, 0);
-		if (state != SLSB_CU_OUTPUT_PRIMED)
-			rc = qdio_kick_outbound_q(q, 0);
-		else
-			qperf_inc(q, fast_requeue);
+		rc = qdio_kick_outbound_q(q, 0);
 	}
 
 	/* in case of SIGA errors we must process the error immediately */
-- 
2.20.1




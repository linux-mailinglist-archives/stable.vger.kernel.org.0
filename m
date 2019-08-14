Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D41C8D944
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbfHNRG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729770AbfHNRG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:06:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2761C21721;
        Wed, 14 Aug 2019 17:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802416;
        bh=xByPWCFcCsM1NvHP+UNJgVtTBd1E+xvXYSMwLm9pjNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2aGO25QnSXZhq/4yJAfiXto4Wy4/wbSRD7OaYZLNDKgBLwPlrTIbMAzsSkhSb4Zw
         ggSuOPEVapmJerX1Vmheh6sQsjD/mFWBsjv7la7L4DlM4guRkHW2LUMWes/WBM4VS7
         SQV2TEmYVH2HldV4l6n0abycYMhNCDrFyCVUidgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 091/144] s390/qdio: add sanity checks to the fast-requeue path
Date:   Wed, 14 Aug 2019 19:00:47 +0200
Message-Id: <20190814165803.680977622@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
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
index 730c4e68094ba..7f5adf02f0959 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1558,13 +1558,13 @@ static int handle_outbound(struct qdio_q *q, unsigned int callflags,
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




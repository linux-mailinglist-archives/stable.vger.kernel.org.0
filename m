Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466E42C9DA3
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390665AbgLAJZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:25:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbgLAJF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:05:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22FFA20770;
        Tue,  1 Dec 2020 09:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813511;
        bh=MyQmDPqBreLR167qGJ8NsFFcikXHztR9oC5vXmD61nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuFHlCDBS0/BVLGklsW6UHc0aY4ihgqac4PFOxTtx4uTNbI6Z1yhKNT1V+JHHple4
         24NAQDGIf5idLb00HH8ovftpqNBDgENuPof444VsBKHWHHLBEgTH7X/1rWp+2bHu17
         m2TghofPnUNPZhcjk2AzF1qalaRoA5tgFNRxxz44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 57/98] s390/qeth: fix tear down of async TX buffers
Date:   Tue,  1 Dec 2020 09:53:34 +0100
Message-Id: <20201201084657.884994184@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 7ed10e16e50daf74460f54bc922e27c6863c8d61 ]

When qeth_iqd_tx_complete() detects that a TX buffer requires additional
async completion via QAOB, it might fail to replace the queue entry's
metadata (and ends up triggering recovery).

Assume now that the device gets torn down, overruling the recovery.
If the QAOB notification then arrives before the tear down has
sufficiently progressed, the buffer state is changed to
QETH_QDIO_BUF_HANDLED_DELAYED by qeth_qdio_handle_aob().

The tear down code calls qeth_drain_output_queue(), where
qeth_cleanup_handled_pending() will then attempt to replace such a
buffer _again_. If it succeeds this time, the buffer ends up dangling in
its replacement's ->next_pending list ... where it will never be freed,
since there's no further call to qeth_cleanup_handled_pending().

But the second attempt isn't actually needed, we can simply leave the
buffer on the queue and re-use it after a potential recovery has
completed. The qeth_clear_output_buffer() in qeth_drain_output_queue()
will ensure that it's in a clean state again.

Fixes: 72861ae792c2 ("qeth: recovery through asynchronous delivery")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f07e73eb37ebb..fad1c46d4b0e1 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -426,12 +426,6 @@ static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
 
 		}
 	}
-	if (forced_cleanup && (atomic_read(&(q->bufs[bidx]->state)) ==
-					QETH_QDIO_BUF_HANDLED_DELAYED)) {
-		/* for recovery situations */
-		qeth_init_qdio_out_buf(q, bidx);
-		QETH_CARD_TEXT(q->card, 2, "clprecov");
-	}
 }
 
 
-- 
2.27.0




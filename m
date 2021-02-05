Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11BB311467
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhBEWFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232951AbhBEO5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA68B65056;
        Fri,  5 Feb 2021 14:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534344;
        bh=0TCr50uaJ/Er9v0M1Rd47FXEfjx301MaEuqIpGUAO5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHPoqjt/wHtQ1qF3dhmXsoARC2ZKpmWwVH4dnhhNAgxgBGWuP1aMD0fsEhZO77dcs
         O0Llk9iEnC+R0BMdfC004HAjreUA+1Q9tzJqP6ZNKKMsimFtzpvKZdqYuX2sbG+QRR
         CL5TtzuIPqKDnxGC6FV9reXyv0Nyrm4a5V8yPPVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andres Freund <andres@anarazel.de>,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/32] Revert "Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT""
Date:   Fri,  5 Feb 2021 15:07:19 +0100
Message-Id: <20210205140652.538665933@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit bba91cdba612fbce4f8575c5d94d2b146fb83ea3 which is
commit b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e upstream.

It breaks things in 5.4.y, so let's drop it.

Reported-by: Andres Freund <andres@anarazel.de>
Cc: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
CC: Jens Axboe <axboe@kernel.dk>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -886,11 +886,14 @@ generic_make_request_checks(struct bio *
 	}
 
 	/*
-	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
-	 * if queue is not a request based queue.
+	 * Non-mq queues do not honor REQ_NOWAIT, so complete a bio
+	 * with BLK_STS_AGAIN status in order to catch -EAGAIN and
+	 * to give a chance to the caller to repeat request gracefully.
 	 */
-	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
-		goto not_supported;
+	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q)) {
+		status = BLK_STS_AGAIN;
+		goto end_io;
+	}
 
 	if (should_fail_bio(bio))
 		goto end_io;



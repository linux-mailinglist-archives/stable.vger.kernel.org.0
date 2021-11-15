Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAED84512C8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347403AbhKOTjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245042AbhKOTS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78BB4634F5;
        Mon, 15 Nov 2021 18:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000836;
        bh=J525mGhl1YD9mkcieMoRUPPCD1GjzimEAxPVQYBO2oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRPtYnbYWCI8tvgF5XRAnvpTHGcyWPVNQMSs5f6saRWHfGwEZiWkzVtU4m4qXJI5K
         cHZMu1NNo/QxolZXg9wiCNiY0O2cv7tPiSsNeoOnFpCq1+LDqflpBT9MKvIIOQ2hCD
         9nvXbGWxBReqhv4hLYmYlYgrMvTX9oOmRCzJR65k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 809/849] io-wq: ensure that hash wait lock is IRQ disabling
Date:   Mon, 15 Nov 2021 18:04:52 +0100
Message-Id: <20211115165447.611808255@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 08bdbd39b58474d762242e1fadb7f2eb9ffcca71 upstream.

A previous commit removed the IRQ safety of the worker and wqe locks,
but that left one spot of the hash wait lock now being done without
already having IRQs disabled.

Ensure that we use the right locking variant for the hashed waitqueue
lock.

Fixes: a9a4aa9fbfc5 ("io-wq: wqe and worker locks no longer need to be IRQ safe")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -405,7 +405,7 @@ static void io_wait_on_hash(struct io_wq
 {
 	struct io_wq *wq = wqe->wq;
 
-	spin_lock(&wq->hash->wait.lock);
+	spin_lock_irq(&wq->hash->wait.lock);
 	if (list_empty(&wqe->wait.entry)) {
 		__add_wait_queue(&wq->hash->wait, &wqe->wait);
 		if (!test_bit(hash, &wq->hash->map)) {
@@ -413,7 +413,7 @@ static void io_wait_on_hash(struct io_wq
 			list_del_init(&wqe->wait.entry);
 		}
 	}
-	spin_unlock(&wq->hash->wait.lock);
+	spin_unlock_irq(&wq->hash->wait.lock);
 }
 
 /*



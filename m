Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C5F3ED62F
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236883AbhHPNSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239294AbhHPNQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D31166115A;
        Mon, 16 Aug 2021 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119573;
        bh=8RfsVLE/13D9ne70jDeXISXvLMSX+mhrYS90ZcUzqfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8DH9OdzhpFqPG6vPeRTHJtSJu1BhTLW4krrRNDb+7KJWi7yW1HyKE3jvwS+5tLNH
         k/voW2eIrBaAJACt9PMpsBCcXJgxmt0llRxRsGqNL0sDfwMDHzSLAZNHoDAVIng+WC
         PRjd20u6XdEO9gPGWEGWYpvyVRtj8T6SBCLB0qkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 078/151] io-wq: fix bug of creating io-wokers unconditionally
Date:   Mon, 16 Aug 2021 15:01:48 +0200
Message-Id: <20210816125446.649235369@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

[ Upstream commit 49e7f0c789add1330b111af0b7caeb0e87df063e ]

The former patch to add check between nr_workers and max_workers has a
bug, which will cause unconditionally creating io-workers. That's
because the result of the check doesn't affect the call of
create_io_worker(), fix it by bringing in a boolean value for it.

Fixes: 21698274da5b ("io-wq: fix lack of acct->nr_workers < acct->max_workers judgement")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210808135434.68667-2-haoxu@linux.alibaba.com
[axboe: drop hunk that isn't strictly needed]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 77026d42cb79..2c8a9a394884 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -283,16 +283,24 @@ static void create_worker_cb(struct callback_head *cb)
 	struct io_wq *wq;
 	struct io_wqe *wqe;
 	struct io_wqe_acct *acct;
+	bool do_create = false;
 
 	cwd = container_of(cb, struct create_worker_data, work);
 	wqe = cwd->wqe;
 	wq = wqe->wq;
 	acct = &wqe->acct[cwd->index];
 	raw_spin_lock_irq(&wqe->lock);
-	if (acct->nr_workers < acct->max_workers)
+	if (acct->nr_workers < acct->max_workers) {
 		acct->nr_workers++;
+		do_create = true;
+	}
 	raw_spin_unlock_irq(&wqe->lock);
-	create_io_worker(wq, cwd->wqe, cwd->index);
+	if (do_create) {
+		create_io_worker(wq, cwd->wqe, cwd->index);
+	} else {
+		atomic_dec(&acct->nr_running);
+		io_worker_ref_put(wq);
+	}
 	kfree(cwd);
 }
 
-- 
2.30.2




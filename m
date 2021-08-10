Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C033E813A
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbhHJR4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237569AbhHJRyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82CDE60EB7;
        Tue, 10 Aug 2021 17:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617467;
        bh=Lw+74Gj3kID0KRiShxi8a0HyLBFVscSu8HmSEZ4Z5DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5VquYFPpBSHTa1u/xAmCd+8O1BUCLSP+JgKyG+rGoWxiHzcBAHNsaMz474RFK+aL
         OokZvy0+DFDGFDwX60pIBYaeucGDmPhk9JAIczUZxdOqVSiYKB8XA0qGls6CFbZjCd
         D3Ezo5+syAUrruC4v5dnCquVlYEtl/DqmwSA2UaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 072/175] io-wq: fix lack of acct->nr_workers < acct->max_workers judgement
Date:   Tue, 10 Aug 2021 19:29:40 +0200
Message-Id: <20210810173003.309630971@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

[ Upstream commit 21698274da5b6fc724b005bc7ec3e6b9fbcfaa06 ]

There should be this judgement before we create an io-worker

Fixes: 685fe7feedb9 ("io-wq: eliminate the need for a manager thread")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e00ac0969470..400fba839734 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -281,9 +281,17 @@ static void create_worker_cb(struct callback_head *cb)
 {
 	struct create_worker_data *cwd;
 	struct io_wq *wq;
+	struct io_wqe *wqe;
+	struct io_wqe_acct *acct;
 
 	cwd = container_of(cb, struct create_worker_data, work);
-	wq = cwd->wqe->wq;
+	wqe = cwd->wqe;
+	wq = wqe->wq;
+	acct = &wqe->acct[cwd->index];
+	raw_spin_lock_irq(&wqe->lock);
+	if (acct->nr_workers < acct->max_workers)
+		acct->nr_workers++;
+	raw_spin_unlock_irq(&wqe->lock);
 	create_io_worker(wq, cwd->wqe, cwd->index);
 	kfree(cwd);
 }
-- 
2.30.2




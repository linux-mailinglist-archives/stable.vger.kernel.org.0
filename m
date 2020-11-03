Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E1F2A5886
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731102AbgKCUp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:45:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731090AbgKCUpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:45:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC303223EA;
        Tue,  3 Nov 2020 20:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436355;
        bh=UxO+sYER6SO6bqmjI5fTh/TIDIq4JIRTDMfYA7xSGtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1Txfjlgimcr4ej3ewjOQZH52zGANnr7OjL7bwx6c4E//+70eIA7DZfPjrprdE48a
         +bj4lUwyQGDjxEJ4f1wCb5KWSX6KoFJSPkc1AWAC4VriTqtSNpXq9zR1gYcj02cN++
         2jCzGaWEVZicm6WxclpFU7gmwrFkmqFfrJUeBHCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 213/391] io-wq: assign NUMA node locality if appropriate
Date:   Tue,  3 Nov 2020 21:34:24 +0100
Message-Id: <20201103203401.305923534@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit a8b595b22d31f83b715511f59012f152a269d83b upstream.

There was an assumption that kthread_create_on_node() would properly set
NUMA affinities in terms of CPUs allowed, but it doesn't. Make sure we
do this when creating an io-wq context on NUMA.

Cc: stable@vger.kernel.org
Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io-wq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -654,6 +654,7 @@ static bool create_io_worker(struct io_w
 		kfree(worker);
 		return false;
 	}
+	kthread_bind_mask(worker->task, cpumask_of_node(wqe->node));
 
 	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CFA1FB73E
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbgFPPoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731968AbgFPPoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:44:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2230214DB;
        Tue, 16 Jun 2020 15:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322259;
        bh=AK6OqC3xja+xnPhxSEPb+ZQP/swy05uCs5cvUpjqHzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZj01Tsb3/ILKpiKzxJ4dzWVgIIa1p8ORa+bV892qrvwNpAq7ZOBjaYh84auFwhK6
         DKxd0mHtBMuhkNe8LLins1ZZ+oarXCbs6XgJsN0oylKxF6j7l8v9GWrlAXC3gK9r1t
         vUadX8Jaj0WC+ZEOCi3mpl4xJtw2SwUDghu6OTJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 055/163] io_uring: use kvfree() in io_sqe_buffer_register()
Date:   Tue, 16 Jun 2020 17:33:49 +0200
Message-Id: <20200616153109.480954030@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit a8c73c1a614f6da6c0b04c393f87447e28cb6de4 upstream.

Use kvfree() to free the pages and vmas, since they are allocated by
kvmalloc_array() in a loop.

Fixes: d4ef647510b1 ("io_uring: avoid page allocation warnings")
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200605093203.40087-1-efremov@linux.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7093,8 +7093,8 @@ static int io_sqe_buffer_register(struct
 
 		ret = 0;
 		if (!pages || nr_pages > got_pages) {
-			kfree(vmas);
-			kfree(pages);
+			kvfree(vmas);
+			kvfree(pages);
 			pages = kvmalloc_array(nr_pages, sizeof(struct page *),
 						GFP_KERNEL);
 			vmas = kvmalloc_array(nr_pages,



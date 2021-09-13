Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DAE40885D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 11:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbhIMJiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 05:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238684AbhIMJiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 05:38:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35E8A60E94;
        Mon, 13 Sep 2021 09:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631525818;
        bh=voUR2un5IvbjOqMnxFYckMQrMBgj2ZUGIIsa6mbeqWg=;
        h=Subject:To:Cc:From:Date:From;
        b=pC/pvUExjIhZTAe8I1Ni9LWHqPMXjFdeyTi0/8UkrxAu5P5BvnPEb44R12MKO7Bc+
         /L9fHuAm0Iep5OaTy3bZXbLPD1VLDFavu0wIn7YtFJOWtHBuAQGlhwULaX+6gKi5M0
         vqVSWUFfhI2LMDunJ+OebmWugL17efKEAKcAOLbc=
Subject: FAILED: patch "[PATCH] io_uring: place fixed tables under memcg limits" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 11:36:45 +0200
Message-ID: <163152580533237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0bea96f59ba40e63c0ae93ad6a02417b95f22f4d Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 20 Aug 2021 10:36:36 +0100
Subject: [PATCH] io_uring: place fixed tables under memcg limits

Fixed tables may be large enough, place all of them together with
allocated tags under memcg limits.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b3ac9f5da9821bb59837b5fe25e8ef4be982218c.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9a021fe6c461..c6f1afa5ec04 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7138,14 +7138,14 @@ static void **io_alloc_page_table(size_t size)
 	size_t init_size = size;
 	void **table;
 
-	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL);
+	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL_ACCOUNT);
 	if (!table)
 		return NULL;
 
 	for (i = 0; i < nr_tables; i++) {
 		unsigned int this_size = min_t(size_t, size, PAGE_SIZE);
 
-		table[i] = kzalloc(this_size, GFP_KERNEL);
+		table[i] = kzalloc(this_size, GFP_KERNEL_ACCOUNT);
 		if (!table[i]) {
 			io_free_page_table(table, init_size);
 			return NULL;
@@ -7336,7 +7336,8 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
 
 static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 {
-	table->files = kvcalloc(nr_files, sizeof(table->files[0]), GFP_KERNEL);
+	table->files = kvcalloc(nr_files, sizeof(table->files[0]),
+				GFP_KERNEL_ACCOUNT);
 	return !!table->files;
 }
 


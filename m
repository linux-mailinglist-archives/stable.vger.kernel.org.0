Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F61D2A1696
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgJaLp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbgJaLp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:45:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5122520731;
        Sat, 31 Oct 2020 11:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144756;
        bh=yBSRb5Pm6ij4DhhXk5+q8ZjX0tNxxnvypfUKoPIA8bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwPIlW8fIf7fiMX57c1ITp6D/lrHxvbpuyAv6zsHZmsl76rwdfIgYe/1p7kVrwIWt
         jm0f/SS0hEw+1rVLkoHsHAIl7KhO05fzC6NUXvIiC41B/MT5x5IY3J13IYiTEJF0g+
         74cjSnPIyCKR8NbDwoX+LLOBf/hYumfOqOC+X+BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 70/74] mm: mark async iocb read as NOWAIT once some data has been copied
Date:   Sat, 31 Oct 2020 12:36:52 +0100
Message-Id: <20201031113503.388678549@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 13bd691421bc191a402d2e0d3da5f248d170a632 upstream.

Once we've copied some data for an iocb that is marked with IOCB_WAITQ,
we should no longer attempt to async lock a new page. Instead make sure
we return the copied amount, and let the caller retry, instead of
returning -EIOCBQUEUED for a new page.

This should only be possible with read-ahead disabled on the below
device, and multiple threads racing on the same file. Haven't been able
to reproduce on anything else.

Cc: stable@vger.kernel.org # v5.9
Fixes: 1a0a7853b901 ("mm: support async buffered reads in generic_file_buffered_read()")
Reported-by: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/filemap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2179,6 +2179,14 @@ ssize_t generic_file_buffered_read(struc
 	last_index = (*ppos + iter->count + PAGE_SIZE-1) >> PAGE_SHIFT;
 	offset = *ppos & ~PAGE_MASK;
 
+	/*
+	 * If we've already successfully copied some data, then we
+	 * can no longer safely return -EIOCBQUEUED. Hence mark
+	 * an async read NOWAIT at that point.
+	 */
+	if (written && (iocb->ki_flags & IOCB_WAITQ))
+		iocb->ki_flags |= IOCB_NOWAIT;
+
 	for (;;) {
 		struct page *page;
 		pgoff_t end_index;



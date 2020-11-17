Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640982B63CA
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbgKQNln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733110AbgKQNld (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CC6520870;
        Tue, 17 Nov 2020 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620492;
        bh=/qWTPB8GIBCQpHAdIycFerM7p/FpssU7stVQG1tQk80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zuyRcJ9fYw4+hOD9sVi/3NhldheeJmlJWNjGnU4kkj0qjz5tqP2QNs1leLW1xeLMA
         3jI4PXmhxp37vKGaUDqG7Hh7Kb1ADLRkJH4n88H3hwkJO9zjxXFVe5P/qMZ5N1b61p
         UA6JY6A8mdB9spqhx2gx1aUJV73x9dWNxszEyjIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Melnic <dmm@fb.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 220/255] io_uring: round-up cq size before comparing with rounded sq size
Date:   Tue, 17 Nov 2020 14:06:00 +0100
Message-Id: <20201117122149.643245152@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 88ec3211e46344a7d10cf6cb5045f839f7785f8e upstream.

If an application specifies IORING_SETUP_CQSIZE to set the CQ ring size
to a specific size, we ensure that the CQ size is at least that of the
SQ ring size. But in doing so, we compare the already rounded up to power
of two SQ size to the as-of yet unrounded CQ size. This means that if an
application passes in non power of two sizes, we can return -EINVAL when
the final value would've been fine. As an example, an application passing
in 100/100 for sq/cq size should end up with 128 for both. But since we
round the SQ size first, we compare the CQ size of 100 to 128, and return
-EINVAL as that is too small.

Cc: stable@vger.kernel.org
Fixes: 33a107f0a1b8 ("io_uring: allow application controlled CQ ring size")
Reported-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8878,6 +8878,7 @@ static int io_uring_create(unsigned entr
 		 * to a power-of-two, if it isn't already. We do NOT impose
 		 * any cq vs sq ring sizing.
 		 */
+		p->cq_entries = roundup_pow_of_two(p->cq_entries);
 		if (p->cq_entries < p->sq_entries)
 			return -EINVAL;
 		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
@@ -8885,7 +8886,6 @@ static int io_uring_create(unsigned entr
 				return -EINVAL;
 			p->cq_entries = IORING_MAX_CQ_ENTRIES;
 		}
-		p->cq_entries = roundup_pow_of_two(p->cq_entries);
 	} else {
 		p->cq_entries = 2 * p->sq_entries;
 	}



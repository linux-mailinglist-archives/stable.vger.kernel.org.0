Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEA2EEDF2
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389059AbfKDWLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:11:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390713AbfKDWLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:11:40 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E106E214D8;
        Mon,  4 Nov 2019 22:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905500;
        bh=guiaCEQRulnqPPe4LKaYat2ZR/CL0oCOT0xWw2Mknns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5h0Y2pL3T6ta/CVvdsNVP6KE+hZgwjs6zyxJixxmV/3i9VUTXIbLevIzonEqCGj5
         FB6H+gDB5N/nHEMyT8Ul3X/mUyzZPcAKKXnuFnywbGkW1Bgsd42/ZTHHzFeYWb4On4
         XgBI+tNZXFK4rT1Q/t4GYi5BWjaMb2l2xwEfBwQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 143/163] io_uring: ensure we clear io_kiocb->result before each issue
Date:   Mon,  4 Nov 2019 22:45:33 +0100
Message-Id: <20191104212150.683214210@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 6873e0bd6a9cb14ecfadd89d9ed9698ff1761902 upstream.

We use io_kiocb->result == -EAGAIN as a way to know if we need to
re-submit a polled request, as -EAGAIN reporting happens out-of-line
for IO submission failures. This field is cleared when we originally
allocate the request, but it isn't reset when we retry the submission
from async context. This can cause issues where we think something
needs a re-issue, but we're really just reading stale data.

Reset ->result whenever we re-prep a request for polled submission.

Cc: stable@vger.kernel.org
Fixes: 9e645e1105ca ("io_uring: add support for sqe links")
Reported-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1078,6 +1078,7 @@ static int io_prep_rw(struct io_kiocb *r
 
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
+		req->result = 0;
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C922C9D4F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389265AbgLAJVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:21:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389261AbgLAJIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BCDD206C1;
        Tue,  1 Dec 2020 09:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813699;
        bh=P8mpLxYXQ1w9AvpHN/TsUPBGQJXIfuxUnusKsGvz1HU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSB+tZrVuKzmFuuolqH62fAcK3JeebNdJZVreSgY/22xfMJIf5tSfdbP6LYDWYHHG
         Vmtx81mVQekpJO9F+uEC/3Y3oaTfSKH32T0raPYm8BUJ4YYfWJ+CC1IyjNKPUlmst4
         M+Bf/yELjhjYXGeCAF1/Ec0HEDN1rAe45FV+OyNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 029/152] io_uring: fix ITER_BVEC check
Date:   Tue,  1 Dec 2020 09:52:24 +0100
Message-Id: <20201201084715.690223207@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 9c3a205c5ffa36e96903c2e37eb5f41c0f03c43e upstream.

iov_iter::type is a bitmask that also keeps direction etc., so it
shouldn't be directly compared against ITER_*. Use proper helper.

Fixes: ff6165b2d7f6 ("io_uring: retain iov_iter state over io_read/io_write calls")
Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: <stable@vger.kernel.org> # 5.9
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2991,7 +2991,7 @@ static void io_req_map_rw(struct io_kioc
 	rw->free_iovec = NULL;
 	rw->bytes_done = 0;
 	/* can only be fixed buffers, no need to do anything */
-	if (iter->type == ITER_BVEC)
+	if (iov_iter_is_bvec(iter))
 		return;
 	if (!iovec) {
 		unsigned iov_off = 0;



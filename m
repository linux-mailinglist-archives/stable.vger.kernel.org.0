Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55D02D607E
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391044AbgLJOi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:38:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391177AbgLJOix (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:38:53 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 42/75] io_uring: fix recvmsg setup with compat buf-select
Date:   Thu, 10 Dec 2020 15:27:07 +0100
Message-Id: <20201210142608.142620506@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 2d280bc8930ba9ed1705cfd548c6c8924949eaf1 upstream.

__io_compat_recvmsg_copy_hdr() with REQ_F_BUFFER_SELECT reads out iov
len but never assigns it to iov/fast_iov, leaving sr->len with garbage.
Hopefully, following io_buffer_select() truncates it to the selected
buffer size, but the value is still may be under what was specified.

Cc: <stable@vger.kernel.org> # 5.7
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4300,7 +4300,8 @@ static int __io_compat_recvmsg_copy_hdr(
 			return -EFAULT;
 		if (clen < 0)
 			return -EINVAL;
-		sr->len = iomsg->iov[0].iov_len;
+		sr->len = clen;
+		iomsg->iov[0].iov_len = clen;
 		iomsg->iov = NULL;
 	} else {
 		ret = compat_import_iovec(READ, uiov, len, UIO_FASTIOV,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723CF3C4784
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbhGLGdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236312AbhGLGbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D884F61004;
        Mon, 12 Jul 2021 06:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071345;
        bh=OR2XskNzRS1r0W3+UmIOCCEc3g9y1/invy1dN9pxn2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjmSfHLCJxikzZTDzvpMQpGwSIDZKqdSMzXx7pioP658yfBCejYBvKo2IevZ8ssO7
         U/mke0nuL0c8mD+KwZjBEVjsIzeNhaZI9MJYZ9BHGPhxigZAVGFGFvFkbGV1GsZdsC
         DENriMT2MI2r0a+6jE9yX5v2op8ilQQtXVI2PjqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 031/593] copy_page_to_iter(): fix ITER_DISCARD case
Date:   Mon, 12 Jul 2021 08:03:11 +0200
Message-Id: <20210712060846.609256441@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit a506abc7b644d71966a75337d5a534f531b3cdc4 upstream.

we need to advance the iterator...

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/iov_iter.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -922,9 +922,12 @@ size_t copy_page_to_iter(struct page *pa
 		size_t wanted = copy_to_iter(kaddr + offset, bytes, i);
 		kunmap_atomic(kaddr);
 		return wanted;
-	} else if (unlikely(iov_iter_is_discard(i)))
+	} else if (unlikely(iov_iter_is_discard(i))) {
+		if (unlikely(i->count < bytes))
+			bytes = i->count;
+		i->count -= bytes;
 		return bytes;
-	else if (likely(!iov_iter_is_pipe(i)))
+	} else if (likely(!iov_iter_is_pipe(i)))
 		return copy_page_to_iter_iovec(page, offset, bytes, i);
 	else
 		return copy_page_to_iter_pipe(page, offset, bytes, i);



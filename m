Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2073C50D3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241777AbhGLHfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344671AbhGLHcA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:32:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F234260230;
        Mon, 12 Jul 2021 07:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074951;
        bh=2Ur6X8inxXdWnyOjM9OdtGJE/OBuTDtyzGn5JiJ73ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ETCjg8VY1ShNyr8CggyIBPgEeb61/i7bPpr+YpxG0Hb0b617aBa/R5dElAkVl3tB
         EimVqM9vMIGxY3uCkNcAZJd6muQcmfWuQM5cynrBEF7thVkQ0EbkH3PxLDQaS72XTJ
         EPE/lRv/B9zEssdJnBwYiER94/UEy1izt+hRY7Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.13 036/800] copy_page_to_iter(): fix ITER_DISCARD case
Date:   Mon, 12 Jul 2021 08:00:59 +0200
Message-Id: <20210712060918.361451044@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
@@ -967,9 +967,12 @@ size_t copy_page_to_iter(struct page *pa
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



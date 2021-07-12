Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9E23C4BDD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbhGLHAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233473AbhGLG6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 863F0613CA;
        Mon, 12 Jul 2021 06:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072954;
        bh=Oy13UB0ME+Nb4/IQRgeCJ2zrfoqR/8cCRtL+p4W3lEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyZqqZoabB5VNCapgJdVhm122bb56GmgMVE6GttH+h55UsANXpf/fY3yCxAzZ7tDB
         9xPudMLamTi/EAhPUV54Io3VG0JE786BC6vwJpfsMkyw7dXCv1h/kTBf7KKF55XplU
         X7rXNpcou/FhQsFsWNbV1A+a1/BSq3Eyl7bmOXK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.12 034/700] copy_page_to_iter(): fix ITER_DISCARD case
Date:   Mon, 12 Jul 2021 08:01:57 +0200
Message-Id: <20210712060929.437420872@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
@@ -906,9 +906,12 @@ size_t copy_page_to_iter(struct page *pa
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



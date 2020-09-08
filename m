Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C86426179C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgIHRjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731693AbgIHQOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:14:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91B512490C;
        Tue,  8 Sep 2020 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580424;
        bh=mDAayG0BYTRGLjATShtsFVr8E+gMhNmqROIsuzBvSvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iy649z7VgLfwV2CbNsxJv071Gg3zBB7zogZxQ811WB2vHmgUqNmlDwah8AYV+TB4T
         hYQUxgT5Bubyw+YUSLhwGGY3oDmHjYS13Q+moJPSpZ+KJ/A9gJrYnzGH+dycKcY7Sl
         L1YkPrfZtBLT5UEolQstFs8ZNuVHDpigm2RATL70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+61acc40a49a3e46e25ea@syzkaller.appspotmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 52/65] block: allow for_each_bvec to support zero len bvec
Date:   Tue,  8 Sep 2020 17:26:37 +0200
Message-Id: <20200908152219.764818884@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 7e24969022cbd61ddc586f14824fc205661bb124 upstream.

Block layer usually doesn't support or allow zero-length bvec. Since
commit 1bdc76aea115 ("iov_iter: use bvec iterator to implement
iterate_bvec()"), iterate_bvec() switches to bvec iterator. However,
Al mentioned that 'Zero-length segments are not disallowed' in iov_iter.

Fixes for_each_bvec() so that it can move on after seeing one zero
length bvec.

Fixes: 1bdc76aea115 ("iov_iter: use bvec iterator to implement iterate_bvec()")
Reported-by: syzbot <syzbot+61acc40a49a3e46e25ea@syzkaller.appspotmail.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Link: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2262077.html
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/bvec.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -119,10 +119,17 @@ static inline bool bvec_iter_rewind(cons
 	return true;
 }
 
+static inline void bvec_iter_skip_zero_bvec(struct bvec_iter *iter)
+{
+	iter->bi_bvec_done = 0;
+	iter->bi_idx++;
+}
+
 #define for_each_bvec(bvl, bio_vec, iter, start)			\
 	for (iter = (start);						\
 	     (iter).bi_size &&						\
 		((bvl = bvec_iter_bvec((bio_vec), (iter))), 1);	\
-	     bvec_iter_advance((bio_vec), &(iter), (bvl).bv_len))
+	     (bvl).bv_len ? (void)bvec_iter_advance((bio_vec), &(iter),	\
+		     (bvl).bv_len) : bvec_iter_skip_zero_bvec(&(iter)))
 
 #endif /* __LINUX_BVEC_ITER_H */



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817E2261A13
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgIHSat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731388AbgIHQJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C20062465E;
        Tue,  8 Sep 2020 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580213;
        bh=q14keo6eWb52D3/Vm7501xybZhIhWe9Zs++ipQhJZ3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRgQL3uhhb2VK0MJHmQIjsKQOL8zW4xAucX2/MBubHzrLtKj0qn8fDKpFDrj/VT5G
         WxSISXWOZxWbg02zOLBNBoHbI/zDMkcMFaLZ/wm22jaDnjXJaV5XuY5YkBf//OQxzh
         eLbBcnQJ8tVVJnMtwHliUcYGRyYE3q9rRTDuGgZo=
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
Subject: [PATCH 4.19 74/88] block: allow for_each_bvec to support zero len bvec
Date:   Tue,  8 Sep 2020 17:26:15 +0200
Message-Id: <20200908152224.875359983@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
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
@@ -119,11 +119,18 @@ static inline bool bvec_iter_rewind(cons
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
 
 /* for iterating one bio from start to end */
 #define BVEC_ITER_ALL_INIT (struct bvec_iter)				\



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35F3266183
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIKOuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgIKNCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:02:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05982222BA;
        Fri, 11 Sep 2020 12:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829040;
        bh=99r5w4O8248Tl0eMNSWdsulWkBEbz3tyeCLnihvggk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUPAuEEI18yAiujrFZUszk9k299qFyQh72X7dUT8gM3SJGayG+tpnGST9HJJyq1OW
         jxp6ybY5ZriaX5TxqsNNzo9HvV61IsJiIrqflN1deTbxlP/mgdkWS9PqEHwf8V//Sa
         H8Sy4D7iHlCpXXFiaGWya19+E0erzHMBgJ40EsN0=
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
Subject: [PATCH 4.9 43/71] block: allow for_each_bvec to support zero len bvec
Date:   Fri, 11 Sep 2020 14:46:27 +0200
Message-Id: <20200911122507.074597960@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
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
@@ -88,10 +88,17 @@ static inline void bvec_iter_advance(con
 	}
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



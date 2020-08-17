Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2F32463E2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgHQKBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:01:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30770 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726403AbgHQKBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:01:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597658476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BrXFDx1bTAXwaUWV3GukE+d+mtRNZfLhJ424PnhQemM=;
        b=T39gZ+Ikq3HzyyAlId2ZHwjI4H4o3hjeBJcj2f4/DliZfgn54MqjROV2Mimuq2EtJHOS6B
        ZSsRFmWuntsoVLCm9FSegG7rT9yeAnPUmzMWL4v7ZOBbE/+r8Ed8MvGLNbm079XOjhsPZU
        AOvzHX6eBVwUvXeb9+3xxmdmHoXNbCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-y2IIRF0uMDa6pqM5DV0sBA-1; Mon, 17 Aug 2020 06:01:10 -0400
X-MC-Unique: y2IIRF0uMDa6pqM5DV0sBA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E585257059;
        Mon, 17 Aug 2020 10:01:08 +0000 (UTC)
Received: from localhost (ovpn-13-146.pek2.redhat.com [10.72.13.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C66355B6B6;
        Mon, 17 Aug 2020 10:01:04 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        syzbot <syzbot+61acc40a49a3e46e25ea@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: [PATCH V2] block: allow for_each_bvec to support zero len bvec
Date:   Mon, 17 Aug 2020 18:00:55 +0800
Message-Id: <20200817100055.2495905-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Block layer usually doesn't support or allow zero-length bvec. Since
commit 1bdc76aea115 ("iov_iter: use bvec iterator to implement
iterate_bvec()"), iterate_bvec() switches to bvec iterator. However,
Al mentioned that 'Zero-length segments are not disallowed' in iov_iter.

Fixes for_each_bvec() so that it can move on after seeing one zero
length bvec.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2262077.html
Fixes: 1bdc76aea115 ("iov_iter: use bvec iterator to implement iterate_bvec()")
Reported-by: syzbot <syzbot+61acc40a49a3e46e25ea@syzkaller.appspotmail.com>
Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
---
V2:
	- fix reported-by tag

 include/linux/bvec.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index ac0c7299d5b8..9c4fab5f22a7 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -117,11 +117,18 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
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
+	     (bvl).bv_len ? bvec_iter_advance((bio_vec), &(iter),	\
+		     (bvl).bv_len) : bvec_iter_skip_zero_bvec(&(iter)))
 
 /* for iterating one bio from start to end */
 #define BVEC_ITER_ALL_INIT (struct bvec_iter)				\
-- 
2.25.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E9839AA65
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 20:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFCSsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 14:48:31 -0400
Received: from linux.microsoft.com ([13.77.154.182]:44924 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFCSsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 14:48:31 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 5FFF320B7178; Thu,  3 Jun 2021 11:46:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5FFF320B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1622746006;
        bh=HI4zlfdxf8GbN+8OyNNKD0rxn8LbKNH+lRJ/OymYueI=;
        h=From:To:Cc:Subject:Date:From;
        b=IRGvEIjlLgf/5GppIFX+W/58cmOR91g3sDWw+p/rEYy8weYEmvc9vot3Diu2cOecX
         eRUIGcemNFSdlsyjD2XZwusIG9LayjjtQAFxtlVf4i2ijwjV03iNIBTr5Ol1isJGE7
         2AsU+uEhgZsyC5vzFqQuXITLiuumw5k95eTqdDcs=
From:   longli@linuxonhyperv.com
To:     linux-block@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] block: return the correct first bvec when checking for gaps
Date:   Thu,  3 Jun 2021 11:46:45 -0700
Message-Id: <1622746005-10785-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

After commit 07173c3ec276 ("block: enable multipage bvecs"), a bvec can
have multiple pages. But bio_will_gap() still assumes one page bvec while
checking for merging. This causes data corruption on drivers relying on
the correct merging on virt_boundary_mask.

Fix this by returning the bvec for multi-page bvec.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: 07173c3ec276 ("block: enable multipage bvecs")
Signed-off-by: Long Li <longli@microsoft.com>
---
 include/linux/bio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index a0b4cfdf62a4..e89242a53bbc 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -271,7 +271,7 @@ static inline void bio_clear_flag(struct bio *bio, unsigned int bit)
 
 static inline void bio_get_first_bvec(struct bio *bio, struct bio_vec *bv)
 {
-	*bv = bio_iovec(bio);
+	*bv = mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
 }
 
 static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
-- 
2.17.1


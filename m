Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98516521F7F
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346272AbiEJPuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346333AbiEJPsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:48:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635FA281348;
        Tue, 10 May 2022 08:44:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5073C614EA;
        Tue, 10 May 2022 15:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20A7C385A6;
        Tue, 10 May 2022 15:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197465;
        bh=/WySDu8wnTntCqGUHjerN/beg29yM9aeGgeUfEc+4Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vp1NArSQX7IHrY/mvLkEpoZsUte3mziph4Zz74bmyBPS/zviPdQEGVOUCgL9Ve6yz
         ++J1wC8M/g62BUOKYFrz5/kSrI3RSxjVpYXEglIOcs3VjbqkQSGtELHHMdByIWf7l6
         FBMpTWX8YD8mb3ureGu1WFgohHXHGyTw6yZkr2DF1J9sFWeiU2IyY8U7ePaoFGcphl
         XXLWATWFgmRYhOWrxbhhUADpC/cXpBFMzzwwVhZFreHM3guSk9vzr9f4uW/LP0BAAC
         WTVT7m4stusszdsSQyFsHIooLQ57i4CntD2DuJ5olqRKG4kcN5Ie7ghK0IYzMMPabH
         ZsKbE3+qfkuSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, axboe@kernel.dk,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 20/21] block: Do not call folio_next() on an unreferenced folio
Date:   Tue, 10 May 2022 11:43:39 -0400
Message-Id: <20220510154340.153400-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154340.153400-1-sashal@kernel.org>
References: <20220510154340.153400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 170f37d6aa6ad4582eefd7459015de79e244536e ]

It is unsafe to call folio_next() on a folio unless you hold a reference
on it that prevents it from being split or freed.  After returning
from the iterator, iomap calls folio_end_writeback() which may drop
the last reference to the page, or allow the page to be split.  If that
happens, the iterator will not advance far enough through the bio_vec,
leading to assertion failures like the BUG() in folio_end_writeback()
that checks we're not trying to end writeback on a page not currently
under writeback.  Other assertion failures were also seen, but they're
all explained by this one bug.

Fix the bug by remembering where the next folio starts before returning
from the iterator.  There are other ways of fixing this bug, but this
seems the simplest.

Reported-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: Brian Foster <bfoster@redhat.com>
Tested-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bio.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 117d7f248ac9..2ca54c084d5a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -272,6 +272,7 @@ struct folio_iter {
 	size_t offset;
 	size_t length;
 	/* private: for use by the iterator */
+	struct folio *_next;
 	size_t _seg_count;
 	int _i;
 };
@@ -286,6 +287,7 @@ static inline void bio_first_folio(struct folio_iter *fi, struct bio *bio,
 			PAGE_SIZE * (bvec->bv_page - &fi->folio->page);
 	fi->_seg_count = bvec->bv_len;
 	fi->length = min(folio_size(fi->folio) - fi->offset, fi->_seg_count);
+	fi->_next = folio_next(fi->folio);
 	fi->_i = i;
 }
 
@@ -293,9 +295,10 @@ static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
 {
 	fi->_seg_count -= fi->length;
 	if (fi->_seg_count) {
-		fi->folio = folio_next(fi->folio);
+		fi->folio = fi->_next;
 		fi->offset = 0;
 		fi->length = min(folio_size(fi->folio), fi->_seg_count);
+		fi->_next = folio_next(fi->folio);
 	} else if (fi->_i + 1 < bio->bi_vcnt) {
 		bio_first_folio(fi, bio, fi->_i + 1);
 	} else {
-- 
2.35.1


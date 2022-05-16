Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1220752900E
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240654AbiEPUKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351019AbiEPUB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B62A47549;
        Mon, 16 May 2022 12:56:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 183AF60FEB;
        Mon, 16 May 2022 19:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA39C385AA;
        Mon, 16 May 2022 19:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730988;
        bh=35U1+jwEv92WmgOxTVCnczY3ljAOaMeAQs9IhU0Y48A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMbIZmRVs4449I2rde98fT/bAtlS8j5psx9aGD3mQflN/PRaI22bh8itJtFk5M12z
         gwGRpi8YRJ6xrO9oHAnPZw2tPxNwooxvfboXeboHpe8vHP9OXz1FymwRnSUQ11JBMs
         BF6hd4FnnRu2Oh0m/TmEh3dMBw40qn2ahEPzAPtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 068/114] block: Do not call folio_next() on an unreferenced folio
Date:   Mon, 16 May 2022 21:36:42 +0200
Message-Id: <20220516193627.444142895@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084B74095E7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346256AbhIMOqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347645AbhIMOoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEE696113B;
        Mon, 13 Sep 2021 13:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541458;
        bh=I5NO4vbOtc+RqNT1FsktWqoBMD/ekz/C/KDVI5jjs7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1wu6HY7wHcDfn/9zYVurvn9s801DKMJD9fKxmT/StEHesQ9DQmV21v3ksGEAbIAH
         JuYqHT84R6AqtWKa5x4Gku99xUSzRLmnLulSMrscpdc1m8mukGQT7kQtnH5mgvPIOQ
         HVkiFp95HFPPZhpw1oZhInWM9Hv+pIPHKdhVy/4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 304/334] bio: fix page leak bio_add_hw_page failure
Date:   Mon, 13 Sep 2021 15:15:58 +0200
Message-Id: <20210913131123.698338684@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit d9cf3bd531844ffbfe94b16e417037a16efc988d upstream.

__bio_iov_append_get_pages() doesn't put not appended pages on
bio_add_hw_page() failure, so potentially leaking them, fix it. Also, do
the same for __bio_iov_iter_get_pages(), even though it looks like it
can't be triggered by userspace in this case.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Cc: stable@vger.kernel.org # 5.8+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1edfa6a2ffd66d55e6345a477df5387d2c1415d0.1626653825.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -979,6 +979,14 @@ static int bio_iov_bvec_set_append(struc
 	return 0;
 }
 
+static void bio_put_pages(struct page **pages, size_t size, size_t off)
+{
+	size_t i, nr = DIV_ROUND_UP(size + (off & ~PAGE_MASK), PAGE_SIZE);
+
+	for (i = 0; i < nr; i++)
+		put_page(pages[i]);
+}
+
 #define PAGE_PTRS_PER_BVEC     (sizeof(struct bio_vec) / sizeof(struct page *))
 
 /**
@@ -1023,8 +1031,10 @@ static int __bio_iov_iter_get_pages(stru
 			if (same_page)
 				put_page(page);
 		} else {
-			if (WARN_ON_ONCE(bio_full(bio, len)))
-                                return -EINVAL;
+			if (WARN_ON_ONCE(bio_full(bio, len))) {
+				bio_put_pages(pages + i, left, offset);
+				return -EINVAL;
+			}
 			__bio_add_page(bio, page, len, offset);
 		}
 		offset = 0;
@@ -1069,6 +1079,7 @@ static int __bio_iov_append_get_pages(st
 		len = min_t(size_t, PAGE_SIZE - offset, left);
 		if (bio_add_hw_page(q, bio, page, len, offset,
 				max_append_sectors, &same_page) != len) {
+			bio_put_pages(pages + i, left, offset);
 			ret = -EINVAL;
 			break;
 		}



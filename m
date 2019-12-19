Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BAF126BBF
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbfLSSxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730418AbfLSSxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:53:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B13A9227BF;
        Thu, 19 Dec 2019 18:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781627;
        bh=HmRvdImrrDSCZEqCQ4WawS6uqwqHMiPVGjo2/RsL9iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OU2I8JUba8QSBlBNgOBrVER+khWuj3YFRG0HDbihic7gxOpzj8CU9zsxfpqVDo1pc
         9oJlsJY6p+1oVBOhkMXIy1XuVEpyrg/XZMwIi/GMj86/xDg8qBXqy8f6ZlT9gm1TNP
         S1Kqxo8M0+xDbnPol+Ajm9mFjdqQdpySrFXdpy24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 15/80] block: fix "check bi_size overflow before merge"
Date:   Thu, 19 Dec 2019 19:34:07 +0100
Message-Id: <20191219183052.303047719@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit cc90bc68422318eb8e75b15cd74bc8d538a7df29 upstream.

This partially reverts commit e3a5d8e386c3fb973fa75f2403622a8f3640ec06.

Commit e3a5d8e386c3 ("check bi_size overflow before merge") adds a bio_full
check to __bio_try_merge_page.  This will cause __bio_try_merge_page to fail
when the last bi_io_vec has been reached.  Instead, what we want here is only
the bi_size overflow check.

Fixes: e3a5d8e386c3 ("block: check bi_size overflow before merge")
Cc: stable@vger.kernel.org # v5.4+
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -751,10 +751,12 @@ bool __bio_try_merge_page(struct bio *bi
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return false;
 
-	if (bio->bi_vcnt > 0 && !bio_full(bio, len)) {
+	if (bio->bi_vcnt > 0) {
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
 		if (page_is_mergeable(bv, page, len, off, same_page)) {
+			if (bio->bi_iter.bi_size > UINT_MAX - len)
+				return false;
 			bv->bv_len += len;
 			bio->bi_iter.bi_size += len;
 			return true;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D540F578C89
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 23:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiGRVND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 17:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbiGRVNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 17:13:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2759332444
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 14:13:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s27so11708680pga.13
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 14:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QWJ5QeiPjtbCRgoRk+ubXff2AujiLVH4AasYR9bygac=;
        b=Qpn/lLzaRXrqLa4iJ87u24VvkPxDJWWjGTAS61y4fzRiLM7VlJW1sPXmQsFa4xacBi
         d2LuDEY0zwc3DsJHclZrKEiiALShRj7Ss2xF36d60f/LtfL55PA70R+4bI8JTCI3oBxy
         PcstFGzmzR9d+6F1CkyNASRQX5bfjj8ZY3kuC2GVI/ubigks2gNlluRcWAbgjXpGx2hv
         +rkUWKkZLhOvkpa5WqsEu31hvv5KWNb1o+gn0mPAhLi7jTVRSwvQzfCykZz5RxI+bTGW
         oFCvfrPiCdknsmg4Q6EjDKN5sEdFw08Zi/IezqiUnqKY2HCoSFdMYw4g9LOeqImo0nEf
         p1MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QWJ5QeiPjtbCRgoRk+ubXff2AujiLVH4AasYR9bygac=;
        b=BwvgvEthaK5fSIukFNPY7qu+yoYFVmTygkl/9g5BVy+iad7DnDONkjRRydhoXkTiyd
         GaJiA2tbqNOsC8PMTfYk8S/c/IoG4JjH1byh6ZXuwd5pNC/3j7OoMkpx0gJQJQooc0d/
         dBp5Uj+vXY8PvrXTsg9Qkm/z/YitEJVFtguznFZXGTNPXh4iUlAkOERIcsv9TdoGm1my
         mJNxCNbhT1RRfU2wRUgiYZWrWO2L4wbNhZpfmC3jaWYuzT9qvr/oWZSVO5VWf/b9JCSm
         ONT9xxjGdfAb7zZLgKrU7jMp/ZPLqmuTBIP0JfulF26WITGt2qRn8hxlcL0EdZ+JGuAU
         11RQ==
X-Gm-Message-State: AJIora9hcNDXzNXpIPBvEG9eYBaRaX/omRWpv0OP1byAanfsUL4P8of1
        nUjk+3A8JaCAJ9rS0wuFd7GwakpyXEPriw==
X-Google-Smtp-Source: AGRyM1sdjI8kqsIllwaX0LhjyyYfpduS2Xt4ucZ1qr4Wz+ymQBNsu+CXjfUU7JImFul/sxFNIhBGrQ==
X-Received: by 2002:a63:4d0e:0:b0:412:1877:9820 with SMTP id a14-20020a634d0e000000b0041218779820mr26345153pgb.177.1658178780601;
        Mon, 18 Jul 2022 14:13:00 -0700 (PDT)
Received: from desktop.hsd1.or.comcast.net ([2601:1c0:4c00:ad20:feaa:14ff:fe3a:b225])
        by smtp.gmail.com with ESMTPSA id c7-20020a17090a020700b001ef59378951sm11918134pjc.13.2022.07.18.14.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 14:13:00 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        Christoph Hellwig <hch@lst.de>,
        syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.10 2/2] block: fix bounce_clone_bio for passthrough bios
Date:   Mon, 18 Jul 2022 14:12:26 -0700
Message-Id: <20220718211226.506362-2-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220718211226.506362-1-tadeusz.struk@linaro.org>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Upstream commit: b90994c6ab62 ("block: fix bounce_clone_bio for passthrough bios")

This is backport to stable 5.10. It fixes an issue reported by syzbot.
Link: https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84

Now that bio_alloc_bioset does not fall back to kmalloc for a NULL
bio_set, handle that case explicitly and simplify the calling
conventions.

Based on an earlier patch from Chaitanya Kulkarni.

Fixes: 3175199ab0ac ("block: split bio_kmalloc from bio_alloc_bioset")
Reported-by: syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com
Reported-by: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 block/bounce.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/block/bounce.c b/block/bounce.c
index 162a6eee8999..4da429de78a2 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -214,8 +214,7 @@ static void bounce_end_io_read_isa(struct bio *bio)
 	__bounce_end_io_read(bio, &isa_page_pool);
 }
 
-static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
-		struct bio_set *bs)
+static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask)
 {
 	struct bvec_iter iter;
 	struct bio_vec bv;
@@ -242,8 +241,11 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
 	 *    asking for trouble and would force extra work on
 	 *    __bio_clone_fast() anyways.
 	 */
-
-	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
+	if (bio_is_passthrough(bio_src))
+		bio = bio_kmalloc(gfp_mask, bio_segments(bio_src));
+	else
+		bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src),
+				       &bounce_bio_set);
 	if (!bio)
 		return NULL;
 	bio->bi_disk		= bio_src->bi_disk;
@@ -294,7 +296,6 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	unsigned i = 0;
 	bool bounce = false;
 	int sectors = 0;
-	bool passthrough = bio_is_passthrough(*bio_orig);
 
 	bio_for_each_segment(from, *bio_orig, iter) {
 		if (i++ < BIO_MAX_PAGES)
@@ -305,14 +306,14 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	if (!bounce)
 		return;
 
-	if (!passthrough && sectors < bio_sectors(*bio_orig)) {
+	if (!bio_is_passthrough(*bio_orig) &&
+	    sectors < bio_sectors(*bio_orig)) {
 		bio = bio_split(*bio_orig, sectors, GFP_NOIO, &bounce_bio_split);
 		bio_chain(bio, *bio_orig);
 		submit_bio_noacct(*bio_orig);
 		*bio_orig = bio;
 	}
-	bio = bounce_clone_bio(*bio_orig, GFP_NOIO, passthrough ? NULL :
-			&bounce_bio_set);
+	bio = bounce_clone_bio(*bio_orig, GFP_NOIO);
 
 	/*
 	 * Bvec table can't be updated by bio_for_each_segment_all(),
-- 
2.36.1


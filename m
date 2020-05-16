Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AB61D5D23
	for <lists+stable@lfdr.de>; Sat, 16 May 2020 02:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgEPAT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 20:19:28 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37289 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgEPAT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 20:19:28 -0400
Received: by mail-pj1-f68.google.com with SMTP id q9so1724423pjm.2;
        Fri, 15 May 2020 17:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S3G2WbRhtzm3ssLwF+7XHKy6fZ2iPExuIOPfpVM4JAQ=;
        b=nJ7jGyFcUyB/+6Ee2Q5ua7TB1+rD0OuaW9c4o5BvMrWCILeiIbfcPqO4Djkg9PkYKH
         KDP7dZYG0c3NYpIsFuAdk163ENKS698IevrrLFCmd4bdJ/XjYOxSTFWUsXr53bC1k4d+
         uk/9CeTxBnY4d7rwDi2lJmnivJe2qF+26k8WnPDSuZQgAZB3ji/IiMG9UnZKlYs41d9F
         eM5O7vg5hpkZWB/lwb0lnlcA+lDzJ8mS8hQYta1nM2IgxCBZcWAwCSFh2MSwGHq0A+q6
         GaoYRKi1PSW4F4rC48vPvgU7T5Lj7W3MCkQVQVaOpKji4mlNkYVRfW2QCMDW11OcP/ro
         iVTQ==
X-Gm-Message-State: AOAM533Yoc3Hd2/gW8DAI1ob6zi8Tg6vO5Y+LMwq6Hz76LMp9VeNlDzk
        1GxmBEZkH1YwHQZDreeODAc=
X-Google-Smtp-Source: ABdhPJz6k+47GUDiMGXO63ssCn+K7ItCEDmDzqJpfrHokKVVPveIRMAHsO0swQtse9BfIHPxnx5nJQ==
X-Received: by 2002:a17:902:c489:: with SMTP id n9mr4130738plx.186.1589588367396;
        Fri, 15 May 2020 17:19:27 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id 30sm2542383pgp.38.2020.05.15.17.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 17:19:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
Subject: [PATCH 4/5] block: Fix zero_fill_bio()
Date:   Fri, 15 May 2020 17:19:13 -0700
Message-Id: <20200516001914.17138-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516001914.17138-1-bvanassche@acm.org>
References: <20200516001914.17138-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Multiple block drivers use zero_fill_bio() to zero-initialize the data
buffer used for read operations. Make sure that all pages are zeroed
instead of only the first if one or more multi-page bvecs are used to
describe the data buffer.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/bio.c         | 27 ++++++++++++++++++++++-----
 include/linux/bio.h |  1 +
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 1594804fe8bc..48fcafbdae70 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -527,17 +527,34 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
 }
 EXPORT_SYMBOL(bio_alloc_bioset);
 
+void zero_fill_bvec(const struct bio_vec *bvec)
+{
+	struct page *page = bvec->bv_page;
+	u32 offset = bvec->bv_offset;
+	u32 left = bvec->bv_len;
+
+	while (left) {
+		u32 len = min_t(u32, left, PAGE_SIZE - offset);
+		void *kaddr;
+
+		kaddr = kmap_atomic(page);
+		memset(kaddr + offset, 0, len);
+		flush_dcache_page(page);
+		kunmap_atomic(kaddr);
+		page++;
+		left -= len;
+		offset = 0;
+	}
+}
+EXPORT_SYMBOL(zero_fill_bvec);
+
 void zero_fill_bio_iter(struct bio *bio, struct bvec_iter start)
 {
-	unsigned long flags;
 	struct bio_vec bv;
 	struct bvec_iter iter;
 
 	__bio_for_each_segment(bv, bio, iter, start) {
-		char *data = bvec_kmap_irq(&bv, &flags);
-		memset(data, 0, bv.bv_len);
-		flush_dcache_page(bv.bv_page);
-		bvec_kunmap_irq(data, &flags);
+		zero_fill_bvec(&bv);
 	}
 }
 EXPORT_SYMBOL(zero_fill_bio_iter);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 58e6134b1c05..9438cbdfa19e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -455,6 +455,7 @@ extern void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
 extern void bio_copy_data(struct bio *dst, struct bio *src);
 extern void bio_list_copy_data(struct bio *dst, struct bio *src);
 extern void bio_free_pages(struct bio *bio);
+void zero_fill_bvec(const struct bio_vec *bvec);
 void zero_fill_bio_iter(struct bio *bio, struct bvec_iter iter);
 void bio_truncate(struct bio *bio, unsigned new_size);
 void guard_bio_eod(struct bio *bio);

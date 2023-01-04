Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB3465D80B
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239854AbjADQK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239932AbjADQJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:09:59 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8052140853
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:09:44 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id h6so18218424iof.9
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 08:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NceN64ihHFquTuLGhD5Npe0nXgiqifj2CJk94Zzl6z0=;
        b=NociWIKXuyQ8xwB3tKzZisCoZQOrmK59v7IkBn4zBEMkLQG2X/rUm5T0yboMfW+26m
         DOIHblpZ2TGhKukqMJKeHqtvOCQEjFnBhD6xOGlgKv7PTA02GS/JarbtVL6svrDodEUM
         jWLhF4FLV9kT4LreSgP19QhkyOfba18OCN8p+KlQKRBUq3BQC16ojY/XObu4tFrOL+NK
         e4K79iWSCpvNx54wP/vfqGLgIWtVARG1n52G0IK3vrAXfHKR6ebkyr0nsNhocPYI7sXQ
         KSFlN5uNmvIS3ieEF3fcDWedMKHnYAm6kBKnFtXJfBG+hMbYtSS+Egrv4HZNYEtRi+gX
         LKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NceN64ihHFquTuLGhD5Npe0nXgiqifj2CJk94Zzl6z0=;
        b=b839nwEN+TMoTF/MF0sq6G6VW0GYtyTTDoIJkXa16RWGjvlIUapTeH6a4Jhcurroj2
         vlhhT79ceBy7EHkDZ9u2YQ47zqM+DGl3hU80TGlu1zDaRK3jx8CaKwRMeExHyNxfzw8K
         +RpL0BZWFmk6IgmHXyhaugRBAio5rW92GKl+K+MHeEqZLXDNcbXWfKsampXqh6RT0RM2
         FyUkuuQZ60j4iu8UZ595rrtd1Xud+302ecyIQSvf0ckMLsO2vTDtqI7pcVynzM68g/6a
         P59HiurBPDTbZiz2Bp7SykLUwM3/7blHiSDFkxbOEObCd5XYMOnq1MCucorKYSQYhNBW
         sslA==
X-Gm-Message-State: AFqh2kr8IUWa7d7Jhh1L0FsODJ5WOjT22ujgCssSKPB7ag9yG9JrEQ0C
        pzsnkVBnIeygpZB6ijY0tkVftru1RTgAu+eR
X-Google-Smtp-Source: AMrXdXuAbUuaXYHlaQnr1bXlr6i2H3IR4Kv8gJ4kOtCPepAxuAwlJOy6+WPgC7DcPdBWChQJ8HSBJw==
X-Received: by 2002:a6b:e812:0:b0:6f3:fed4:aa36 with SMTP id f18-20020a6be812000000b006f3fed4aa36mr5079162ioh.1.1672848583815;
        Wed, 04 Jan 2023 08:09:43 -0800 (PST)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t24-20020a02b198000000b0038a41eb1ba3sm10955243jah.177.2023.01.04.08.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:09:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     mikelley@microsoft.com, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] block: don't allow splitting of a REQ_NOWAIT bio
Date:   Wed,  4 Jan 2023 09:09:38 -0700
Message-Id: <20230104160938.62636-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160938.62636-1-axboe@kernel.dk>
References: <20230104160938.62636-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we split a bio marked with REQ_NOWAIT, then we can trigger spurious
EAGAIN if constituent parts of that split bio end up failing request
allocations. Parts will complete just fine, but just a single failure
in one of the chained bios will yield an EAGAIN final result for the
parent bio.

Return EAGAIN early if we end up needing to split such a bio, which
allows for saner recovery handling.

Cc: stable@vger.kernel.org # 5.15+
Link: https://github.com/axboe/liburing/issues/766
Reported-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-merge.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 071c5f8cf0cf..b7c193d67185 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -309,6 +309,16 @@ static struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
 	*segs = nsegs;
 	return NULL;
 split:
+	/*
+	 * We can't sanely support splitting for a REQ_NOWAIT bio. End it
+	 * with EAGAIN if splitting is required and return an error pointer.
+	 */
+	if (bio->bi_opf & REQ_NOWAIT) {
+		bio->bi_status = BLK_STS_AGAIN;
+		bio_endio(bio);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	*segs = nsegs;
 
 	/*
-- 
2.39.0


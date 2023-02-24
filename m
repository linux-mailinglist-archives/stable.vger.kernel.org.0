Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D9A6A2048
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 18:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBXRIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 12:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjBXRIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 12:08:52 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D72722DC5
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:08:50 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id z5so127966ilq.0
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677258529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evy5Nhcn/IK9a4WHn7+Nf7/BMe3ohJX14uH+qC58xX8=;
        b=5XTMOH/klFzt3FjJ0if1hdeJUIN4srqA4fFEyiq7QUfL3isiZnucAqhBFHjxE5+wDk
         rc/oHswCpyoggOxrBEePIMTA7Ti7mpg6+TXIDx4Rt+stmfOfPpMDZqxJ+ZA6nPooek8Z
         Yh5W9zkHiQtkkkpPya7PJzoLp/KBHwk2IzZ2FIpJSe405mgErgqxo/uMxfcT4cHytvZN
         QRhihcPIPlh8/rp+jXPiXqipQA0/HVRV9v6jca1ljwiwIXcNHjnDE8oHgFXh9D1xYr+N
         ayAPkFJT5GDy2GKnaXWrQzC5+1Svv/iyL7TaW/VbFlISyr7PHAwnBJfBuJQwWg+jZ8r+
         y6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677258529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=evy5Nhcn/IK9a4WHn7+Nf7/BMe3ohJX14uH+qC58xX8=;
        b=g2cZteAcgAx1ro6m68txPRjUS8juTkoQxehbCol9MhHLvTKq7OiLuevqvuRw/iRK6C
         kyoLYL51AMuHyqUjrRjP8+bwvueISPgsMwCUhjpN9dFOnCwccGzgDnC5/ypj2eoEHy8k
         506n+xexe6ZPEQLruMPbB70PVyhjFHn5/JL8bcp2cVOD5hBS8lmRRP+N776MlAXidvis
         7VyhYFkEpNbXwdEJ2S1rm68H/GNYNM3/ntGAkq1pvK86OkzlsakycWc/yeLnxEcol8gO
         f/1ocH+M5Rq2R9YvB+Ef/fL9e47Lxrnk93OiAQ/1UVsa2aGiXjBACzY6gfrRYDmhHepR
         oYmg==
X-Gm-Message-State: AO0yUKUTpwDgJLXuHw7J2gcqYkZuc85GjXmox7ieFp3wJ+Jn9+ZDcckX
        VWTLNAMvZPBnrxFmsTDdyBzchw==
X-Google-Smtp-Source: AK7set8z4Oi3tz5DjYLDXT6/eiJUyZvJ9FLbmpUSYMSF2IFo//6Mi7nXAZe7kEnwChgnd18FqbpibA==
X-Received: by 2002:a05:6e02:1567:b0:317:16bc:dc97 with SMTP id k7-20020a056e02156700b0031716bcdc97mr1505626ilu.3.1677258529537;
        Fri, 24 Feb 2023 09:08:49 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a92d341000000b0031535ce9cc8sm4166018ilh.83.2023.02.24.09.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:08:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     kbusch@kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] block: clear bio->bi_bdev when putting a bio back in the cache
Date:   Fri, 24 Feb 2023 10:08:44 -0700
Message-Id: <20230224170845.175485-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230224170845.175485-1-axboe@kernel.dk>
References: <20230224170845.175485-1-axboe@kernel.dk>
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

This isn't strictly needed in terms of correctness, but it does allow
polling to know if the bio has been put already by a different task
and hence avoid polling something that we don't need to.

Cc: stable@vger.kernel.org
Fixes: be4d234d7aeb ("bio: add allocation cache abstraction")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio.c b/block/bio.c
index 2693f34afb7e..605c40025068 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -772,6 +772,7 @@ static inline void bio_put_percpu_cache(struct bio *bio)
 
 	if ((bio->bi_opf & REQ_POLLED) && !WARN_ON_ONCE(in_interrupt())) {
 		bio->bi_next = cache->free_list;
+		bio->bi_bdev = NULL;
 		cache->free_list = bio;
 		cache->nr++;
 	} else {
-- 
2.39.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8F31EF43B
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 11:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgFEJcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 05:32:13 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46001 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgFEJcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 05:32:13 -0400
Received: by mail-lf1-f65.google.com with SMTP id d7so5376520lfi.12;
        Fri, 05 Jun 2020 02:32:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g5N2NMGInA2QV9WtqBQogGP0D/D9maNsaZ4YU4uZz48=;
        b=NzLa5+wkKlANdW5ackkkf3XLPi2hdBUjA8rrj1vbPEkotEE8H89CtnyowIqTe7/do1
         y4aOWk50rPTj3ypnyBYqfb5DDcn04ZUq6RKZyevWbGpTZ8/Y2Cu3Zij8Bcpg4YiHNEHB
         0dulLs1pRpoJ1s8fSNzfdgcPFa82fGdfGW+x9cj5cH8jOcU9SFIV22POmKXjGhbQneqJ
         knO89G4eJ3/b3mT46BJKxkhLdkxjoVPwfv9eT9L9fEA+jSac2pLMvKlN6ZqCcAw2LBIF
         lCOC787szFCK6DrbR98FkeJA+nrnNHzk4ppWU5/AacY3RaeP4s0sM3cBu6gmZ4OfTQa7
         8K4w==
X-Gm-Message-State: AOAM530t/30ftGpy1Yk2dZkDVM4AW0s8BX4IywEUr618zjxUUJY1uTOf
        PEOVVVhOYmS55ow4N3nJdvGHQ2yV
X-Google-Smtp-Source: ABdhPJzEShvBSqm+wr0GcXx11wzIu32MD2oktQgX8+jM/rNPIu/I4p5FH1xoe2lCR+rCfTqZrnwgYw==
X-Received: by 2002:a19:70d:: with SMTP id 13mr4950336lfh.60.1591349530462;
        Fri, 05 Jun 2020 02:32:10 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id j26sm646272lfp.87.2020.06.05.02.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 02:32:09 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Denis Efremov <efremov@linux.com>,
        Mark Rutland <mark.rutland@arm.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] io_uring: use kvfree() in io_sqe_buffer_register()
Date:   Fri,  5 Jun 2020 12:32:03 +0300
Message-Id: <20200605093203.40087-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use kvfree() to free the pages and vmas, since they are allocated by
kvmalloc_array() in a loop.

Fixes: d4ef647510b1 ("io_uring: avoid page allocation warnings")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
I checked the v1 d4ef647510b1 discussion and these lines are using
kvfree() https://lkml.org/lkml/2019/5/1/254. This was somehow missed
in v2.

 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9d4bd0d3a080..defb8a3538fc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7160,8 +7160,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 
 		ret = 0;
 		if (!pages || nr_pages > got_pages) {
-			kfree(vmas);
-			kfree(pages);
+			kvfree(vmas);
+			kvfree(pages);
 			pages = kvmalloc_array(nr_pages, sizeof(struct page *),
 						GFP_KERNEL);
 			vmas = kvmalloc_array(nr_pages,
-- 
2.26.2


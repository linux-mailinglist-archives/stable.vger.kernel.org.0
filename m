Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E8B278E36
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgIYQUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbgIYQUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012E4C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:14 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q95so2454535pja.0
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=LQw063vWlYfSlascwO6RX80cC/IQlselMN8Nbrys3+I=;
        b=tXNyBA0PPz0m9vA5qyqul5RNhNM9O+g+GvUIYeUtcICaWy2ZWbV86bRRqWt2FlSXGI
         MN9eNI7QQGLNqQiBN05xsnAZsLBzuIDGtFCKvoHwOsPnBcFPiME3fLjOnL7Su7QEd/QF
         TcHn041YScttjU+zK/eLs4Pb3ka1cEDBy1Y9gidexCKVoMrPa6KGgecMH5QC3PLC5qIv
         qpRFMR2pPlkBbIK+H0Ng1IFf9odfYM5AdcnXv7Hvl6Scikw1RrbJnToabFpZx+s2ZFZH
         WP6ozl1p1hS66/nxW1qUnWn78p5WuioVLjmgwo/S8/TtI98UzWnSM7lsDtzVkRXCQPTI
         J6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LQw063vWlYfSlascwO6RX80cC/IQlselMN8Nbrys3+I=;
        b=oGgC/6PWUqrvh6nz3JYKS9fqIS0BzfPlAskroec8X/l7TUB0r2V0lTH39jYLlc6Gmb
         /XzleGI0jLsMZhZhm15dLIyUZogaPW1YAIz/uKk41ABdeOJ6qMr2cvq7VrrZSPjeXp7n
         W25t+Xmu8x4tTddqwgtn3g/lzr9IM41qSJ8+jR7G7GKBGCOdptDdw4yGxQfVtamOyDOF
         IiuTWWHNEFtLXfI4wXTbtP2SfYd38ajh0Q4ZHV74qWOdEcve9f+VoBaK7Lghe40emmFw
         cJrvesvkXl+aA7Oqzev4B34XhFOGETmeH+b8Ym8zQBSOaEUiPdJt6c8iPj/7kux017HV
         FuPg==
X-Gm-Message-State: AOAM533AvHICdYKOJxeMzOcNAps+ERvyF2+5oGEbaTW+YFeMzL1tnCGB
        2foZ1KQ6d+0IrAoFgoJ7S0Fo4xg7vExejdBWB0TNCPHYhr2EUo2FWgG6+Fdp8VB8nnay3OsXbZf
        E06jqwxOfx16Irs4O2V48q0SLPGfMd1OUViuY1cHIh0i61HTUkRBp/9IKi5dBcw==
X-Google-Smtp-Source: ABdhPJwOXsOQK8GixARERRmWxLcFir6z2XI6A8ACKhHJBN+cRoFBM5n2vBDc7ygh5empiOWAJYdVkPoM46g=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a17:902:b7c7:b029:d1:cc21:9c38 with SMTP id
 v7-20020a170902b7c7b02900d1cc219c38mr147653plz.21.1601050813329; Fri, 25 Sep
 2020 09:20:13 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:59 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-14-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 13/30 for 5.4] dma-pool: fix too large DMA pools on medium
 memory size systems
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

upstream 3ee06a6d532f75f20528ff4d2c473cda36c484fe commit.

On systems with at least 32 MiB, but less than 32 GiB of RAM, the DMA
memory pools are much larger than intended (e.g. 2 MiB instead of 128
KiB on a 256 MiB system).

Fix this by correcting the calculation of the number of GiBs of RAM in
the system.  Invert the order of the min/max operations, to keep on
calculating in pages until the last step, which aids readability.

Fixes: 1d659236fb43c4d2 ("dma-pool: scale the default DMA coherent pool size with memory capacity")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/pool.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 35bb51c31fff..8cfa01243ed2 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -175,10 +175,9 @@ static int __init dma_atomic_pool_init(void)
 	 * sizes to 128KB per 1GB of memory, min 128KB, max MAX_ORDER-1.
 	 */
 	if (!atomic_pool_size) {
-		atomic_pool_size = max(totalram_pages() >> PAGE_SHIFT, 1UL) *
-					SZ_128K;
-		atomic_pool_size = min_t(size_t, atomic_pool_size,
-					 1 << (PAGE_SHIFT + MAX_ORDER-1));
+		unsigned long pages = totalram_pages() / (SZ_1G / SZ_128K);
+		pages = min_t(unsigned long, pages, MAX_ORDER_NR_PAGES);
+		atomic_pool_size = max_t(size_t, pages << PAGE_SHIFT, SZ_128K);
 	}
 	INIT_WORK(&atomic_pool_work, atomic_pool_work_fn);
 
-- 
2.28.0.618.gf4bc123cb7-goog


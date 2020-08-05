Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FBD23CECB
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgHETFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgHETEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 15:04:30 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEDBC06179E
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 12:04:29 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so18087188plk.13
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 12:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cWBD0QiEpQVn0P/IDPHGnUYjfhi47k2QaaTMr3OG8s4=;
        b=yKAPq+33idFSZT8+JxNG3aZD1V9EAmAAGitlwQBadp/vUTOEjluu7Z4yKhojqBr1yW
         RwiZpgeYVLjmYGD57z2a/DgStOpujDAoB4MHSEozB5wZn/9bQhqbgyQyO6SUPEZJEz+3
         pzyrGZiieUdQGpxcyE74Ap1ltsr01KgKjIN8U60DDoMotXwi0D7dehGSrdZToVlSmu2T
         da8j2YBkRyJg3wykDbhiIL1HGtqhIYoDzmN3aoI1CrYCFkxXK4qq2E8iBhV710X/0Gz3
         fGgo3VxEBbN6gDMbg5ggb75HXD017JBjcYXHLzxoqi3YN17RJ4iPrSX1pEa6uAVeKAbf
         eq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cWBD0QiEpQVn0P/IDPHGnUYjfhi47k2QaaTMr3OG8s4=;
        b=KOeblMvofOjVn/QjXJL9UTz/CBBIF584XhFNnhC+7Qhrskoj+50e44VD0wNp6dNhLG
         xast/KWjnt1bFEVyuFq83RLRjF6IwOVMbe/dIIadCbv1I5Dv6moMvXhF0ZoGBwt7oAZt
         g+DPxxZD+6YKDOogylGMwkheKA+CcXk47ak705nTznJdTDDTUHieD0NqJPjPiUuEhxvv
         CDFpYohz9sZb/+s12XcbiSvlMneQM8tcyjWAVHFeVL2LMXnXKdYF07e4VgAGfQzCKj0N
         JpAZf7vZVwcxYV8NVs3bxNCUqyyBOA46IVMU5oRmVq5jRrLujBeY79dc5d6Ew0MCLXfN
         e22w==
X-Gm-Message-State: AOAM5308dif+pcMptTpjxpzJlWeM0FbMMbBBVV2VPQhJZ3POs68Ir1y7
        zJs3zS0+gA6KL54dKTqTcBB+QukvumY=
X-Google-Smtp-Source: ABdhPJw4g2A98zCLpO81jyKWhIqIC1hF/ruVb/ReHX4/dUYQhCoUmVUalHAK2BPy/MmRHSovwhcPLg==
X-Received: by 2002:a17:902:bd84:: with SMTP id q4mr4537741pls.29.1596654268805;
        Wed, 05 Aug 2020 12:04:28 -0700 (PDT)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b15sm4071881pgk.14.2020.08.05.12.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 12:04:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: set ctx sq/cq entry count earlier
Date:   Wed,  5 Aug 2020 13:02:23 -0600
Message-Id: <20200805190224.401962-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805190224.401962-1-axboe@kernel.dk>
References: <20200805190224.401962-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we hit an earlier error path in io_uring_create(), then we will have
accounted memory, but not set ctx->{sq,cq}_entries yet. Then when the
ring is torn down in error, we use those values to unaccount the memory.

Ensure we set the ctx entries before we're able to hit a potential error
path.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8f96566603f3..0d857f7ca507 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8193,6 +8193,10 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
 
+	/* make sure these are sane, as we already accounted them */
+	ctx->sq_entries = p->sq_entries;
+	ctx->cq_entries = p->cq_entries;
+
 	size = rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
 	if (size == SIZE_MAX)
 		return -EOVERFLOW;
@@ -8209,8 +8213,6 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	rings->cq_ring_entries = p->cq_entries;
 	ctx->sq_mask = rings->sq_ring_mask;
 	ctx->cq_mask = rings->cq_ring_mask;
-	ctx->sq_entries = rings->sq_ring_entries;
-	ctx->cq_entries = rings->cq_ring_entries;
 
 	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
 	if (size == SIZE_MAX) {
-- 
2.28.0


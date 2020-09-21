Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D536272EA7
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgIUQvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727824AbgIUQuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:50:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492F8235FD;
        Mon, 21 Sep 2020 16:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707053;
        bh=KvX5wXLIlhZ1Q35VB8kcPfS7IDbO7lVnfvo3S3puKrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itq5xIbQIIJeEk6zBawz0DaYGDpmzVPDhmCjwoW7IZuN7OEICbpNtIpTENoVNU/sF
         /v9CjUQLM8LBpCu3dE0DNvAKbjWkmbxuTHlbR8u2xvcewXCAqEsP2krfeLm7ro/O0R
         m2TyVegDYgWXb/5rSLDb7s7kLfBCVay5jodCnkxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunghyun Jin <mcsmonk@gmail.com>,
        Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 5.4 60/72] percpu: fix first chunk size calculation for populated bitmap
Date:   Mon, 21 Sep 2020 18:31:39 +0200
Message-Id: <20200921163124.729592645@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunghyun Jin <mcsmonk@gmail.com>

commit b3b33d3c43bbe0177d70653f4e889c78cc37f097 upstream.

Variable populated, which is a member of struct pcpu_chunk, is used as a
unit of size of unsigned long.
However, size of populated is miscounted. So, I fix this minor part.

Fixes: 8ab16c43ea79 ("percpu: change the number of pages marked in the first_chunk pop bitmap")
Cc: <stable@vger.kernel.org> # 4.14+
Signed-off-by: Sunghyun Jin <mcsmonk@gmail.com>
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1328,7 +1328,7 @@ static struct pcpu_chunk * __init pcpu_a
 
 	/* allocate chunk */
 	alloc_size = sizeof(struct pcpu_chunk) +
-		BITS_TO_LONGS(region_size >> PAGE_SHIFT);
+		BITS_TO_LONGS(region_size >> PAGE_SHIFT) * sizeof(unsigned long);
 	chunk = memblock_alloc(alloc_size, SMP_CACHE_BYTES);
 	if (!chunk)
 		panic("%s: Failed to allocate %zu bytes\n", __func__,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3E4299DBA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438846AbgJ0AGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438301AbgJ0AFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:05:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2A120791;
        Tue, 27 Oct 2020 00:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757125;
        bh=J9kTvL2bi7kaYW/KLHW0zF/67DzEZv9l02GP1GNMzF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0LmgrM4JeLYjgUnUnmwqdc4HijmGb9fs+mb7gfHP1LKCq0IvJ/2wJ04Mn6UnUNPY
         yqE5JXOZXqJQwaYnvk0DKUBfRgMRGMtJMUGNBXw2ZZMwyNwp4XabEBn4G2fuhfoDeD
         jie8H210smP1qEjnXo2llqGeVqyRhG3byaqMigfg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 59/60] sgl_alloc_order: fix memory leak
Date:   Mon, 26 Oct 2020 20:04:14 -0400
Message-Id: <20201027000415.1026364-59-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

[ Upstream commit b2a182a40278bc5849730e66bca01a762188ed86 ]

sgl_alloc_order() can fail when 'length' is large on a memory
constrained system. When order > 0 it will potentially be
making several multi-page allocations with the later ones more
likely to fail than the earlier one. So it is important that
sgl_alloc_order() frees up any pages it has obtained before
returning NULL. In the case when order > 0 it calls the wrong
free page function and leaks. In testing the leak was
sufficient to bring down my 8 GiB laptop with OOM.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/scatterlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 60e7eca2f4bed..3b859201f84c6 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -506,7 +506,7 @@ struct scatterlist *sgl_alloc_order(unsigned long long length,
 		elem_len = min_t(u64, length, PAGE_SIZE << order);
 		page = alloc_pages(gfp, order);
 		if (!page) {
-			sgl_free(sgl);
+			sgl_free_order(sgl, order);
 			return NULL;
 		}
 
-- 
2.25.1


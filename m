Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3363131D9F
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfFANad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729670AbfFAN0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:26:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0375273B8;
        Sat,  1 Jun 2019 13:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395576;
        bh=W+mXVN4o7qdgu7foKIesICoUXtgOLDULDim6bbYHyBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qm01W1DEWjd/oBg3hjfXX+xFRoN+IvPJvvfCu3to2bTN8Ccmpj/BMLe7AORBjxlq+
         nNHG5KKUMdzM6PdTHzMJSZNcJjD44PbgYzEBEV23jOW/qJEN6FWy6AE7bpI3xxFQ/t
         QIappIyfV/FlnPYKlbFOA468bO/Jnv8r8+D6MSBw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yue Hu <huyue2@yulong.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>, Joe Perches <joe@perches.com>,
        David Rientjes <rientjes@google.com>,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.4 06/56] mm/cma_debug.c: fix the break condition in cma_maxchunk_get()
Date:   Sat,  1 Jun 2019 09:25:10 -0400
Message-Id: <20190601132600.27427-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

[ Upstream commit f0fd50504a54f5548eb666dc16ddf8394e44e4b7 ]

If not find zero bit in find_next_zero_bit(), it will return the size
parameter passed in, so the start bit should be compared with bitmap_maxno
rather than cma->count.  Although getting maxchunk is working fine due to
zero value of order_per_bit currently, the operation will be stuck if
order_per_bit is set as non-zero.

Link: http://lkml.kernel.org/r/20190319092734.276-1-zbestahu@gmail.com
Signed-off-by: Yue Hu <huyue2@yulong.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joe Perches <joe@perches.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Safonov <d.safonov@partner.samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/cma_debug.c b/mm/cma_debug.c
index f8e4b60db1672..da50dab56b700 100644
--- a/mm/cma_debug.c
+++ b/mm/cma_debug.c
@@ -57,7 +57,7 @@ static int cma_maxchunk_get(void *data, u64 *val)
 	mutex_lock(&cma->lock);
 	for (;;) {
 		start = find_next_zero_bit(cma->bitmap, bitmap_maxno, end);
-		if (start >= cma->count)
+		if (start >= bitmap_maxno)
 			break;
 		end = find_next_bit(cma->bitmap, bitmap_maxno, start);
 		maxchunk = max(end - start, maxchunk);
-- 
2.20.1


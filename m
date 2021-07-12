Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE503C538A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347996AbhGLHzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350465AbhGLHvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F90261A0F;
        Mon, 12 Jul 2021 07:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075941;
        bh=YhaXgfj0Yswh4IlY67IKXW1Q7ahkkEc1SL5DqEXsZU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emylzIDWz9OH7Di8jNuOgrw9l+8NiEtr8se4K54q5A551Zmw/UTNLnkBea0fEfVLw
         WVKDkODHfdKTRTewnQNnd7mNI5O5lmWoLGLmmUfcVlZoxV8MuUl7kIqphZ4w8XxALg
         sf3flvEQx7WuvrJllAhByYO+Z9J5EQovmgnj3xb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Shixin <liushixin2@huawei.com>,
        yangerkun <yangerkun@huawei.com>, Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 387/800] mm/page_alloc: fix counting of managed_pages
Date:   Mon, 12 Jul 2021 08:06:50 +0200
Message-Id: <20210712061008.399882550@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit f7ec104458e00d27a190348ac3a513f3df3699a4 ]

commit f63661566fad ("mm/page_alloc.c: clear out zone->lowmem_reserve[] if
the zone is empty") clears out zone->lowmem_reserve[] if zone is empty.
But when zone is not empty and sysctl_lowmem_reserve_ratio[i] is set to
zero, zone_managed_pages(zone) is not counted in the managed_pages either.
This is inconsistent with the description of lowmem_reserve, so fix it.

Link: https://lkml.kernel.org/r/20210527125707.3760259-1-liushixin2@huawei.com
Fixes: f63661566fad ("mm/page_alloc.c: clear out zone->lowmem_reserve[] if the zone is empty")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reported-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2bf03c76504b..fc5beebf6988 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8087,14 +8087,14 @@ static void setup_per_zone_lowmem_reserve(void)
 			unsigned long managed_pages = 0;
 
 			for (j = i + 1; j < MAX_NR_ZONES; j++) {
-				if (clear) {
-					zone->lowmem_reserve[j] = 0;
-				} else {
-					struct zone *upper_zone = &pgdat->node_zones[j];
+				struct zone *upper_zone = &pgdat->node_zones[j];
+
+				managed_pages += zone_managed_pages(upper_zone);
 
-					managed_pages += zone_managed_pages(upper_zone);
+				if (clear)
+					zone->lowmem_reserve[j] = 0;
+				else
 					zone->lowmem_reserve[j] = managed_pages / ratio;
-				}
 			}
 		}
 	}
-- 
2.30.2




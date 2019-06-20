Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0074D8D1
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfFTSCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbfFTSCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:02:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0D27204FD;
        Thu, 20 Jun 2019 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053755;
        bh=6wO+vFiS1LrwWSS8RoW5P5hLyxd6mGBhYKlxC1jwV7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNCTOH9KCW9iE/+vmo1NrUJVQhkBJn1FDklvdrrtsB7qonHAIisrUz+ikAxaRlfih
         R7SO+K1lXpaH+Y13PjNpaokEPhvPSWkM0wDJQzX/fIxMUp+woA//kpZ0LJvcknvdor
         G2Sj8V2RJigpfaBx8w7R7uJWYbsW8aLxd6VUfArI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yue Hu <huyue2@yulong.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <labbott@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 008/117] mm/cma.c: fix crash on CMA allocation if bitmap allocation fails
Date:   Thu, 20 Jun 2019 19:55:42 +0200
Message-Id: <20190620174352.485426267@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1df3a339074e31db95c4790ea9236874b13ccd87 ]

f022d8cb7ec7 ("mm: cma: Don't crash on allocation if CMA area can't be
activated") fixes the crash issue when activation fails via setting
cma->count as 0, same logic exists if bitmap allocation fails.

Link: http://lkml.kernel.org/r/20190325081309.6004-1-zbestahu@gmail.com
Signed-off-by: Yue Hu <huyue2@yulong.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index b5d8847497a3..4ea0f32761c1 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -100,8 +100,10 @@ static int __init cma_activate_area(struct cma *cma)
 
 	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
 
-	if (!cma->bitmap)
+	if (!cma->bitmap) {
+		cma->count = 0;
 		return -ENOMEM;
+	}
 
 	WARN_ON_ONCE(!pfn_valid(pfn));
 	zone = page_zone(pfn_to_page(pfn));
-- 
2.20.1




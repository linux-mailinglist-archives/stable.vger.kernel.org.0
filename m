Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9251F011
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732336AbfEOL36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfEOL3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:29:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5A74206BF;
        Wed, 15 May 2019 11:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919794;
        bh=A2HWa2eMV8cNpLlt3TpLLCMT1YnL9BzX46XVNAsJMbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsMIWM2qtrzIN07IT2uJdI7FyOpBP6H6AOeV1nvLrZ2mtWfJDEXkpZKxp2T9XkJXq
         e6qBs+exVuDuV9f0eSvuu2l1ZDqSzHzf78N/CawTx4O+Duq+s/C3YIGdfXVrEoVXEx
         ccYIQLhhRBHCUsJ1ZhZ+gsQrKOzo0vCb4eK3oZ+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 096/137] mm/page_alloc.c: avoid potential NULL pointer dereference
Date:   Wed, 15 May 2019 12:56:17 +0200
Message-Id: <20190515090700.506837533@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8139ad043d632c0e9e12d760068a7a8e91659aa1 ]

ac.preferred_zoneref->zone passed to alloc_flags_nofragment() can be NULL.
'zone' pointer unconditionally derefernced in alloc_flags_nofragment().
Bail out on NULL zone to avoid potential crash.  Currently we don't see
any crashes only because alloc_flags_nofragment() has another bug which
allows compiler to optimize away all accesses to 'zone'.

Link: http://lkml.kernel.org/r/20190423120806.3503-1-aryabinin@virtuozzo.com
Fixes: 6bb154504f8b ("mm, page_alloc: spread allocations across zones before introducing fragmentation")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eedb57f9b40b5..d59be95ba45cf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3385,6 +3385,9 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 		alloc_flags |= ALLOC_KSWAPD;
 
 #ifdef CONFIG_ZONE_DMA32
+	if (!zone)
+		return alloc_flags;
+
 	if (zone_idx(zone) != ZONE_NORMAL)
 		goto out;
 
-- 
2.20.1




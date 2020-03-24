Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6531910CA
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgCXNUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbgCXNUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:20:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DEA520870;
        Tue, 24 Mar 2020 13:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056037;
        bh=mb5sH4ljXlw3r8hOGeKmIv5E5UNFQ2DZexBOLnTxdFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRdLQY4xvH1GZm3yqnV6Rl+ZS8I5QTIN6M2ofRum7DdXKzDnwrmqn6ly0bAi5FmE4
         qcD89VduHnyEODnoq07ZxDgIPZsTmdCYTDJB+TbpGljQ0tV2/oRqh6d+H4/qOWFR5S
         t40WDjsvGzgL+tP+AasX2OvZzMop0YtaqDrbUAZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Chris Down <chris@chrisdown.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>,
        Michal Hocko <mhocko@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 085/102] mm, memcg: fix corruption on 64-bit divisor in memory.high throttling
Date:   Tue, 24 Mar 2020 14:11:17 +0100
Message-Id: <20200324130815.158734807@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Down <chris@chrisdown.name>

commit d397a45fc741c80c32a14e2de008441e9976f50c upstream.

Commit 0e4b01df8659 had a bunch of fixups to use the right division
method.  However, it seems that after all that it still wasn't right --
div_u64 takes a 32-bit divisor.

The headroom is still large (2^32 pages), so on mundane systems you
won't hit this, but this should definitely be fixed.

Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: <stable@vger.kernel.org>	[5.4.x+]
Link: http://lkml.kernel.org/r/80780887060514967d414b3cd91f9a316a16ab98.1584036142.git.chris@chrisdown.name
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2456,7 +2456,7 @@ void mem_cgroup_handle_over_high(void)
 	 */
 	clamped_high = max(high, 1UL);
 
-	overage = div_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
+	overage = div64_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
 			  clamped_high);
 
 	penalty_jiffies = ((u64)overage * overage * HZ)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63A2360CE0
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhDOOzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234284AbhDOOx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09B6B613D3;
        Thu, 15 Apr 2021 14:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498354;
        bh=hXjEIDFshVrp9ActqGejmA9MCrvITxzEh3EaBUalbZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoY6Fs5oo1HIee0SCMifJvQ0LtJeko2spUAMEFjytYnbEw1MKkMhXO4wLfKZJ62rl
         FKQn7DG928s3sTotHpjIQhRZRIufodveD9EILeVF3ZT2Ne36ERYkMUxzL6dtKdeOKe
         mYgMSDoSGad7btdVR/z48L42XYqkmAGByRuUOBXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chen si <cici.cs@alibaba-inc.com>,
        Baoyou Xie <baoyou.xie@aliyun.com>,
        Wen Yang <wenyang@linux.alibaba.com>,
        Zijiang Huang <zijiang.hzj@alibaba-inc.com>
Subject: [PATCH 4.9 27/47] mm: add cond_resched() in gather_pte_stats()
Date:   Thu, 15 Apr 2021 16:47:19 +0200
Message-Id: <20210415144414.326518538@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit a66c0410b97c07a5708881198528ce724f7a3226 upstream.

The other pagetable walks in task_mmu.c have a cond_resched() after
walking their ptes: add a cond_resched() in gather_pte_stats() too, for
reading /proc/<id>/numa_maps.  Only pagemap_pmd_range() has a
cond_resched() in its (unusually expensive) pmd_trans_huge case: more
should probably be added, but leave them unchanged for now.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1612052157400.13021@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Chen si <cici.cs@alibaba-inc.com>
Signed-off-by: Baoyou Xie <baoyou.xie@aliyun.com>
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Signed-off-by: Zijiang Huang <zijiang.hzj@alibaba-inc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1609,6 +1609,7 @@ static int gather_pte_stats(pmd_t *pmd,
 
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	pte_unmap_unlock(orig_pte, ptl);
+	cond_resched();
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE



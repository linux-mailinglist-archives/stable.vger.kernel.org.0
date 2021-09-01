Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670E93FDC01
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343758AbhIAMqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344774AbhIAMmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AE25611F2;
        Wed,  1 Sep 2021 12:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499879;
        bh=zSNr8kFULbCxxpVnhaNXWL9K+ZPAtemFX4ANnza/kRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhcIOcgbybiIkcLfvnhDnyadhSYa802I3KQPnyi2JUTcI5nF3q+nzN5jteMFjrVkZ
         h8S+hUdixGAKtx86w9qOSMfMbFXHoGOIKWXII4z3uaw+2RzmqyHMFtNmNfvpxCTUbT
         aqFYyaJVAPSFJQntnkZc2r65eDTkoh+vyR8jeFM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Chris Goldsworthy <cgoldswo@codeaurora.org>,
        Michal Hocko <mhocko@suse.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 019/113] mm/memory_hotplug: fix potential permanent lru cache disable
Date:   Wed,  1 Sep 2021 14:27:34 +0200
Message-Id: <20210901122302.620662880@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit 946746d1ad921e5f493b536533dda02ea22ca609 upstream.

If offline_pages failed after lru_cache_disable(), it forgot to do
lru_cache_enable() in error path.  So we would have lru cache disabled
permanently in this case.

Link: https://lkml.kernel.org/r/20210821094246.10149-3-linmiaohe@huawei.com
Fixes: d479960e44f2 ("mm: disable LRU pagevec during the migration temporarily")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1854,6 +1854,7 @@ failed_removal_isolated:
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 failed_removal_pcplists_disabled:
+	lru_cache_enable();
 	zone_pcp_enable(zone);
 failed_removal:
 	pr_debug("memory offlining [mem %#010llx-%#010llx] failed due to %s\n",



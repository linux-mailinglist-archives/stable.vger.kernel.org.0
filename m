Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205905A4C7
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 21:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfF1TGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 15:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfF1TGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 15:06:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5776214DA;
        Fri, 28 Jun 2019 19:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561748814;
        bh=8G8HpoMXEtMGzzRs6DPppJOc+SdR2PprWb3T1G7BPA4=;
        h=Date:From:To:Subject:From;
        b=psKbaHZGlvBKQ8m54AkcUqM9A7WQFuaA5edTPh8qERIGu1AuPCDlhOaCIUyJzilC2
         4mqcSmPI4SV2/OLkeqNEy5SD9ulHDvNxnpGCGpMngUfsCTrq0qtsxJRz7Hbh1vrd0m
         qP96gCOc8JP1CZ7OirxmI0Zcxf67Wr+B/2H6trd8=
Date:   Fri, 28 Jun 2019 12:06:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jerry.t.chen@intel.com,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        osalvador@suse.de, qiuxu.zhuo@intel.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, xishi.qiuxishi@alibaba-inc.com
Subject:  [patch 06/15] mm: soft-offline: return -EBUSY if
 set_hwpoison_free_buddy_page() fails
Message-ID: <20190628190653.XeH403wcK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: soft-offline: return -EBUSY if set_hwpoison_free_buddy_page() fails

The pass/fail of soft offline should be judged by checking whether the
raw error page was finally contained or not (i.e.  the result of
set_hwpoison_free_buddy_page()), but current code do not work like
that.  It might lead us to misjudge the test result when
set_hwpoison_free_buddy_page() fails.

Without this fix, there are cases where madvise(MADV_SOFT_OFFLINE) may
not offline the original page and will not return an error.

Link: http://lkml.kernel.org/r/1560154686-18497-2-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Fixes: 6bc9b56433b76 ("mm: fix race on soft-offlining")
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Xishi Qiu <xishi.qiuxishi@alibaba-inc.com>
Cc: "Chen, Jerry T" <jerry.t.chen@intel.com>
Cc: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Cc: <stable@vger.kernel.org>	[4.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-failure.c~mm-soft-offline-return-ebusy-if-set_hwpoison_free_buddy_page-fails
+++ a/mm/memory-failure.c
@@ -1730,6 +1730,8 @@ static int soft_offline_huge_page(struct
 		if (!ret) {
 			if (set_hwpoison_free_buddy_page(page))
 				num_poisoned_pages_inc();
+			else
+				ret = -EBUSY;
 		}
 	}
 	return ret;
_

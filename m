Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA0B2009F5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732450AbgFSNYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732317AbgFSNYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:24:35 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC2BC0613EE
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:33 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c12so7089094qtq.11
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sGfKJp4ceVzgkApCP2Azc9KEwo/q4w4TRc9Zm/9g19M=;
        b=FnzuwgfUJ752W8DEEDVpkI7TPwj3LPms3YeSSjugYkQcCEBSQ5ypkKThXa3Lu3x4tg
         QRPVunzsi9PlhXhT9o+ihXHpqPjz/27vw7k/5eKVVlUIfFGVijHn4CDITaTTdYO8SMpS
         Zp7mkHyNDfHt6ELaGyNOeWScTbHnBh08/at508lp6oCN/Pif23p3nEy3+iVpkDvkZQsN
         cvgZyYymJXu4VbRrpt81dwGUJEtjfG6H4Re2jiQyyguimlT0bcTI6FjE2rBlH+wcdcK3
         lv/YW576MoCZX68spKcFo8gJUza+QIpvOn0dFcqQT8RQYHm0OLTx7si5pYfK7g222W5C
         SDyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sGfKJp4ceVzgkApCP2Azc9KEwo/q4w4TRc9Zm/9g19M=;
        b=pXtFi1BzEdNFFfquq+RIrnfKJd9X7BetI1fIsrUvP+m8F1gWnti/o+WE+QT+g+Ryns
         8nuLaXuT81lZhsLUcsGLQpPb0o75sGOvQtqEvv0MCdOPeGwKgb7LgAl8uBWNrzX+Lr69
         Balw5cAD2EggCiiq0hU6xGK4jIyQvpeLvSMhRmOzHqIQo/Ppbt1n3LJA/A2CcbemgKPJ
         DHsmyc5S1V1Q5rnvVBwtwyZ/DY3s/lzirK776DIEwC1GCatk+GtCQ0QKOA4dbwAk0gbE
         83hQ5TJDORD2eC2019MVzMh8EGROe+KZYaicQfaH7Scnu8bAD/9Qw8TIDFvUE3aZ+yb7
         dUQw==
X-Gm-Message-State: AOAM5321HZyTiiopdRtJBFie849XBDbXr4FTfG3IN7A9h/MUU/brtlwJ
        bExffhQqlESDlbVqGziz9BMm6eSjnEQ=
X-Google-Smtp-Source: ABdhPJxBErblqGpqpmMoOei8l0bboCeKfczsPk11h7SNquV+E5iGIBSnBHQ2VRZk7TESSOwcTLqlRQ==
X-Received: by 2002:aed:2412:: with SMTP id r18mr3275367qtc.12.1592573072699;
        Fri, 19 Jun 2020 06:24:32 -0700 (PDT)
Received: from localhost.localdomain (c-73-69-118-222.hsd1.nh.comcast.net. [73.69.118.222])
        by smtp.gmail.com with ESMTPSA id m26sm7146268qtm.73.2020.06.19.06.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 06:24:32 -0700 (PDT)
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
To:     stable@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com,
        dan.j.williams@intel.com, shile.zhang@linux.alibaba.com,
        daniel.m.jordan@oracle.com, pasha.tatashin@soleen.com,
        ktkhai@virtuozzo.com, david@redhat.com, jmorris@namei.org,
        sashal@kernel.org, vbabka@suse.cz, gregkh@linuxfoundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH 4.19 4/7] mm/page_alloc.c: fix regression with deferred struct page init
Date:   Fri, 19 Jun 2020 09:24:22 -0400
Message-Id: <20200619132425.425063-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200619132425.425063-1-pasha.tatashin@soleen.com>
References: <20200619132425.425063-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

From: Juergen Gross <jgross@suse.com>

commit b9705d8778e7adc97de38f405f835a2426e14d84 upstream.

Commit 0e56acae4b4d ("mm: initialize MAX_ORDER_NR_PAGES at a time
instead of doing larger sections") is causing a regression on some
systems when the kernel is booted as Xen dom0.

The system will just hang in early boot.

Reason is an endless loop in get_page_from_freelist() in case the first
zone looked at has no free memory.  deferred_grow_zone() is always
returning true due to the following code snipplet:

  /* If the zone is empty somebody else may have cleared out the zone */
  if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
                                           first_deferred_pfn)) {
          pgdat->first_deferred_pfn = ULONG_MAX;
          pgdat_resize_unlock(pgdat, &flags);
          return true;
  }

This in turn results in the loop as get_page_from_freelist() is assuming
forward progress can be made by doing some more struct page
initialization.

Link: http://lkml.kernel.org/r/20190620160821.4210-1-jgross@suse.com
Fixes: 0e56acae4b4d ("mm: initialize MAX_ORDER_NR_PAGES at a time instead of doing larger sections")
Signed-off-by: Juergen Gross <jgross@suse.com>
Suggested-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a287d7a7dc33..2821e9824831 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1734,7 +1734,8 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 						 first_deferred_pfn)) {
 		pgdat->first_deferred_pfn = ULONG_MAX;
 		pgdat_resize_unlock(pgdat, &flags);
-		return true;
+		/* Retry only once. */
+		return first_deferred_pfn != ULONG_MAX;
 	}
 
 	/*
-- 
2.25.1


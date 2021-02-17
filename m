Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C8931D7FA
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 12:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhBQLKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 06:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbhBQLKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 06:10:14 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8D0C061574
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 03:09:33 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id s16so3322001plr.9
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 03:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hwGTtr8PmIo7rWztClElFUxqLDGuSV1ZfD6g3+Wx4Yc=;
        b=zopsdo3BDN8memTIrw5kskZi/1VXenbu9ThlVNrTHrZ1RWe/swJ+sLtNelhvjU/19K
         LEVB6+pCLR5/PV0A9ucb1urkjyU2jeBralOnBk7aktQOyDy+hXMCHFxAvLgyVDifXvcj
         kkuLQIBBjRFYH8bMnZSmwfH+jolL8Pfgu12vuxfQBoYnOk8YL6s9EiPTEzx09UPe4JUs
         HxCC5XMv5CJNaoFyJDdLVZPtZTx+B5eHGB5BSfT6VYmtteTdc/nQlChhjOyOg27jBgZg
         ekWjK1tKDuJrDc1YIA6USeOuPf+Hps13NXV14+sUQvkTIqapGDaswDD72/RrZLsFxunR
         Aemw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hwGTtr8PmIo7rWztClElFUxqLDGuSV1ZfD6g3+Wx4Yc=;
        b=rm/IT2FECUgrSPMT2NvDdNMcbPV2hn4EzaVnWCc097CDakFEGyy5wrQ0bDVX9ba8Oi
         FgkjhfF3nOwix89EPJ94OvUGLo3GZwh0wVOQ1tRN7O+zeWk51f4/03wzTetUIC+cxZPU
         zI9K8mrhEKh/ajTBXsj/Eya4RTo8pzLYPCtbwVUzZBgdBhioOKVOzI4pX1t1HME2QJLZ
         0wws5sPEr+iVTLONx1h9Aa8M7SufwMrj2lLMZutwOWBTRB2qvuG1zFtclnD5eLf08KuB
         wshTBcR0WC3bB78aG5hEVeMk43WHZFD3x6/qcrlVns6CMdN+0x5MqmhttRWV2l3skA3N
         C9Kg==
X-Gm-Message-State: AOAM530mPu/ngAvK8szXrOl2zkO9u+0pWe+HHvJknmmshD1Q555cOt78
        251NcwNoT+tKOqY/HdhkrIoQug==
X-Google-Smtp-Source: ABdhPJxwNMPXlaWMC7L52DKXm3NVj0MezOa0Ho/KAO7vXBaT4/STuiBmj4qM8bbBXfAWr25h79EnYg==
X-Received: by 2002:a17:90a:f2ce:: with SMTP id gt14mr8427254pjb.221.1613560173310;
        Wed, 17 Feb 2021 03:09:33 -0800 (PST)
Received: from localhost.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id m6sm1908339pjg.39.2021.02.17.03.09.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Feb 2021 03:09:32 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org
Cc:     cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: [PATCH v2] mm: memcontrol: fix swap undercounting in cgroup2
Date:   Wed, 17 Feb 2021 19:09:07 +0800
Message-Id: <20210217110907.85120-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When pages are swapped in, the VM may retain the swap copy to avoid
repeated writes in the future. It's also retained if shared pages are
faulted back in some processes, but not in others. During that time we
have an in-memory copy of the page, as well as an on-swap copy. Cgroup1
and cgroup2 handle these overlapping lifetimes slightly differently
due to the nature of how they account memory and swap:

Cgroup1 has a unified memory+swap counter that tracks a data page
regardless whether it's in-core or swapped out. On swapin, we transfer
the charge from the swap entry to the newly allocated swapcache page,
even though the swap entry might stick around for a while. That's why
we have a mem_cgroup_uncharge_swap() call inside mem_cgroup_charge().

Cgroup2 tracks memory and swap as separate, independent resources and
thus has split memory and swap counters. On swapin, we charge the
newly allocated swapcache page as memory, while the swap slot in turn
must remain charged to the swap counter as long as its allocated too.

The cgroup2 logic was broken by commit 2d1c498072de ("mm: memcontrol:
make swap tracking an integral part of memory control"), because it
accidentally removed the do_memsw_account() check in the branch inside
mem_cgroup_uncharge() that was supposed to tell the difference between
the charge transfer in cgroup1 and the separate counters in cgroup2.

As a result, cgroup2 currently undercounts retained swap to varying
degrees: swap slots are cached up to 50% of the configured limit or
total available swap space; partially faulted back shared pages are
only limited by physical capacity. This in turn allows cgroups to
significantly overconsume their alloted swap space.

Add the do_memsw_account() check back to fix this problem.

Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: stable@vger.kernel.org # 5.8+
---
 v2:
 - update commit log and add a comment to the code. Very thanks to Johannes.

 mm/memcontrol.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ed5cc78a8dbf..2efbb4f71d5f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6771,7 +6771,19 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 
-	if (PageSwapCache(page)) {
+	/*
+	 * Cgroup1's unified memory+swap counter has been charged with the
+	 * new swapcache page, finish the transfer by uncharging the swap
+	 * slot. The swap slot would also get uncharged when it dies, but
+	 * it can stick around indefinitely and we'd count the page twice
+	 * the entire time.
+	 *
+	 * Cgroup2 has separate resource counters for memory and swap,
+	 * so this is a non-issue here. Memory and swap charge lifetimes
+	 * correspond 1:1 to page and swap slot lifetimes: we charge the
+	 * page to memory here, and uncharge swap when the slot is freed.
+	 */
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && PageSwapCache(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 		/*
 		 * The swap entry might not get freed for a long time,
-- 
2.11.0


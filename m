Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB092EF54D
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 17:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbhAHP7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 10:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbhAHP7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 10:59:11 -0500
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63582C0612FD
        for <stable@vger.kernel.org>; Fri,  8 Jan 2021 07:58:31 -0800 (PST)
Received: by mail-ua1-x94a.google.com with SMTP id 61so3368118uat.13
        for <stable@vger.kernel.org>; Fri, 08 Jan 2021 07:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=TmS2aUSU9Nc+jbusxkpkx6bWx9vKLPLSx0ah1Mh9yyI=;
        b=MqO7QoO5t1t19B+AEl6h5z4tw+zU7KM6GwbNk/Mp1PFVGy9rfrtGYSbX/d9+eAzZhn
         85nVIeuPCcrIsHLF6pmDeiMskOl5gL8hrRpWLw2fiRK1XfHVrtlIhB3jtVuaOAuYAkX9
         y6PXWQyxwiovuUX4CqBWFUXWa2W+xhkln/xfwF05D6fSP6Ciqky7dTJuFFfn+UdmRkds
         KWeq7o1ESWlHIt80X8LW5vaHOnrLQeNZ4AhBLpgI54SeMWH/RtWLb2vuIH8DG7ux9OWT
         VZV7UjrCJGnJuc7mg18IjSCC1lMGzxZnMGNHFI+bg4cgIzRnzex0r+3is36+V51S9R/d
         SeWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=TmS2aUSU9Nc+jbusxkpkx6bWx9vKLPLSx0ah1Mh9yyI=;
        b=Fuz9F8jlZpRh1LxF5mhyGogwaVFy114Tm+2IYxICQixjob/bLRMW6JefprTLEdVMsA
         2Naa5RT1RgAS1tNEqU9b1IY7gBG0hk0aDvk5vKiGbRchcv4EnHTdPp1lceJPuackLB5O
         261Pglx5aIe7CMuesMmA6Y94FRTIn/S0pFLzNMwUsUgwD9eESVzthnZkFHALGQRR9dDf
         J/N6z8PQwERf1pe9Ngnjyu99hLh8ZjWjtfuVZrfXRrFKCG8pPL0uzkN2+WvLp9hbcOHe
         019puvxEickNvGT9myuxmbYYx+Fv2RHqwWbxTXTQ5i3976gc4lCZ/MUq+O9T7EPGp+Qo
         pBwg==
X-Gm-Message-State: AOAM532QNjWWF1gxo1o39zbRng1AKtNqSnZB1b5h1zx/qzw9LqgS3vmA
        xSScQPbI3KelCjFcHN0zZdUO7dVD7m4YUA==
X-Google-Smtp-Source: ABdhPJynj45gvGpcLiTW+x0xQm2G4v8WqiYUR+6AYBe2nYQlf67mjxvgOrcX3T27vNrGyNrdY/nPHbHkBhPcuQ==
Sender: "shakeelb via sendgmr" <shakeelb@shakeelb.svl.corp.google.com>
X-Received: from shakeelb.svl.corp.google.com ([100.116.77.44]) (user=shakeelb
 job=sendgmr) by 2002:a67:8d46:: with SMTP id p67mr3453396vsd.36.1610121510398;
 Fri, 08 Jan 2021 07:58:30 -0800 (PST)
Date:   Fri,  8 Jan 2021 07:58:11 -0800
Message-Id: <20210108155813.2914586-1-shakeelb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v2 1/3] mm: memcg: fix memcg file_dirty numa stat
From:   Shakeel Butt <shakeelb@google.com>
To:     Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
        Michal Hocko <mhocko@kernel.org>,
        Yang Shi <shy828301@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The kernel updates the per-node NR_FILE_DIRTY stats on page migration
but not the memcg numa stats. That was not an issue until recently the
commit 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface
for cgroup v2") exposed numa stats for the memcg. So fixing the
file_dirty per-memcg numa stat.

Fixes: 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface for cgroup v2")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
---
Changes since v1:
- none

 mm/migrate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ee5e612b4cd8..613794f6a433 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -500,9 +500,9 @@ int migrate_page_move_mapping(struct address_space *mapping,
 			__inc_lruvec_state(new_lruvec, NR_SHMEM);
 		}
 		if (dirty && mapping_can_writeback(mapping)) {
-			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
+			__dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
 			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
-			__inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
+			__inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
 			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
 		}
 	}
-- 
2.29.2.729.g45daf8777d-goog


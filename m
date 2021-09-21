Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82835412ECB
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 08:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhIUGsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 02:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhIUGsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 02:48:12 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C6CC061574;
        Mon, 20 Sep 2021 23:46:44 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g184so19813823pgc.6;
        Mon, 20 Sep 2021 23:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=43/hp4VQExTLsbhliy5N89vJ0RXPpk/KyGJWdBMOOTo=;
        b=Aobgto1h49ICsW2sQJKg4sxHIrcn0NSqvrHqFAPNssdRdeS3qlnhFC6cRct6kEy/rG
         rxiuOxLQxGOjjKxLuI5Wx09Aw7tGdhMxLx/kNoh9+T2FelZvLhcOAT7t57DuWGTu3gyY
         rLtTqMt/Ro1B5PZN7GM/SqpixOuR5bF6nCNhyrr/KvGi0bu2yM+fOhu11sb3ImMb6AgA
         rJX+GI9iKXNgoB5lVYAwm1CDeToFKp+jbPTFjh2SlfXpf7b7sUfi7Zpem69RPLiYwoC0
         v7KkPp5oivKVR/bv6L2oU+HcT+0s50AiIxKmsTZdrRmBcsFR05rus64+ldMtj5JD3qNB
         YGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=43/hp4VQExTLsbhliy5N89vJ0RXPpk/KyGJWdBMOOTo=;
        b=yxDGrz/RAN/eE4WpaUlhwiw9Mwa32QfKsBg/I2sfvwHX78LL0xh+1Q9AFmjsv1lrYS
         avzlx4SOWMUWeba9emmDhmUZ+kMsRbHHJ5eU8mm6Se9DG7Z8sz2UJNEBgC/qpoy+VoKG
         VIvFE4Vrl0++8UmzA3FbR8BcQ8g76zip9R07fZN84U+Cg+tmpXiOXsKe2nb8NUyqBnLo
         h9ChhFAXuqKHc7qNSgkk7YdNR16RrUk6W0GvoK+7KJ7sSM1jGBSRBvLJEg5pbY4YNRaX
         /zMsfY5FkfsGIhBge7LYLOrN5LoPXgqVgF+slDr4qrFsf0+HDYG2rUaOMQr0johZam/2
         3wyA==
X-Gm-Message-State: AOAM533/fw2/miN+oThby2sgOqYS5WNZUbZ0Tw1gL0SZAiP62hx+nul4
        cTe6qgSIzAph7xM2awqS+Mo=
X-Google-Smtp-Source: ABdhPJzYr4BkCmDCIjxtcBz4acKVq0vEB0vr9dlPgKsO6kXE5R1+heWRKItybhN/C5Q7hvYkReoidg==
X-Received: by 2002:a62:9242:0:b0:446:5771:7901 with SMTP id o63-20020a629242000000b0044657717901mr16597742pfd.81.1632206804402;
        Mon, 20 Sep 2021 23:46:44 -0700 (PDT)
Received: from ownia.. ([103.97.201.35])
        by smtp.gmail.com with ESMTPSA id a1sm1413101pjg.0.2021.09.20.23.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 23:46:44 -0700 (PDT)
From:   Weizhao Ouyang <o451686892@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Yang Shi <yang.shi@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Weizhao Ouyang <o451686892@gmail.com>,
        Mina Almasry <almasrymina@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Xu <weixugc@google.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/debug: sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN
Date:   Tue, 21 Sep 2021 14:45:52 +0800
Message-Id: <20210921064553.293905-2-o451686892@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210921064553.293905-1-o451686892@gmail.com>
References: <20210921064553.293905-1-o451686892@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sync up MR_CONTIG_RANGE and MR_LONGTERM_PIN to migrate_reason_names.

Fixes: 310253514bbf ("mm/migrate: rename migration reason MR_CMA to MR_CONTIG_RANGE")
Fixes: d1e153fea2a8 ("mm/gup: migrate pinned pages out of movable zone")
Cc: stable@vger.kernel.org
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
---
 mm/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/debug.c b/mm/debug.c
index e73fe0a8ec3d..e61037cded98 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -24,7 +24,8 @@ const char *migrate_reason_names[MR_TYPES] = {
 	"syscall_or_cpuset",
 	"mempolicy_mbind",
 	"numa_misplaced",
-	"cma",
+	"contig_range",
+	"longterm_pin",
 };
 
 const struct trace_print_flags pageflag_names[] = {
-- 
2.30.2


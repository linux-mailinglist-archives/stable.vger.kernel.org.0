Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44835B21B8
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 17:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiIHPML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 11:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbiIHPMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 11:12:10 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88392F3BC8;
        Thu,  8 Sep 2022 08:12:09 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u22so18151677plq.12;
        Thu, 08 Sep 2022 08:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date;
        bh=WTEnYhgiKJAuET4qXM31n3Y/m2shH8xT1rJc5+J4w+o=;
        b=k2iCThpjoS0TanZVq778BapywnMJI5bvQQqoZ3d5+dZRTFfMkoO83FOtpNE6bq0Bth
         LnQBWLebfOd0Q3br/HXGiIbRm5HeQAPra1cM8isN1S/mIcExZbFx49luyplDGeqnvYhq
         O+CMoPGZElpS5g8szOHjyWeqCNGZx5KNRiP2MweVu0ROsWuDeuIUAsjgdNu0pZxIGueZ
         3AwzyykoLxqHflHtHhUSGCfvyi0o23d+BoJ8/ocWMiuSsVWxtRUh8t9fOuoM/7zIouYS
         6EHowdI01SOyYNTxiUwRxpi81Qnqi1O+QRmW4gwNcC6tn/YasG5lVEnGu+nlnkphOQ98
         t68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date;
        bh=WTEnYhgiKJAuET4qXM31n3Y/m2shH8xT1rJc5+J4w+o=;
        b=O9Fvpymb470DqlhnXMFm+HGi/NopIt5CYas5R/00ahoK3jni44dTieM3eQqdNSng5f
         5Jo+CDEwDLOhTm14NenFXkavQ0pn4xlN9nxzz7P0gacayHIs1H/WyEFksQ4UB0ew1nQ8
         Btj7GhhsoFtw23rH1iWq2+eD6DOSvf46X7NrBQg+9yAYOfR/7E5dU9H6IzA3SKYu28Vp
         0pqxYX9HFbMJoP9OoAhsJmt/jHBHNBhh31OTeKUyAscndbMdyi7HiRG6m9XJJ9LdQsZj
         t6IpkgO/tyvnx/1kgIv3NXERamjWpGMUp4W8inP8ZzVHB4bxP/gfjZMaSdBZOmC4b5B/
         43tQ==
X-Gm-Message-State: ACgBeo1sgS1cgGOVbdOvzrmfjTj52Loy8oLyv3VHD4BcC6SmQbIlGQiw
        oBZTKeML2kJldHOJhUHAJ/E=
X-Google-Smtp-Source: AA6agR6kVmRW/WvjONhLO1yTPgQ3cRd7NJjoFpm8Vt5hLYcPnfHfjniQXT79HUCf3hOpwvblwdxUwA==
X-Received: by 2002:a17:902:d50d:b0:173:16a0:c226 with SMTP id b13-20020a170902d50d00b0017316a0c226mr9309130plg.160.1662649928937;
        Thu, 08 Sep 2022 08:12:08 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2620:15c:211:201:f7ba:3b54:b75a:9b87])
        by smtp.gmail.com with ESMTPSA id j5-20020a654305000000b004277f43b736sm12512817pgq.92.2022.09.08.08.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:12:08 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>, Minchan Kim <minchan@kernel.org>,
        =?UTF-8?q?=E9=9F=A9=E5=A4=A9=E7=A1=95?= <hantianshuo@iie.ac.cn>,
        Yang Shi <shy828301@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] mm: fix madivse_pageout mishandling on non-LRU page
Date:   Thu,  8 Sep 2022 08:12:04 -0700
Message-Id: <20220908151204.762596-1-minchan@kernel.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

MADV_PAGEOUT tries to isolate non-LRU pages and get the warning
from isolate_lru_page below.
Fix it with checking PageLRU in advance.

------------[ cut here ]------------
trying to isolate tail page
WARNING: CPU: 0 PID: 6175 at mm/folio-compat.c:158 isolate_lru_page+0x130/0x140
Modules linked in:
CPU: 0 PID: 6175 Comm: syz-executor.0 Not tainted 5.18.12 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:isolate_lru_page+0x130/0x140

Link: https://lore.kernel.org/linux-mm/485f8c33.2471b.182d5726afb.Coremail.hantianshuo@iie.ac.cn/
Reported-by: 韩天硕 <hantianshuo@iie.ac.cn>
Suggested-by: Yang Shi <shy828301@gmail.com>
Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")
Cc: stable@vger.kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Yang Shi <shy828301@gmail.com>
---
 mm/madvise.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 682e1d161aef..a3fc4cd32ed3 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -452,8 +452,11 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 		}
 
-		/* Do not interfere with other mappings of this page */
-		if (page_mapcount(page) != 1)
+		/*
+		 * Do not interfere with other mappings of this page and
+		 * non-LRU page.
+		 */
+		if (!PageLRU(page) || page_mapcount(page) != 1)
 			continue;
 
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
-- 
2.37.2.672.g94769d06f0-goog


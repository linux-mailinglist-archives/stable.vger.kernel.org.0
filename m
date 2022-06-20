Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5324A550E90
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 04:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbiFTCak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 22:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbiFTCaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 22:30:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C626BBC22
        for <stable@vger.kernel.org>; Sun, 19 Jun 2022 19:30:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y6so8531562plg.0
        for <stable@vger.kernel.org>; Sun, 19 Jun 2022 19:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rKDkCWFLL2LKHrd0PY7oJwJSwDpD2T5oprcITiH4OoM=;
        b=caQjzPuBIHwA2jjjyPgS+SZbXzK2In7vHfu7aUGNIa+U/C2FXhNA3dChQV+bWaMcPG
         7FlS2gMLACmKgYIq4Cw1zTdb3dP+si8wWFZJujAs2+n4ZdWgXCl0slFlOChKYG/fm1Yo
         nNGpEcLHuSYfPWoKClGZYjMWL/nz6ACorgOwJ1+S7jXI9N/gEVwENiHOwo8Tib8PlyqS
         ikEj1dZ27MGpqnNJ+1u0cCNmGqLMim/wVupR6XNaTcBIr4LFLQXuOFrkKkoI2App6+OX
         oarEM0yWQdccJgOLK+o6cEp/LX/iKe+L3kccp6rOvoUVdwwN9mx11+k0RgFN0y9iDfu/
         oTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rKDkCWFLL2LKHrd0PY7oJwJSwDpD2T5oprcITiH4OoM=;
        b=N/RT6ccdO4YwjwSu3qvkhgJ+4VqxfszRGO2TeyDnhMKl+DivwM7Jd9FpZNx+Gt8WTC
         UpRfFggviIjM7JvitMFsFUV1KEQsJRlNnd/11+SXGALGPz/fW+aE2XszlrwE2tlCuoy2
         1JavzFnPU3xl2lvVP+tJY5JWty+psHBQ2yXEpTwkak8IDycU75qClhPRKzF0T6OGI+fB
         B6DfPQ5spxj3GMobi88x588iMQmabxlqKAYdhrQ5woUTDS+OrIe47BFOdKh2I1XYA71I
         WiZygT3XurzANTbhZeCb/v9KIxG0mBZUWEr/U+n2e2Dug5irpZVw03xpFyf/HLqzvHEp
         hk1w==
X-Gm-Message-State: AJIora9QVUJxCp4yfB9A9MiVHbSZNr8yqK5sNikrcv1g1Ugao0vkNAR5
        aiacUW6vr8VqEVReIXS6MQ9hlw==
X-Google-Smtp-Source: AGRyM1tG7Y4Ri55cxJYS8evvg2vI5g0ekaQOzL/vT2Lew/EEVtV27PGqa1e/oIscRqU39mMZiRtzsg==
X-Received: by 2002:a17:903:2291:b0:164:95f:b512 with SMTP id b17-20020a170903229100b00164095fb512mr21978303plh.120.1655692238298;
        Sun, 19 Jun 2022 19:30:38 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id z7-20020a17090a8b8700b001ecb29de3e4sm153644pjn.49.2022.06.19.19.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 19:30:38 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     akpm@linux-foundation.org, mike.kravetz@oracle.com
Cc:     duanxiongchun@bytedance.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH] mm: sparsemem: fix missing higher order allocation splitting
Date:   Mon, 20 Jun 2022 10:30:19 +0800
Message-Id: <20220620023019.94257-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Higher order allocations for vmemmap pages from buddy allocator must be
able to be treated as indepdenent small pages as they can be freed
individually by the caller.  There is no problem for higher order vmemmap
pages allocated at boot time since each individual small page will be
initialized at boot time.  However, it will be an issue for memory hotplug
case since those higher order vmemmap pages are allocated from buddy
allocator without initializing each individual small page's refcount. The
system will panic in put_page_testzero() when CONFIG_DEBUG_VM is enabled
if the vmemmap page is freed.

Fixes: d8d55f5616cf ("mm: sparsemem: use page table lock to protect kernel pmd operations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 652f11a05749..ebb489fcf07c 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -78,6 +78,14 @@ static int __split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
 
 	spin_lock(&init_mm.page_table_lock);
 	if (likely(pmd_leaf(*pmd))) {
+		/*
+		 * Higher order allocations from buddy allocator must be able to
+		 * be treated as indepdenent small pages (as they can be freed
+		 * individually).
+		 */
+		if (!PageReserved(page))
+			split_page(page, get_order(PMD_SIZE));
+
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
-- 
2.11.0


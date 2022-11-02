Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C2161582B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiKBCq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiKBCqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:46:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F5921241
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:46:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DC66B82075
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC6BC433D6;
        Wed,  2 Nov 2022 02:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357182;
        bh=Qg9lWVXq7yJb7vVPri8TU1sffzvuAUBOyLMcgv0X2I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aI07km4AyPUG+Xr5FQJNlph1P/9Z1Wh0anK623KhZ+LzUn3HLM6+uP/m3eXm5ilNr
         76LX0bX/RsfkEU/uLZwyyTbohkN51nNvTYsL8N6eKbjqW8h5aXdetwCYlsrsncGPvS
         yegPYjmqh1qWPq72zTn8MmwgHJaLLyVk5eUV9p6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Yang Shi <shy828301@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>, Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 088/240] mm: migrate: fix return value if all subpages of THPs are migrated successfully
Date:   Wed,  2 Nov 2022 03:31:03 +0100
Message-Id: <20221102022113.388362601@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit 03e5f82ea632af329e32ec03d952b2d99497eeaa upstream.

During THP migration, if THPs are not migrated but they are split and all
subpages are migrated successfully, migrate_pages() will still return the
number of THP pages that were not migrated.  This will confuse the callers
of migrate_pages().  For example, the longterm pinning will failed though
all pages are migrated successfully.

Thus we should return 0 to indicate that all pages are migrated in this
case

Link: https://lkml.kernel.org/r/de386aa864be9158d2f3b344091419ea7c38b2f7.1666599848.git.baolin.wang@linux.alibaba.com
Fixes: b5bade978e9b ("mm: migrate: fix the return value of migrate_pages()")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1558,6 +1558,13 @@ out:
 	 */
 	list_splice(&ret_pages, from);
 
+	/*
+	 * Return 0 in case all subpages of fail-to-migrate THPs are
+	 * migrated successfully.
+	 */
+	if (list_empty(from))
+		rc = 0;
+
 	count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
 	count_vm_events(PGMIGRATE_FAIL, nr_failed_pages);
 	count_vm_events(THP_MIGRATION_SUCCESS, nr_thp_succeeded);



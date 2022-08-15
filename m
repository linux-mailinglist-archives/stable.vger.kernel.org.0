Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0476594C8E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244929AbiHPBAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348626AbiHPA5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:57:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01411DB062;
        Mon, 15 Aug 2022 13:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D766F6126A;
        Mon, 15 Aug 2022 20:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B31C433C1;
        Mon, 15 Aug 2022 20:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596547;
        bh=k/jl+hiL7h61ReI0pIPxD1nbi8Tvs1yvqiCnRfOIhME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4eJBWPuxbY6xpQiElASrl8zB3WSnD6nxoCC52+oBIVqfJPb7CJ4tMM+4buR8Z1Lc
         SebwG13sPfQQ+bxOm7X24z83lMcmLaZNqnXRf9gt0RXUNP75YKKc8/2z54UWk1iWgj
         2zuL6ist79J2c1hnU7K7C2R3YDDWWT0GAZvsyPIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Kees Cook <keescook@chromium.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mina Almasry <almasrymina@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1113/1157] hugetlb_cgroup: fix wrong hugetlb cgroup numa stat
Date:   Mon, 15 Aug 2022 20:07:49 +0200
Message-Id: <20220815180524.831965088@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 2727cfe4072a35ce813e3708f74c135de7da8897 ]

We forget to set cft->private for numa stat file.  As a result, numa stat
of hstates[0] is always showed for all hstates.  Encode the hstates index
into cft->private to fix this issue.

Link: https://lkml.kernel.org/r/20220723073804.53035-1-linmiaohe@huawei.com
Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb_cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index f9942841df18..c86691c431fd 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -772,6 +772,7 @@ static void __init __hugetlb_cgroup_file_dfl_init(int idx)
 	/* Add the numa stat file */
 	cft = &h->cgroup_files_dfl[6];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.numa_stat", buf);
+	cft->private = MEMFILE_PRIVATE(idx, 0);
 	cft->seq_show = hugetlb_cgroup_read_numa_stat;
 	cft->flags = CFTYPE_NOT_ON_ROOT;
 
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A48B54933E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242215AbiFMKTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242977AbiFMKS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:18:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FDCDF7A;
        Mon, 13 Jun 2022 03:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 555F5CE1166;
        Mon, 13 Jun 2022 10:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F16C34114;
        Mon, 13 Jun 2022 10:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115390;
        bh=CD9dILorBqE+9Fufp4BbNE1cyEAiGST6p5QIRyxJzos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKRSPP7sP2FZUn2W+KKcqBf3LLK2KY3gWsTHfv7jPssVcK1gz4q5r5Dnm14RwdMr8
         0MwgKCMYvSIByo7Uk6N9FmI3LPfL1LQgd20pvTkfkrwbVFAysrm7s0ZiBkApDkLlaj
         hF8goq2C2S/q7/seYuqOQ5tyGJC6TK6sO3nqvm8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 067/167] drivers/base/node.c: fix compaction sysfs file leak
Date:   Mon, 13 Jun 2022 12:09:01 +0200
Message-Id: <20220613094856.623504892@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit da63dc84befaa9e6079a0bc363ff0eaa975f9073 ]

Compaction sysfs file is created via compaction_register_node in
register_node.  But we forgot to remove it in unregister_node.  Thus
compaction sysfs file is leaked.  Using compaction_unregister_node to fix
this issue.

Link: https://lkml.kernel.org/r/20220401070905.43679-1-linmiaohe@huawei.com
Fixes: ed4a6d7f0676 ("mm: compaction: add /sys trigger for per-node memory compaction")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/node.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 5548f9686016..7f9126633080 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -315,6 +315,7 @@ static int register_node(struct node *node, int num, struct node *parent)
  */
 void unregister_node(struct node *node)
 {
+	compaction_unregister_node(node);
 	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
 
 	device_unregister(&node->dev);
-- 
2.35.1




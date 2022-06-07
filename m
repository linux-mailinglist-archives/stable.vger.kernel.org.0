Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F449541CB3
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382459AbiFGWEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382442AbiFGWDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:03:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A9024F979;
        Tue,  7 Jun 2022 12:14:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23C85B822C0;
        Tue,  7 Jun 2022 19:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A633C341C0;
        Tue,  7 Jun 2022 19:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629285;
        bh=ZBQ4EFzhN4RnMkuYCNB/HRS9XOCUG2rEa2pgGyuxLhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsjPHNy+g8ZPKqVq0mayJ2K4RCliPqjVNz5e4GUQpzLO3iW84/udeMOzjcJhDES+k
         wyBSEeamRy09EvFxwGsSMGLVCxTd3uf2IoEdNgyLQTkbwWwTxY1AM2hsQn86fiIvGF
         2vvDbMdQiNVfRbVIW3RroqB/ZruAEe7eOZ0Nn2IY=
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
Subject: [PATCH 5.18 595/879] drivers/base/node.c: fix compaction sysfs file leak
Date:   Tue,  7 Jun 2022 19:01:53 +0200
Message-Id: <20220607165020.123481067@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index ec8bb24a5a22..0ac6376ef7a1 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -682,6 +682,7 @@ static int register_node(struct node *node, int num)
  */
 void unregister_node(struct node *node)
 {
+	compaction_unregister_node(node);
 	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
 	node_remove_accesses(node);
 	node_remove_caches(node);
-- 
2.35.1




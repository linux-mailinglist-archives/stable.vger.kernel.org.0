Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5459488D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352969AbiHOXJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353278AbiHOXHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC7D1436DB;
        Mon, 15 Aug 2022 12:59:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F25161226;
        Mon, 15 Aug 2022 19:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFB5C433C1;
        Mon, 15 Aug 2022 19:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593579;
        bh=Pz3tTLwJMRiGBif8JSeF3IXDhjB3n2Y2I1XT1uepea8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyU8inuhFUktWzkC9CLUQ2lMejzQuLOELO+ji1mo1NEdqGsAS7dJuLcABOIhhk2a4
         e6yG9bLvf0YEYZtFYDvDJb7CwR7gO278yLfb0//k5S48fD9+oiB64PXHYjg4AWp/Aa
         JpuFmpffUt37I1SH0uhGufKUqtR9Onp47X/KYZlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0291/1157] sched/numa: Initialise numa_migrate_retry
Date:   Mon, 15 Aug 2022 19:54:07 +0200
Message-Id: <20220815180451.263889074@linuxfoundation.org>
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

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit 70ce3ea9aa4ed901c8a90de667df5ef307766e71 ]

On clone, numa_migrate_retry is inherited from the parent which means
that the first NUMA placement of a task is non-deterministic. This
affects when load balancing recognises numa tasks and whether to
migrate "regular", "remote" or "all" tasks between NUMA scheduler
domains.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20220520103519.1863-2-mgorman@techsingularity.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9d6058b0a3d4..0cba1b2e295b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2885,6 +2885,7 @@ void init_numa_balancing(unsigned long clone_flags, struct task_struct *p)
 	p->node_stamp			= 0;
 	p->numa_scan_seq		= mm ? mm->numa_scan_seq : 0;
 	p->numa_scan_period		= sysctl_numa_balancing_scan_delay;
+	p->numa_migrate_retry		= 0;
 	/* Protect against double add, see task_tick_numa and task_numa_work */
 	p->numa_work.next		= &p->numa_work;
 	p->numa_faults			= NULL;
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD8E2171A4
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgGGPXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729941AbgGGPXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 435A5206F6;
        Tue,  7 Jul 2020 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135386;
        bh=gd92U56RmoV99eATKd4qvxZYYmO56fFyB+M5e7f5O3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3YBIg9VLYuXYEmaeU3uozl2TJozPSU8j9kqwfiHj/CU8OqiwkWIeckETrsn5rj5X
         6GHvYgsHeoWPhZ8M+OAh+Gft9FmGUrqVZbvxmHf5q279BR+Hyuof7VKhObAWNa5/1C
         0Wo7uhJ4PFZ+tcROSB+6g7irxFdJSZNkRVP6DCu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 020/112] sched/debug: Make sd->flags sysctl read-only
Date:   Tue,  7 Jul 2020 17:16:25 +0200
Message-Id: <20200707145801.948953381@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 9818427c6270a9ce8c52c8621026fe9cebae0f92 ]

Writing to the sysctl of a sched_domain->flags directly updates the value of
the field, and goes nowhere near update_top_cache_domain(). This means that
the cached domain pointers can end up containing stale data (e.g. the
domain pointed to doesn't have the relevant flag set anymore).

Explicit domain walks that check for flags will be affected by
the write, but this won't be in sync with the cached pointers which will
still point to the domains that were cached at the last sched_domain
build.

In other words, writing to this interface is playing a dangerous game. It
could be made to trigger an update of the cached sched_domain pointers when
written to, but this does not seem to be worth the trouble. Make it
read-only.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200415210512.805-3-valentin.schneider@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 239970b991c03..0f4aaad236a9d 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -258,7 +258,7 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 	set_table_entry(&table[2], "busy_factor",	  &sd->busy_factor,	    sizeof(int),  0644, proc_dointvec_minmax);
 	set_table_entry(&table[3], "imbalance_pct",	  &sd->imbalance_pct,	    sizeof(int),  0644, proc_dointvec_minmax);
 	set_table_entry(&table[4], "cache_nice_tries",	  &sd->cache_nice_tries,    sizeof(int),  0644, proc_dointvec_minmax);
-	set_table_entry(&table[5], "flags",		  &sd->flags,		    sizeof(int),  0644, proc_dointvec_minmax);
+	set_table_entry(&table[5], "flags",		  &sd->flags,		    sizeof(int),  0444, proc_dointvec_minmax);
 	set_table_entry(&table[6], "max_newidle_lb_cost", &sd->max_newidle_lb_cost, sizeof(long), 0644, proc_doulongvec_minmax);
 	set_table_entry(&table[7], "name",		  sd->name,	       CORENAME_MAX_SIZE, 0444, proc_dostring);
 	/* &table[8] is terminator */
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5144A9673
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357889AbiBDJ0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:26:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52988 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357893AbiBDJYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:24:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9F64B836B9;
        Fri,  4 Feb 2022 09:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1935C004E1;
        Fri,  4 Feb 2022 09:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966680;
        bh=T+sqZCVEkJgNnFO9Rhbjhdo7Xu1WOs9myTQYJ5/K0XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZgpZylJAQLUqmhaI1FDf9MUv+Toh7UOiRBdx/ctR6Ys5n3qBE6Hm+IjSDhPqTkZd
         MoSjiH99BATi0ARacYGDkhbYov9MDbTSBBt/efJpSuNUHJBKmLedDXyBW+pcbhV/rG
         vx/12BA3RdD4FWYDdJjTqfukRvXpCFJKtYxd8UhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianchen Ding <dtcccc@linux.alibaba.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.15 29/32] cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpumask()
Date:   Fri,  4 Feb 2022 10:22:39 +0100
Message-Id: <20220204091916.214992004@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianchen Ding <dtcccc@linux.alibaba.com>

commit c80d401c52a2d1baf2a5afeb06f0ffe678e56d23 upstream.

subparts_cpus should be limited as a subset of cpus_allowed, but it is
updated wrongly by using cpumask_andnot(). Use cpumask_and() instead to
fix it.

Fixes: ee8dde0cd2ce ("cpuset: Add new v2 cpuset.sched.partition flag")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1597,8 +1597,7 @@ static int update_cpumask(struct cpuset
 	 * Make sure that subparts_cpus is a subset of cpus_allowed.
 	 */
 	if (cs->nr_subparts_cpus) {
-		cpumask_andnot(cs->subparts_cpus, cs->subparts_cpus,
-			       cs->cpus_allowed);
+		cpumask_and(cs->subparts_cpus, cs->subparts_cpus, cs->cpus_allowed);
 		cs->nr_subparts_cpus = cpumask_weight(cs->subparts_cpus);
 	}
 	spin_unlock_irq(&callback_lock);



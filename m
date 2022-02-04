Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0404A96BE
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbiBDJ3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358166AbiBDJ1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:27:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F54C061397;
        Fri,  4 Feb 2022 01:26:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B7BFB836EE;
        Fri,  4 Feb 2022 09:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CFBC004E1;
        Fri,  4 Feb 2022 09:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966787;
        bh=Hs1XBgBwYzOagplRloPnUlsaIUvnsyTiuejMIw75644=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYnfEmvlnExLFTfGR41w6+Gz04y2KBrRdeULNNygbq8H2jvZ2bFGfLjpYdioiLKUY
         FfDDL9ZN/q1DE0egjvnMia7AGeGIVgL8BpDssi2fPiWbCk16iVtbIKWJcXVe8aYEBB
         UC75ey4NeRhiCZ53+ogUvze1PFlg26e8lUV8/hSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianchen Ding <dtcccc@linux.alibaba.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.16 39/43] cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpumask()
Date:   Fri,  4 Feb 2022 10:22:46 +0100
Message-Id: <20220204091918.433886374@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
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
@@ -1615,8 +1615,7 @@ static int update_cpumask(struct cpuset
 	 * Make sure that subparts_cpus is a subset of cpus_allowed.
 	 */
 	if (cs->nr_subparts_cpus) {
-		cpumask_andnot(cs->subparts_cpus, cs->subparts_cpus,
-			       cs->cpus_allowed);
+		cpumask_and(cs->subparts_cpus, cs->subparts_cpus, cs->cpus_allowed);
 		cs->nr_subparts_cpus = cpumask_weight(cs->subparts_cpus);
 	}
 	spin_unlock_irq(&callback_lock);



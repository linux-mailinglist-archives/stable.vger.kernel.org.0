Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8340B68D828
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjBGNHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbjBGNHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDC13A867
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:06:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15FC261425
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8D4C433B0;
        Tue,  7 Feb 2023 13:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775125;
        bh=YtQGz6Qkk7Rhtb13J/VzPJf5PK5xPLZhaeoyma7KvbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9ZLwXD/XppcDnVT2DcT1q+ERoypvw5tTNhUURcaFVpXCy6O6jtx0+ZF+z+4VMsOx
         Zisjq9Q8RO1HTdGH1Nii0DP0bErEJzExziiHtQ9suCDdeGtnFpOryXwvXFWVuUUqH7
         7h0tyVcSAdAzCJC2CYVudg9FhizCvOYfe0w3g/WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.1 116/208] cgroup/cpuset: Fix wrong check in update_parent_subparts_cpumask()
Date:   Tue,  7 Feb 2023 13:56:10 +0100
Message-Id: <20230207125639.646526721@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit e5ae8803847b80fe9d744a3174abe2b7bfed222a upstream.

It was found that the check to see if a partition could use up all
the cpus from the parent cpuset in update_parent_subparts_cpumask()
was incorrect. As a result, it is possible to leave parent with no
effective cpu left even if there are tasks in the parent cpuset. This
can lead to system panic as reported in [1].

Fix this probem by updating the check to fail the enabling the partition
if parent's effective_cpus is a subset of the child's cpus_allowed.

Also record the error code when an error happens in update_prstate()
and add a test case where parent partition and child have the same cpu
list and parent has task. Enabling partition in the child will fail in
this case.

[1] https://www.spinics.net/lists/cgroups/msg36254.html

Fixes: f0af1bfc27b5 ("cgroup/cpuset: Relax constraints to partition & cpus changes")
Cc: stable@vger.kernel.org # v6.1
Reported-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c                            |    3 ++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1342,7 +1342,7 @@ static int update_parent_subparts_cpumas
 		 * A parent can be left with no CPU as long as there is no
 		 * task directly associated with the parent partition.
 		 */
-		if (!cpumask_intersects(cs->cpus_allowed, parent->effective_cpus) &&
+		if (cpumask_subset(parent->effective_cpus, cs->cpus_allowed) &&
 		    partition_is_populated(parent, cs))
 			return PERR_NOCPUS;
 
@@ -2320,6 +2320,7 @@ out:
 		new_prs = -new_prs;
 	spin_lock_irq(&callback_lock);
 	cs->partition_root_state = new_prs;
+	WRITE_ONCE(cs->prs_err, err);
 	spin_unlock_irq(&callback_lock);
 	/*
 	 * Update child cpusets, if present.
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -254,6 +254,7 @@ TEST_MATRIX=(
 	# Taking away all CPUs from parent or itself if there are tasks
 	# will make the partition invalid.
 	"  S+ C2-3:P1:S+  C3:P1  .      .      T     C2-3    .      .     0 A1:2-3,A2:2-3 A1:P1,A2:P-1"
+	"  S+  C3:P1:S+    C3    .      .      T      P1     .      .     0 A1:3,A2:3 A1:P1,A2:P-1"
 	"  S+ $SETUP_A123_PARTITIONS    .    T:C2-3   .      .      .     0 A1:2-3,A2:2-3,A3:3 A1:P1,A2:P-1,A3:P-1"
 	"  S+ $SETUP_A123_PARTITIONS    . T:C2-3:C1-3 .      .      .     0 A1:1,A2:2,A3:3 A1:P1,A2:P1,A3:P1"
 



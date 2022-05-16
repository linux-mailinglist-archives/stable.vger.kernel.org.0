Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CE252902C
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346758AbiEPTzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347041AbiEPTvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:51:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A661C2BE;
        Mon, 16 May 2022 12:46:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDAB66090A;
        Mon, 16 May 2022 19:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85D1C385AA;
        Mon, 16 May 2022 19:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730409;
        bh=l1YRXbzOl70qUmjhLtrNV8LXStjBXzUbJl3cW6rDt9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhjAKvFE7PTj1IXG5U8dKvulCDtq75ewTTIV1kyhxVPDlcTkSL65V+xHwGvhnH9NI
         7nSm8HAtswIqXv5Eb5Rp5l/iX9L4Lr3zljQBjJS/CwAgxYwMfxEikrkWRtezh5c2V3
         xz0SB1KxNpEMXq4STe2rcoh+RDi6DIcCwukC0nfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 56/66] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()
Date:   Mon, 16 May 2022 21:36:56 +0200
Message-Id: <20220516193621.031757381@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,TVD_SUBJ_WIPE_DEBT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit 2685027fca387b602ae565bff17895188b803988 upstream.

There are 3 places where the cpu and node masks of the top cpuset can
be initialized in the order they are executed:
 1) start_kernel -> cpuset_init()
 2) start_kernel -> cgroup_init() -> cpuset_bind()
 3) kernel_init_freeable() -> do_basic_setup() -> cpuset_init_smp()

The first cpuset_init() call just sets all the bits in the masks.
The second cpuset_bind() call sets cpus_allowed and mems_allowed to the
default v2 values. The third cpuset_init_smp() call sets them back to
v1 values.

For systems with cgroup v2 setup, cpuset_bind() is called once.  As a
result, cpu and memory node hot add may fail to update the cpu and node
masks of the top cpuset to include the newly added cpu or node in a
cgroup v2 environment.

For systems with cgroup v1 setup, cpuset_bind() is called again by
rebind_subsystem() when the v1 cpuset filesystem is mounted as shown
in the dmesg log below with an instrumented kernel.

  [    2.609781] cpuset_bind() called - v2 = 1
  [    3.079473] cpuset_init_smp() called
  [    7.103710] cpuset_bind() called - v2 = 0

smp_init() is called after the first two init functions.  So we don't
have a complete list of active cpus and memory nodes until later in
cpuset_init_smp() which is the right time to set up effective_cpus
and effective_mems.

To fix this cgroup v2 mask setup problem, the potentially incorrect
cpus_allowed & mems_allowed setting in cpuset_init_smp() are removed.
For cgroup v2 systems, the initial cpuset_bind() call will set the masks
correctly.  For cgroup v1 systems, the second call to cpuset_bind()
will do the right setup.

cc: stable@vger.kernel.org
Signed-off-by: Waiman Long <longman@redhat.com>
Tested-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3301,8 +3301,11 @@ static struct notifier_block cpuset_trac
  */
 void __init cpuset_init_smp(void)
 {
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_MEMORY];
+	/*
+	 * cpus_allowd/mems_allowed set to v2 values in the initial
+	 * cpuset_bind() call will be reset to v1 values in another
+	 * cpuset_bind() call when v1 cpuset is mounted.
+	 */
 	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
 
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0B64C75C3
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbiB1R4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240760AbiB1Rye (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF32B517FB;
        Mon, 28 Feb 2022 09:43:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A2986066C;
        Mon, 28 Feb 2022 17:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB0CC340E7;
        Mon, 28 Feb 2022 17:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070186;
        bh=zDYCCP6XlbqDA7HQmF4fkp/z4EVHh+jJNhPF7P1qHN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8eYZc5DU+bZEjcysKDPGbmft1VKcLf3lSj3fj0xhLiIHka4syx3g/eEFYUIQqBDr
         LPpK++uNheyi5ETcE3RWLgmZsoN9iVWLHo8ZlnbaWW3LwbdadRYMKAgI7scP/V1vxJ
         DUNVF5JpqnVgwKCjQ6yKPRK1ID/UHcbEk/vgSIR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhao Gongyi <zhaogongyi@huawei.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        Waiman Long <longman@redhat.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.16 002/164] cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug
Date:   Mon, 28 Feb 2022 18:22:44 +0100
Message-Id: <20220228172359.834952202@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qiao <zhangqiao22@huawei.com>

commit 05c7b7a92cc87ff8d7fde189d0fade250697573c upstream.

As previously discussed(https://lkml.org/lkml/2022/1/20/51),
cpuset_attach() is affected with similar cpu hotplug race,
as follow scenario:

     cpuset_attach()				cpu hotplug
    ---------------------------            ----------------------
    down_write(cpuset_rwsem)
    guarantee_online_cpus() // (load cpus_attach)
					sched_cpu_deactivate
					  set_cpu_active()
					  // will change cpu_active_mask
    set_cpus_allowed_ptr(cpus_attach)
      __set_cpus_allowed_ptr_locked()
       // (if the intersection of cpus_attach and
         cpu_active_mask is empty, will return -EINVAL)
    up_write(cpuset_rwsem)

To avoid races such as described above, protect cpuset_attach() call
with cpu_hotplug_lock.

Fixes: be367d099270 ("cgroups: let ss->can_attach and ss->attach do whole threadgroups at a time")
Cc: stable@vger.kernel.org # v2.6.32+
Reported-by: Zhao Gongyi <zhaogongyi@huawei.com>
Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
Acked-by: Waiman Long <longman@redhat.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2269,6 +2269,7 @@ static void cpuset_attach(struct cgroup_
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
+	cpus_read_lock();
 	percpu_down_write(&cpuset_rwsem);
 
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
@@ -2322,6 +2323,7 @@ static void cpuset_attach(struct cgroup_
 		wake_up(&cpuset_attach_wq);
 
 	percpu_up_write(&cpuset_rwsem);
+	cpus_read_unlock();
 }
 
 /* The various types of files and directories in a cpuset file system */



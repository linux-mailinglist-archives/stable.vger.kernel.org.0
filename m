Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47F94E28B9
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348516AbiCUOAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348495AbiCUN54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:57:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB76D192AA;
        Mon, 21 Mar 2022 06:55:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BA9F612BC;
        Mon, 21 Mar 2022 13:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1E8C340E8;
        Mon, 21 Mar 2022 13:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870929;
        bh=4Pp+1U9O3buGlY5y0hV1jvev/KrdW88xCml6dpUJnLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcOl2N6e6a0MMQwRVuFmbRXFS70UWdjN/IDhPzsCAGV2Cu/UX7yO9A7JcHQKzrr0q
         HnByi3JMuR1HleL5YGu6FUgzPYRYJ21znbwurrbCeSE++xBjX7+eYrTZFKJZFQimPI
         79+bBCkYOws61WtpVUdBy5V0cwQXprO55pVNa6+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Zhang Qiao <zhangqiao22@huawei.com>
Subject: [PATCH 4.19 20/57] cpuset: Fix unsafe lock order between cpuset lock and cpuslock
Date:   Mon, 21 Mar 2022 14:52:01 +0100
Message-Id: <20220321133222.573355878@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
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

From: Zhang Qiao <zhangqiao22@huawei.com>

The backport commit 4eec5fe1c680a ("cgroup/cpuset: Fix a race
between cpuset_attach() and cpu hotplug") looks suspicious since
it comes before commit d74b27d63a8b ("cgroup/cpuset: Change
cpuset_rwsem and hotplug lock order") v5.4-rc1~176^2~30 when
the locking order was: cpuset lock, cpus lock.

Fix it with the correct locking order and reduce the cpus locking
range because only set_cpus_allowed_ptr() needs the protection of
cpus lock.

Fixes: 4eec5fe1c680a ("cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug")
Reported-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1528,9 +1528,13 @@ static void cpuset_attach(struct cgroup_
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
-	cpus_read_lock();
 	mutex_lock(&cpuset_mutex);
 
+	/*
+	 * It should hold cpus lock because a cpu offline event can
+	 * cause set_cpus_allowed_ptr() failed.
+	 */
+	get_online_cpus();
 	/* prepare for attach */
 	if (cs == &top_cpuset)
 		cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1549,6 +1553,7 @@ static void cpuset_attach(struct cgroup_
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 		cpuset_update_task_spread_flag(cs, task);
 	}
+       put_online_cpus();
 
 	/*
 	 * Change mm for all threadgroup leaders. This is expensive and may
@@ -1584,7 +1589,6 @@ static void cpuset_attach(struct cgroup_
 		wake_up(&cpuset_attach_wq);
 
 	mutex_unlock(&cpuset_mutex);
-	cpus_read_unlock();
 }
 
 /* The various types of files and directories in a cpuset file system */



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA6D6A9057
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 05:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjCCE4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 23:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCCE4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 23:56:17 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933861A960;
        Thu,  2 Mar 2023 20:56:14 -0800 (PST)
Received: from kwepemi500024.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PSbK53dsSznVZ5;
        Fri,  3 Mar 2023 12:56:09 +0800 (CST)
Received: from ci.huawei.com (10.67.175.89) by kwepemi500024.china.huawei.com
 (7.221.188.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Fri, 3 Mar
 2023 12:56:10 +0800
From:   Cai Xinchen <caixinchen1@huawei.com>
To:     <longman@redhat.com>, <lizefan.x@bytedance.com>, <tj@kernel.org>,
        <hannes@cmpxchg.org>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     <mkoutny@suse.com>, <zhangqiao22@huawei.com>,
        <juri.lelli@redhat.com>, <penguin-kernel@I-love.SAKURA.ne.jp>,
        <stable@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4.19 0/3] Backport patches to fix threadgroup_rwsem <-> cpus_read_lock() deadlock
Date:   Fri, 3 Mar 2023 04:50:47 +0000
Message-ID: <20230303045050.139985-1-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.89]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500024.china.huawei.com (7.221.188.100)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have a deadlock problem which can be solved by commit 4f7e7236435ca
("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock").
However, it makes lock order of cpus_read_lock and cpuset_mutex
wrong in v4.19. The call sequence is as follows:
cgroup_procs_write()
        cgroup_procs_write_start()
                get_online_cpus(); // cpus_read_lock()
                percpu_down_write(&cgroup_threadgroup_rwsem)
        cgroup_attach_task
                cgroup_migrate
                        cgroup_migrate_execute
                                ss->attach (cpust_attach)
                                        mutex_lock(&cpuset_mutex)

it seems hard to make cpus_read_lock is locked before
cgroup_threadgroup_rwsem and cpuset_mutex is locked before
cpus_read_lock unless backport the commit d74b27d63a8beb
("cgroup/cpuset: Change cpuset_rwsem and hotplug lock order")

Juri Lelli (1):
  cgroup/cpuset: Change cpuset_rwsem and hotplug lock order

Tejun Heo (1):
  cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Tetsuo Handa (1):
  cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

 include/linux/cpuset.h    |  8 +++----
 kernel/cgroup/cgroup-v1.c |  3 +++
 kernel/cgroup/cgroup.c    | 49 +++++++++++++++++++++++++++++++++++----
 kernel/cgroup/cpuset.c    | 25 ++++++++++++--------
 4 files changed, 66 insertions(+), 19 deletions(-)

-- 
2.17.1


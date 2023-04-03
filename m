Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E7E6D45D3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjDCNaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjDCNaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:30:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B42A4;
        Mon,  3 Apr 2023 06:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4B0661B44;
        Mon,  3 Apr 2023 13:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD924C433D2;
        Mon,  3 Apr 2023 13:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680528653;
        bh=gkl9GJzTmsB5rcAcfYLEeF2AGlRRvqNK46WjzttEC+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y4heVgHxnHHk+SR9DYW1yfI1s8uJMUtEql8IsErHkwN1QcZvm9puL+Hl/9ZV53BUk
         cE3mH8laTXfuRBwINC4vjQHrNcbwzi6IFO+1bmRSNc9blc9TsGYZRknRJj1g+VuEtf
         V2/EXiWZVsxSsaQyDDBHAl+1vxspuWjraNrsv5Qs=
Date:   Mon, 3 Apr 2023 15:30:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cai Xinchen <caixinchen1@huawei.com>
Cc:     longman@redhat.com, lizefan.x@bytedance.com, tj@kernel.org,
        hannes@cmpxchg.org, sashal@kernel.org, mkoutny@suse.com,
        zhangqiao22@huawei.com, juri.lelli@redhat.com,
        penguin-kernel@i-love.sakura.ne.jp, stable@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4.19 0/3] Backport patches to fix threadgroup_rwsem
 <-> cpus_read_lock() deadlock
Message-ID: <2023040343-dingbat-undermine-3b2d@gregkh>
References: <20230320011507.129441-1-caixinchen1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320011507.129441-1-caixinchen1@huawei.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 01:15:04AM +0000, Cai Xinchen wrote:
> I am very sorry. My gcc version is 7.5 and it does not report error.
> 
> We have a deadlock problem which can be solved by commit 4f7e7236435ca
> ("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock").
> However, it makes lock order of cpus_read_lock and cpuset_mutex
> wrong in v4.19. The call sequence is as follows:
> cgroup_procs_write()
>         cgroup_procs_write_start()
>                 get_online_cpus(); // cpus_read_lock()
>                 percpu_down_write(&cgroup_threadgroup_rwsem)
>         cgroup_attach_task
>                 cgroup_migrate
>                         cgroup_migrate_execute
>                                 ss->attach (cpust_attach)
>                                         mutex_lock(&cpuset_mutex)
> it seems hard to make cpus_read_lock is locked before
> cgroup_threadgroup_rwsem and cpuset_mutex is locked before
> cpus_read_lock unless backport the commit d74b27d63a8beb
> ("cgroup/cpuset: Change cpuset_rwsem and hotplug lock order")
> 
> Changes in v2:
>         * Add #include <linux/cpu.h> in kernel/cgroup/cgroup.c to
>          avoid some compile error.
>         * Exchange get_online_cpus() location in cpuset_attach to
>          keep cpu_hotplug_lock->cpuset_mutex order, although it will
>           be remove by ("cgroup: Fix threadgroup_rwsem <->
>          cpus_read_lock() deadlock")
> 
> Juri Lelli (1):
>   cgroup/cpuset: Change cpuset_rwsem and hotplug lock order
> 
> Tejun Heo (1):
>   cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock
> 
> Tetsuo Handa (1):
>   cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()
> 
>  include/linux/cpuset.h    |  8 +++----
>  kernel/cgroup/cgroup-v1.c |  3 +++
>  kernel/cgroup/cgroup.c    | 50 +++++++++++++++++++++++++++++++++++----
>  kernel/cgroup/cpuset.c    | 25 ++++++++++++--------
>  4 files changed, 67 insertions(+), 19 deletions(-)

Now queued up, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B4D6BC786
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 08:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjCPHpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 03:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjCPHpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 03:45:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DA1A225D;
        Thu, 16 Mar 2023 00:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9536F61F2E;
        Thu, 16 Mar 2023 07:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F73C4339B;
        Thu, 16 Mar 2023 07:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678952721;
        bh=qnYkMqHrmohbGAwgm0YEs+c1yNWF7ThMOQYvXw6RTbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=raFMI8NTOX6VCgopseeGn/RuMkgMBSUhY3hThiiz757ltlRHSFQFV182xmW+Uv9a7
         fdgS15mf5GUNLYLhqdk42OYz8kZqRVVLH7CTVvtwam7QU6rEZ/Y59wgVvHYI39UTXj
         ixsvmiIDP8YWf51JpwWEXqhlYoRwvqJ90J0YYW8Q=
Date:   Thu, 16 Mar 2023 08:45:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cai Xinchen <caixinchen1@huawei.com>
Cc:     longman@redhat.com, lizefan.x@bytedance.com, tj@kernel.org,
        hannes@cmpxchg.org, sashal@kernel.org, mkoutny@suse.com,
        zhangqiao22@huawei.com, juri.lelli@redhat.com,
        penguin-kernel@i-love.sakura.ne.jp, stable@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.19 0/3] Backport patches to fix threadgroup_rwsem <->
 cpus_read_lock() deadlock
Message-ID: <ZBLJDrkjFfLif6ZX@kroah.com>
References: <20230303045050.139985-1-caixinchen1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303045050.139985-1-caixinchen1@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 04:50:47AM +0000, Cai Xinchen wrote:
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
> 
> it seems hard to make cpus_read_lock is locked before
> cgroup_threadgroup_rwsem and cpuset_mutex is locked before
> cpus_read_lock unless backport the commit d74b27d63a8beb
> ("cgroup/cpuset: Change cpuset_rwsem and hotplug lock order")
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
>  kernel/cgroup/cgroup.c    | 49 +++++++++++++++++++++++++++++++++++----
>  kernel/cgroup/cpuset.c    | 25 ++++++++++++--------
>  4 files changed, 66 insertions(+), 19 deletions(-)

This series breaks the build on many architectures, so I will now have
to go drop them from the 4.19.y queue.  Please fix up and resubmit if
you wish to have them applied in the future.

thanks,

greg k-h

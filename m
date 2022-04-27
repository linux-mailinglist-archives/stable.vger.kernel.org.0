Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A903151172F
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 14:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiD0MNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 08:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbiD0MNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 08:13:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F3648393;
        Wed, 27 Apr 2022 05:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651061404; x=1682597404;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UNTq8c3nGCVicANYsW9zJ0pFSSw7ENqHGTRz5ROMqyA=;
  b=IcuMM4uG2sWIs7oQqQnJL/jKz0aSGck6prsuMTwza4JdAghiX2b4YONo
   ozZPfGtzpJKAQod8ukNBpTwnT0B2jnJXaVGFAY0MvYhBlqriW09JEIFzM
   rbENq4iCiWgPA8RuVLy9UPUCf/dvBmp6kRhNjTcG+7Eyfc3Yu3QDSRf4q
   05SZ6aJ+8vXjK19xu02s057xCwkXnY8+C7uNppxhyxYYtBnIt5B0rPFuK
   qtmjtrPr78d8g2LTzPKC5W9qNrgmPcV7nAI7H/BjCiGBs8k9uKJeIwaFj
   BbVOyJ0+kjhwwGRsrEGuEvNpDd8Em6aaBOODrME2oWmmGnNkPUJOpKe1H
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="245828202"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="245828202"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 05:10:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="580561887"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by orsmga008.jf.intel.com with ESMTP; 27 Apr 2022 05:09:58 -0700
Date:   Wed, 27 Apr 2022 20:09:58 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Waiman Long <longman@redhat.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup
 in cpuset_init_smp()
Message-ID: <20220427120958.GD84190@shbuild999.sh.intel.com>
References: <20220425155505.1292896-1-longman@redhat.com>
 <20220426032337.GA84190@shbuild999.sh.intel.com>
 <be293d58-1084-b586-2267-6a1e6a400762@redhat.com>
 <20220427010654.GC84190@shbuild999.sh.intel.com>
 <4c6847ba-4c8d-9776-a065-684a8b95130b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c6847ba-4c8d-9776-a065-684a8b95130b@redhat.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,TVD_SUBJ_WIPE_DEBT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:34:21PM -0400, Waiman Long wrote:
> On 4/26/22 21:06, Feng Tang wrote:
> > On Tue, Apr 26, 2022 at 10:58:21PM +0800, Waiman Long wrote:
> > > On 4/25/22 23:23, Feng Tang wrote:
> > > > Hi Waiman,
> > > > 
> > > > On Mon, Apr 25, 2022 at 11:55:05AM -0400, Waiman Long wrote:
> > > > > There are 3 places where the cpu and node masks of the top cpuset can
> > > > > be initialized in the order they are executed:
> > > > >    1) start_kernel -> cpuset_init()
> > > > >    2) start_kernel -> cgroup_init() -> cpuset_bind()
> > > > >    3) kernel_init_freeable() -> do_basic_setup() -> cpuset_init_smp()
> > > > > 
> > > > > The first cpuset_init() function just sets all the bits in the masks.
> > > > > The last one executed is cpuset_init_smp() which sets up cpu and node
> > > > > masks suitable for v1, but not v2.  cpuset_bind() does the right setup
> > > > > for both v1 and v2.
> > > > > 
> > > > > For systems with cgroup v2 setup, cpuset_bind() is called once. For
> > > > > systems with cgroup v1 setup, cpuset_bind() is called twice. It is
> > > > > first called before cpuset_init_smp() in cgroup v2 mode.  Then it is
> > > > > called again when cgroup v1 filesystem is mounted in v1 mode after
> > > > > cpuset_init_smp().
> > > > > 
> > > > >     [    2.609781] cpuset_bind() called - v2 = 1
> > > > >     [    3.079473] cpuset_init_smp() called
> > > > >     [    7.103710] cpuset_bind() called - v2 = 0
> > > > I run some test, on a server with centOS, this did happen that
> > > > cpuset_bind() is called twice, first as v2 during kernel boot,
> > > > and then as v1 post-boot.
> > > > 
> > > > However on a QEMU running with a basic debian rootfs image,
> > > > the second  call of cpuset_bind() didn't happen.
> > > The first time cpuset_bind() is called in cgroup_init(), the kernel
> > > doesn't know if userspace is going to mount v1 or v2 cgroup. By default,
> > > it is assumed to be v2. However, if userspace mounts the cgroup v1
> > > filesystem for cpuset, cpuset_bind() will be run at this point by
> > > rebind_subsystem() to set up cgroup v1 environment and
> > > cpus_allowed/mems_allowed will be correctly set at this point. Mounting
> > > the cgroup v2 filesystem, however, does not cause rebind_subsystem() to
> > > run and hence cpuset_bind() is not called again.
> > > 
> > > Is the QEMU setup not mounting any cgroup filesystem at all? If so, does
> > > it matter whether v1 or v2 setup is used?
> > When I got the cpuset binding error report, I tried first on qemu to
> > reproduce and failed (due to there was no memory hotplug), then I
> > reproduced it on a real server. For both system, I used "cgroup_no_v1=all"
> > cmdline parameter to test cgroup-v2, could this be the reason? (TBH,
> > this is the first time I use cgroup-v2).
> > 
> > Here is the info dump:
> > 
> > # mount | grep cgroup
> > tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
> > cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)
> > 
> > #cat /proc/filesystems | grep cgroup
> > nodev   cgroup
> > nodev   cgroup2
> > 
> > Thanks,
> > Feng
> 
> For cgroup v2, cpus_allowed should be set to cpu_possible_mask and
> mems_allowed to node_possible_map as is done in the first invocation of
> cpuset_bind(). That is the correct behavior.
 
OK. For the cgroup v2 mem binding problem with hot-added nodes, I
retested today, and it can't be reproduced with this patch. So feel
free to add:
  
  Tested-by: Feng Tang <feng.tang@intel.com>

Thanks,
Feng


> Cheers,
> Longman
> 

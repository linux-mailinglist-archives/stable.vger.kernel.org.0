Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F449510DC3
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 03:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbiD0BKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 21:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240618AbiD0BKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 21:10:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F77A5E17B;
        Tue, 26 Apr 2022 18:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651021619; x=1682557619;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qXiurggk6lNRwvUejqTYj42K/KnKmAqkVluTK7PeL+g=;
  b=dXR7FtgY3Mxx1t/ANn1Lw9iD+nVbMwHDNG5vLz7Xk/kR3QBS87xhkiel
   9j78xCD2KsPiCzPU6zbX7gEWuwGwY3lOWwF1MTUFCVvP2DAMNJLJ4c0cu
   EHG+wyVIXSGTe+QR3Fv+m5efsQh3n+sMiRfId4TsVcjwhxo7Lvyk0eGVG
   lZjxneFly37peSAXycvrM1GCh5AT3B7gPjzClGXmbZJvV2Zrb58gK03TN
   mmMSHCC5c6sMXZoNCgM5OjQQNnunL8nkF9JDAmVsdRf2X+c/xm6fLCErO
   O/N1WkqyKT8vO9fUM22ASvVBeP8L5WDPShGQQR4JosPBecdt8GJNg+sG7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="265935183"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="265935183"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 18:06:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="558635915"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by orsmga007.jf.intel.com with ESMTP; 26 Apr 2022 18:06:55 -0700
Date:   Wed, 27 Apr 2022 09:06:54 +0800
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
Message-ID: <20220427010654.GC84190@shbuild999.sh.intel.com>
References: <20220425155505.1292896-1-longman@redhat.com>
 <20220426032337.GA84190@shbuild999.sh.intel.com>
 <be293d58-1084-b586-2267-6a1e6a400762@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be293d58-1084-b586-2267-6a1e6a400762@redhat.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,TVD_SUBJ_WIPE_DEBT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:58:21PM +0800, Waiman Long wrote:
> On 4/25/22 23:23, Feng Tang wrote:
> > Hi Waiman,
> >
> > On Mon, Apr 25, 2022 at 11:55:05AM -0400, Waiman Long wrote:
> >> There are 3 places where the cpu and node masks of the top cpuset can
> >> be initialized in the order they are executed:
> >>   1) start_kernel -> cpuset_init()
> >>   2) start_kernel -> cgroup_init() -> cpuset_bind()
> >>   3) kernel_init_freeable() -> do_basic_setup() -> cpuset_init_smp()
> >>
> >> The first cpuset_init() function just sets all the bits in the masks.
> >> The last one executed is cpuset_init_smp() which sets up cpu and node
> >> masks suitable for v1, but not v2.  cpuset_bind() does the right setup
> >> for both v1 and v2.
> >>
> >> For systems with cgroup v2 setup, cpuset_bind() is called once. For
> >> systems with cgroup v1 setup, cpuset_bind() is called twice. It is
> >> first called before cpuset_init_smp() in cgroup v2 mode.  Then it is
> >> called again when cgroup v1 filesystem is mounted in v1 mode after
> >> cpuset_init_smp().
> >>
> >>    [    2.609781] cpuset_bind() called - v2 = 1
> >>    [    3.079473] cpuset_init_smp() called
> >>    [    7.103710] cpuset_bind() called - v2 = 0
> > I run some test, on a server with centOS, this did happen that
> > cpuset_bind() is called twice, first as v2 during kernel boot,
> > and then as v1 post-boot.
> >
> > However on a QEMU running with a basic debian rootfs image,
> > the second  call of cpuset_bind() didn't happen.
> 
> The first time cpuset_bind() is called in cgroup_init(), the kernel 
> doesn't know if userspace is going to mount v1 or v2 cgroup. By default, 
> it is assumed to be v2. However, if userspace mounts the cgroup v1 
> filesystem for cpuset, cpuset_bind() will be run at this point by 
> rebind_subsystem() to set up cgroup v1 environment and 
> cpus_allowed/mems_allowed will be correctly set at this point. Mounting 
> the cgroup v2 filesystem, however, does not cause rebind_subsystem() to 
> run and hence cpuset_bind() is not called again.
> 
> Is the QEMU setup not mounting any cgroup filesystem at all? If so, does 
> it matter whether v1 or v2 setup is used?

When I got the cpuset binding error report, I tried first on qemu to
reproduce and failed (due to there was no memory hotplug), then I
reproduced it on a real server. For both system, I used "cgroup_no_v1=all"
cmdline parameter to test cgroup-v2, could this be the reason? (TBH,
this is the first time I use cgroup-v2).

Here is the info dump:

# mount | grep cgroup
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)

#cat /proc/filesystems | grep cgroup
nodev   cgroup
nodev   cgroup2

Thanks,
Feng

> >> As a result, cpu and memory node hot add may fail to update the cpu and
> >> node masks of the top cpuset to include the newly added cpu or node in
> >> a cgroup v2 environment.
> >>
> >> smp_init() is called after the first two init functions.  So we don't
> >> have a complete list of active cpus and memory nodes until later in
> >> cpuset_init_smp() which is the right time to set up effective_cpus
> >> and effective_mems.
> >>
> >> To fix this problem, the potentially incorrect cpus_allowed &
> >> mems_allowed setup in cpuset_init_smp() are removed.  For cgroup v2
> >> systems, the initial cpuset_bind() call will set them up correctly.
> >> For cgroup v1 systems, the second call to cpuset_bind() will do the
> >> right setup.
> >>
> >> cc: stable@vger.kernel.org
> >> Signed-off-by: Waiman Long <longman@redhat.com>
> >> ---
> >>   kernel/cgroup/cpuset.c | 5 +++--
> >>   1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> >> index 9390bfd9f1cd..6bd8f5ef40fe 100644
> >> --- a/kernel/cgroup/cpuset.c
> >> +++ b/kernel/cgroup/cpuset.c
> >> @@ -3390,8 +3390,9 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
> >>    */
> >>   void __init cpuset_init_smp(void)
> >>   {
> >> -	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
> >> -	top_cpuset.mems_allowed = node_states[N_MEMORY];
> > So can we keep line
> >    cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
> >
> > and only remove line
> >         top_cpuset.mems_allowed = node_states[N_MEMORY];
> > ?
> 
> That may cause cpusets.cpu to be set incorrectly for systems using 
> cgroup v2. What is really important is that effective_cpus and 
> effective_mems are set correctly.
> 
> Cheers,
> Longman
> 

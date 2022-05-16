Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954C7527C2D
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 05:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239520AbiEPDC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 23:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239514AbiEPDCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 23:02:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 119DC5589
        for <stable@vger.kernel.org>; Sun, 15 May 2022 20:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652670167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SgoGRDvahFUh/43nHiWUFsdFsLsu67X0yLaYj3I8E2g=;
        b=AgeQkUhLXslTA7Rx7iqsfZkDp4xvgPAw4PdLdTXd2hSvL9DBNNmLypijnRMplCxSzLL2hA
        QITfsWN7mGITeHuD3tX1tvfTeAfVbdBqSDloGxMnHndzuqk7H8eoVpjjHuN5c67tdpoAyX
        Os2JGby0G0p2GM9ngLwgdxM73X+nsQ8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-ZCtYqzGZOoi8JQR1cfoHpQ-1; Sun, 15 May 2022 23:02:41 -0400
X-MC-Unique: ZCtYqzGZOoi8JQR1cfoHpQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 919CE38C5C4A;
        Mon, 16 May 2022 03:02:40 +0000 (UTC)
Received: from [10.22.32.76] (unknown [10.22.32.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 650DD40FF400;
        Mon, 16 May 2022 03:02:39 +0000 (UTC)
Message-ID: <daf56c43-feba-4075-1361-94b9a2dae15a@redhat.com>
Date:   Sun, 15 May 2022 23:02:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [cgroup/cpuset] 7aaa45f837: kbuild.buildtime_per_iteration
 2583.0% regression
Content-Language: en-US
To:     kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@lists.01.org, ying.huang@intel.com, feng.tang@intel.com,
        zhengjun.xing@linux.intel.com, fengwei.yin@intel.com,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, stable@vger.kernel.org
References: <20220513063308.GA21013@xsang-OptiPlex-9020>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20220513063308.GA21013@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/22 02:33, kernel test robot wrote:
>
> Greeting,
>
> FYI, we noticed a 2583.0% regression of kbuild.buildtime_per_iteration due to commit:
>
>
> commit: 7aaa45f8374887d98cd479a6bdd3b4c74e6a981a ("[PATCH] cgroup/cpuset: Remove redundant cpu/node masks setup in cpuset_init_smp()")
> url: https://github.com/intel-lab-lkp/linux/commits/Waiman-Long/cgroup-cpuset-Remove-redundant-cpu-node-masks-setup-in-cpuset_init_smp/20220425-101126
> base: https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git for-next
> patch link: https://lore.kernel.org/linux-mm/20220425020926.1264611-1-longman@redhat.com

That link is the original v1 patch which is not correct. Is this the one 
that is being tested here?

I have sent out another patch which shouldn't cause this kind of problem.

Thanks,
Longman

>
> in testcase: kbuild
> on test machine: 88 threads 2 sockets Intel(R) Xeon(R) Gold 6238M CPU @ 2.10GHz with 128G memory
> with following parameters:
>
> 	memory.high: 90%
> 	memory.low: 50%
> 	memory.max: max
> 	pids.max: 10000
> 	runtime: 300s
> 	nr_task: 50%
> 	target: autoksyms_recursive
> 	cpufreq_governor: performance
> 	ucode: 0x500320a
>
>
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
>
>
> Details are as below:
> -------------------------------------------------------------------------------------------------->
>
>
> To reproduce:
>
>          git clone https://github.com/intel/lkp-tests.git
>          cd lkp-tests
>          sudo bin/lkp install job.yaml           # job file is attached in this email
>          bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
>          sudo bin/lkp run generated-yaml-file
>
>          # if come across any failure that blocks the test,
>          # please remove ~/.lkp and /lkp dir to run from a clean state.
>
> =========================================================================================
> compiler/cpufreq_governor/kconfig/memory.high/memory.low/memory.max/nr_task/pids.max/rootfs/runtime/target/tbox_group/testcase/ucode:
>    gcc-11/performance/x86_64-rhel-8.3/90%/50%/max/50%/10000/debian-10.4-x86_64-20200603.cgz/300s/autoksyms_recursive/lkp-csl-2sp9/kbuild/0x500320a
>
> commit:
>    4ab93063c8 ("cgroup: Add test_cpucg_weight_underprovisioned() testcase")
>    7aaa45f837 ("cgroup/cpuset: Remove redundant cpu/node masks setup in cpuset_init_smp()")
>
> 4ab93063c83a2478 7aaa45f8374887d98cd479a6bdd
> ---------------- ---------------------------
>           %stddev     %change         %stddev
>               \          |                \
>       44.43         +2583.0%       1192        kbuild.buildtime_per_iteration
>      311.14          +283.0%       1191        kbuild.time.elapsed_time
>      311.14          +283.0%       1191        kbuild.time.elapsed_time.max
>      363486            -4.7%     346532        kbuild.time.involuntary_context_switches
>        7528 ±  2%     -99.1%      68.00        kbuild.time.major_page_faults
>   3.854e+08           -85.7%   55047165        kbuild.time.minor_page_faults
>        2608           -96.4%      95.00        kbuild.time.percent_of_cpu_this_job_got
>        1361           -89.5%     142.46        kbuild.time.system_time
>        6756           -85.3%     991.32        kbuild.time.user_time
>     1763962           -84.6%     270814        kbuild.time.voluntary_context_switches
>        7.00           -85.7%       1.00        kbuild.workload
>   1.886e+10          +439.9%  1.018e+11        cpuidle..time
>    40524113          +397.6%  2.016e+08 ±  9%  cpuidle..usage
>      352.84          +249.7%       1233        uptime.boot
>       22088          +378.4%     105677        uptime.idle
>       68.86           +28.8       97.63        mpstat.cpu.all.idle%
>        0.16 ±  3%      -0.1        0.08 ±  8%  mpstat.cpu.all.soft%
>        5.23            -5.1        0.15        mpstat.cpu.all.sys%
>       24.48           -23.5        0.96        mpstat.cpu.all.usr%
>       68.83           +42.1%      97.83        vmstat.cpu.id
>       24.00          -100.0%       0.00        vmstat.cpu.us
>       26.00           +73.1%      45.00        vmstat.procs.r
>       17438           -88.3%       2045        vmstat.system.cs
>   1.749e+08           -70.6%   51378800        numa-numastat.node0.local_node
>    1.75e+08           -70.6%   51378813        numa-numastat.node0.numa_hit
>       50974 ± 50%    -100.0%      13.50 ± 75%  numa-numastat.node0.other_node
>    1.75e+08          -100.0%      82.83 ±223%  numa-numastat.node1.local_node
>    1.75e+08          -100.0%      79394        numa-numastat.node1.numa_hit
>       28316 ± 91%    +180.1%      79311        numa-numastat.node1.other_node
>        6700 ±  4%     +69.9%      11385 ±  3%  meminfo.Active
>        6540 ±  4%     +69.1%      11063        meminfo.Active(anon)
>      223421           +31.7%     294262 ±  2%  meminfo.AnonHugePages
>     1300267           +31.4%    1708081        meminfo.AnonPages
>     1576268           +25.7%    1981479        meminfo.Committed_AS
>     1338713           +28.5%    1719792        meminfo.Inactive
>     1338565           +28.4%    1719004        meminfo.Inactive(anon)
>       18332           -11.0%      16310        meminfo.KernelStack
>       93129           -43.8%      52361        meminfo.Mapped
>       14656 ±  2%      -8.9%      13355        meminfo.PageTables
>       43576 ±  3%     -52.0%      20896        meminfo.Shmem
>     7581989           -10.5%    6785067        meminfo.max_used_kB
>      875.33          -100.0%       0.00        turbostat.Avg_MHz
>       31.74           -31.7        0.00        turbostat.Busy%
>        2764          -100.0%       0.00        turbostat.Bzy_MHz
>      173892 ± 10%    -100.0%       0.00        turbostat.C1
>        0.02 ± 17%      -0.0        0.00        turbostat.C1%
>    33508125 ± 20%    -100.0%       0.00        turbostat.C1E
>       48.18 ± 44%     -48.2        0.00        turbostat.C1E%
>     6776884 ±102%    -100.0%       0.00        turbostat.C6
>       20.30 ±104%     -20.3        0.00        turbostat.C6%
>       66.40 ±  4%    -100.0%       0.00        turbostat.CPU%c1
>        1.86 ±139%    -100.0%       0.00        turbostat.CPU%c6
>       59.17          -100.0%       0.00        turbostat.CoreTmp
>        0.33          -100.0%       0.00        turbostat.IPC
>    55232878          -100.0%       0.00        turbostat.IRQ
>       56380 ±  6%    -100.0%       0.00        turbostat.POLL
>       59.00          -100.0%       0.00        turbostat.PkgTmp
>      215.76          -100.0%       0.00        turbostat.PkgWatt
>       16.16          -100.0%       0.00        turbostat.RAMWatt
>        2095          -100.0%       0.00        turbostat.TSC_MHz
>      813.00 ± 11%    +237.1%       2740        numa-vmstat.node0.nr_active_anon
>      183776          +131.6%     425651        numa-vmstat.node0.nr_anon_pages
>      186417          +129.7%     428211        numa-vmstat.node0.nr_inactive_anon
>        1978           +68.0%       3324        numa-vmstat.node0.nr_page_table_pages
>        3282 ±  7%     +53.1%       5023        numa-vmstat.node0.nr_shmem
>      813.00 ± 11%    +237.1%       2740        numa-vmstat.node0.nr_zone_active_anon
>      186416          +129.7%     428211        numa-vmstat.node0.nr_zone_inactive_anon
>    1.75e+08           -70.6%   51378302        numa-vmstat.node0.numa_hit
>   1.749e+08           -70.6%   51378288        numa-vmstat.node0.numa_local
>       50973 ± 50%    -100.0%      13.50 ± 75%  numa-vmstat.node0.numa_other
>      823.33 ±  5%     -97.5%      20.33 ± 12%  numa-vmstat.node1.nr_active_anon
>      139750 ±  2%     -99.9%      88.17 ±114%  numa-vmstat.node1.nr_anon_pages
>      157716 ±183%     -97.6%       3733 ±208%  numa-vmstat.node1.nr_file_pages
>      146649 ±  2%     -99.8%     265.00 ± 56%  numa-vmstat.node1.nr_inactive_anon
>        8288 ±  4%     -31.8%       5653 ±  5%  numa-vmstat.node1.nr_kernel_stack
>        8789 ± 47%     -99.6%      32.00 ±120%  numa-vmstat.node1.nr_mapped
>        1658           -99.8%       4.00 ± 73%  numa-vmstat.node1.nr_page_table_pages
>        7610 ±  3%     -97.4%     197.17 ± 27%  numa-vmstat.node1.nr_shmem
>       11225 ±101%     -74.3%       2883 ±  9%  numa-vmstat.node1.nr_slab_reclaimable
>       20034 ±  3%     -25.8%      14861 ±  4%  numa-vmstat.node1.nr_slab_unreclaimable
>      823.33 ±  5%     -97.5%      20.33 ± 12%  numa-vmstat.node1.nr_zone_active_anon
>      146648 ±  2%     -99.8%     265.00 ± 56%  numa-vmstat.node1.nr_zone_inactive_anon
>    1.75e+08          -100.0%      79394        numa-vmstat.node1.numa_hit
>    1.75e+08          -100.0%      82.83 ±223%  numa-vmstat.node1.numa_local
>       28312 ± 91%    +180.1%      79311        numa-vmstat.node1.numa_other
>        1642 ±  4%     +68.3%       2763        proc-vmstat.nr_active_anon
>      322313           +32.5%     427139        proc-vmstat.nr_anon_pages
>      864421            -1.5%     851593        proc-vmstat.nr_file_pages
>      332108           +29.4%     429879        proc-vmstat.nr_inactive_anon
>       18183           -10.3%      16310        proc-vmstat.nr_kernel_stack
>       23431           -43.6%      13208        proc-vmstat.nr_mapped
>        3550 ±  2%      -6.0%       3337        proc-vmstat.nr_page_table_pages
>       11164 ±  3%     -53.2%       5223        proc-vmstat.nr_shmem
>       46151            -2.2%      45116        proc-vmstat.nr_slab_reclaimable
>       46770            -8.6%      42749        proc-vmstat.nr_slab_unreclaimable
>        1642 ±  4%     +68.3%       2763        proc-vmstat.nr_zone_active_anon
>      332108           +29.4%     429879        proc-vmstat.nr_zone_inactive_anon
>      360277 ± 30%     -99.8%     680.17 ±112%  proc-vmstat.numa_hint_faults
>      357678 ± 31%     -99.8%     680.17 ±112%  proc-vmstat.numa_hint_faults_local
>     3.5e+08           -85.3%   51462030        proc-vmstat.numa_hit
>   3.499e+08           -85.3%   51382705        proc-vmstat.numa_local
>       10372 ±129%    -100.0%       0.00        proc-vmstat.numa_pages_migrated
>      790289 ± 15%     -75.5%     193877 ±  7%  proc-vmstat.numa_pte_updates
>      290045           -86.1%      40379        proc-vmstat.pgactivate
>   3.498e+08           -85.3%   51462440        proc-vmstat.pgalloc_normal
>   3.871e+08           -85.1%   57578373        proc-vmstat.pgfault
>   3.497e+08           -85.3%   51397471        proc-vmstat.pgfree
>       10372 ±129%    -100.0%       0.00        proc-vmstat.pgmigrate_success
>     2920438           -78.6%     624274        proc-vmstat.pgreuse
>       18128           -85.7%       2594        proc-vmstat.thp_fault_alloc
>      771909           -85.7%     110390        proc-vmstat.unevictable_pgs_culled
>        3411 ± 11%    +226.2%      11127        numa-meminfo.node0.Active
>        3251 ± 11%    +237.3%      10966        numa-meminfo.node0.Active(anon)
>      188175 ±  6%     +56.0%     293523 ±  2%  numa-meminfo.node0.AnonHugePages
>      737315          +130.8%    1701834        numa-meminfo.node0.AnonPages
>     1657848 ±  5%     +85.9%    3081876 ±  4%  numa-meminfo.node0.AnonPages.max
>      748023          +129.0%    1712859        numa-meminfo.node0.Inactive
>      747875          +128.9%    1712108        numa-meminfo.node0.Inactive(anon)
>     4306840 ± 28%     +35.6%    5839514        numa-meminfo.node0.MemUsed
>        7772 ±  3%     +71.1%      13297        numa-meminfo.node0.PageTables
>       13182 ±  8%     +52.5%      20099        numa-meminfo.node0.Shmem
>        3307 ±  5%     -92.7%     242.00 ±147%  numa-meminfo.node1.Active
>        3307 ±  5%     -97.5%      81.33 ± 12%  numa-meminfo.node1.Active(anon)
>       34918 ± 34%    -100.0%       0.00        numa-meminfo.node1.AnonHugePages
>      557333 ±  2%     -99.9%     353.33 ±114%  numa-meminfo.node1.AnonPages
>     1876230 ±  3%    -100.0%     496.67 ± 96%  numa-meminfo.node1.AnonPages.max
>      631836 ±183%     -97.6%      14935 ±208%  numa-meminfo.node1.FilePages
>      586137 ±  2%     -99.8%       1096 ± 51%  numa-meminfo.node1.Inactive
>      586137 ±  2%     -99.8%       1061 ± 56%  numa-meminfo.node1.Inactive(anon)
>       44909 ±101%     -74.3%      11533 ±  9%  numa-meminfo.node1.KReclaimable
>        8244 ±  4%     -31.4%       5653 ±  5%  numa-meminfo.node1.KernelStack
>       35330 ± 46%     -99.6%     129.17 ±119%  numa-meminfo.node1.Mapped
>     1612958 ± 74%     -79.4%     333010 ±  7%  numa-meminfo.node1.MemUsed
>        6577           -99.8%      16.17 ± 73%  numa-meminfo.node1.PageTables
>       44909 ±101%     -74.3%      11533 ±  9%  numa-meminfo.node1.SReclaimable
>       80135 ±  3%     -25.8%      59446 ±  4%  numa-meminfo.node1.SUnreclaim
>       31315 ±  3%     -97.5%     789.17 ± 27%  numa-meminfo.node1.Shmem
>      125044 ± 38%     -43.2%      70980 ±  4%  numa-meminfo.node1.Slab
>   1.978e+10           -95.6%  8.797e+08        perf-stat.i.branch-instructions
>   5.616e+08           -95.6%   24754884 ±  8%  perf-stat.i.branch-misses
>   1.495e+08           -94.7%    7868663 ±  5%  perf-stat.i.cache-misses
>   6.176e+08           -94.5%   34193232 ± 36%  perf-stat.i.cache-references
>       17499           -88.4%       2029        perf-stat.i.context-switches
>        0.93 ±  3%     +36.6%       1.27 ±  5%  perf-stat.i.cpi
>   7.611e+10           -93.3%  5.121e+09 ±  4%  perf-stat.i.cpu-cycles
>        1275          -100.0%       0.04 ± 28%  perf-stat.i.cpu-migrations
>        1029 ±  5%     -31.3%     707.28 ±  2%  perf-stat.i.cycles-between-cache-misses
>    14172722           -94.1%     836284 ± 47%  perf-stat.i.dTLB-load-misses
>   2.503e+10           -95.5%  1.122e+09        perf-stat.i.dTLB-loads
>     7917427           -95.8%     332811 ± 15%  perf-stat.i.dTLB-store-misses
>   1.244e+10           -95.4%  5.666e+08        perf-stat.i.dTLB-stores
>    24631063           -92.3%    1894591 ±  2%  perf-stat.i.iTLB-load-misses
>    71323368           -94.9%    3665231 ±  6%  perf-stat.i.iTLB-loads
>   9.005e+10           -95.5%  4.054e+09        perf-stat.i.instructions
>        3571           -39.7%       2152        perf-stat.i.instructions-per-iTLB-miss
>        1.10 ±  2%     -28.1%       0.79 ±  5%  perf-stat.i.ipc
>       24.38 ±  2%     -99.5%       0.11 ± 23%  perf-stat.i.major-faults
>        0.86           -93.3%       0.06 ±  4%  perf-stat.i.metric.GHz
>      658.74           -95.6%      29.19        perf-stat.i.metric.M/sec
>     1236978           -96.1%      48019        perf-stat.i.minor-faults
>       24.93 ±  5%     -18.7        6.26 ± 22%  perf-stat.i.node-load-miss-rate%
>     6765575           -97.4%     178075 ± 26%  perf-stat.i.node-load-misses
>    55797319           -94.4%    3120263        perf-stat.i.node-loads
>       18.32 ±  4%      -9.7        8.62 ± 22%  perf-stat.i.node-store-miss-rate%
>     1648658           -97.0%      50137 ± 26%  perf-stat.i.node-store-misses
>    11762943           -95.0%     585083        perf-stat.i.node-stores
>     1237003           -96.1%      48019        perf-stat.i.page-faults
>        6.86           +23.4%       8.46 ± 38%  perf-stat.overall.MPKI
>        0.85           +49.5%       1.26 ±  5%  perf-stat.overall.cpi
>      508.96           +27.9%     651.10        perf-stat.overall.cycles-between-cache-misses
>       25.67            +8.5       34.14 ±  3%  perf-stat.overall.iTLB-load-miss-rate%
>        3655           -41.4%       2140        perf-stat.overall.instructions-per-iTLB-miss
>        1.18           -32.9%       0.79 ±  5%  perf-stat.overall.ipc
>       10.82            -5.4        5.38 ± 24%  perf-stat.overall.node-load-miss-rate%
>       12.30            -4.4        7.85 ± 23%  perf-stat.overall.node-store-miss-rate%
>   4.002e+12           +20.6%  4.826e+12        perf-stat.overall.path-length
>   1.972e+10           -95.5%  8.791e+08        perf-stat.ps.branch-instructions
>   5.599e+08           -95.6%   24737459 ±  8%  perf-stat.ps.branch-misses
>   1.491e+08           -94.7%    7862895 ±  5%  perf-stat.ps.cache-misses
>   6.158e+08           -94.5%   34168138 ± 36%  perf-stat.ps.cache-references
>       17447           -88.4%       2027        perf-stat.ps.context-switches
>   7.588e+10           -93.3%  5.118e+09 ±  4%  perf-stat.ps.cpu-cycles
>        1272          -100.0%       0.04 ± 28%  perf-stat.ps.cpu-migrations
>    14129808           -94.1%     835661 ± 47%  perf-stat.ps.dTLB-load-misses
>   2.495e+10           -95.5%  1.121e+09        perf-stat.ps.dTLB-loads
>     7893270           -95.8%     332570 ± 15%  perf-stat.ps.dTLB-store-misses
>    1.24e+10           -95.4%  5.662e+08        perf-stat.ps.dTLB-stores
>    24556703           -92.3%    1893249 ±  2%  perf-stat.ps.iTLB-load-misses
>    71106326           -94.8%    3662587 ±  6%  perf-stat.ps.iTLB-loads
>   8.978e+10           -95.5%  4.051e+09        perf-stat.ps.instructions
>       24.32 ±  2%     -99.5%       0.11 ± 24%  perf-stat.ps.major-faults
>     1233214           -96.1%      47986        perf-stat.ps.minor-faults
>     6745825           -97.4%     177950 ± 26%  perf-stat.ps.node-load-misses
>    55627061           -94.4%    3117959        perf-stat.ps.node-loads
>     1644068           -97.0%      50102 ± 26%  perf-stat.ps.node-store-misses
>    11727184           -95.0%     584651        perf-stat.ps.node-stores
>     1233238           -96.1%      47986        perf-stat.ps.page-faults
>   2.802e+13           -82.8%  4.826e+12        perf-stat.total.instructions
>        0.39         +3586.3%      14.32 ±  4%  sched_debug.cfs_rq:/.h_nr_running.avg
>        1.11 ±  7%   +4138.2%      47.09        sched_debug.cfs_rq:/.h_nr_running.max
>        0.43         +4683.1%      20.72        sched_debug.cfs_rq:/.h_nr_running.stddev
>       14081 ± 20%   +2107.0%     310782 ±  4%  sched_debug.cfs_rq:/.load.avg
>      407170 ± 49%    +170.4%    1101004        sched_debug.cfs_rq:/.load.max
>       52684 ± 42%    +768.5%     457567        sched_debug.cfs_rq:/.load.stddev
>       37.01 ± 46%    +723.1%     304.63 ±  4%  sched_debug.cfs_rq:/.load_avg.avg
>      144.31 ± 45%    +210.7%     448.32        sched_debug.cfs_rq:/.load_avg.stddev
>     2488735           -92.5%     187680 ±  3%  sched_debug.cfs_rq:/.min_vruntime.avg
>     2938975           -80.2%     581666        sched_debug.cfs_rq:/.min_vruntime.max
>     2060745 ±  2%     -99.5%      10250 ± 34%  sched_debug.cfs_rq:/.min_vruntime.min
>      182406 ±  6%     +39.2%     253824        sched_debug.cfs_rq:/.min_vruntime.stddev
>        0.39           -23.7%       0.30 ±  4%  sched_debug.cfs_rq:/.nr_running.avg
>      400.60         +3272.5%      13510 ±  5%  sched_debug.cfs_rq:/.runnable_avg.avg
>      971.78 ±  2%   +4430.1%      44022        sched_debug.cfs_rq:/.runnable_avg.max
>      370.10         +5173.5%      19517        sched_debug.cfs_rq:/.runnable_avg.stddev
>       12579 ±1058%   -3228.1%    -393486        sched_debug.cfs_rq:/.spread0.avg
>      462824 ± 24%     -99.9%     540.01 ± 92%  sched_debug.cfs_rq:/.spread0.max
>      182401 ±  6%     +39.2%     253852        sched_debug.cfs_rq:/.spread0.stddev
>      400.13           -25.0%     300.07 ±  4%  sched_debug.cfs_rq:/.util_avg.avg
>      369.97           +18.4%     437.88        sched_debug.cfs_rq:/.util_avg.stddev
>       10.90 ± 10%     -87.5%       1.37 ± 48%  sched_debug.cfs_rq:/.util_est_enqueued.avg
>      454.44 ± 14%     -90.3%      44.23 ±  3%  sched_debug.cfs_rq:/.util_est_enqueued.max
>       60.82 ± 13%     -90.9%       5.53 ± 14%  sched_debug.cfs_rq:/.util_est_enqueued.stddev
>        0.92 ± 36%     -90.0%       0.09 ±176%  sched_debug.cfs_rq:/init.scope.load_avg.avg
>        1.08 ± 17%     -91.5%       0.09 ±176%  sched_debug.cfs_rq:/init.scope.load_avg.max
>        0.50 ±107%   +2506.1%      12.97 ± 57%  sched_debug.cfs_rq:/init.scope.min_vruntime.avg
>        0.54 ±104%   +2288.9%      13.00 ± 57%  sched_debug.cfs_rq:/init.scope.min_vruntime.max
>        0.45 ±111%   +2768.6%      12.93 ± 57%  sched_debug.cfs_rq:/init.scope.min_vruntime.min
>        0.92 ± 36%     -90.0%       0.09 ±176%  sched_debug.cfs_rq:/init.scope.runnable_avg.avg
>        1.08 ± 17%     -91.5%       0.09 ±176%  sched_debug.cfs_rq:/init.scope.runnable_avg.max
>        0.51 ±123%   +1809.6%       9.78 ± 40%  sched_debug.cfs_rq:/init.scope.se->sum_exec_runtime.avg
>        0.52 ±122%   +1769.0%       9.78 ± 40%  sched_debug.cfs_rq:/init.scope.se->sum_exec_runtime.max
>        0.50 ±126%   +1852.0%       9.77 ± 40%  sched_debug.cfs_rq:/init.scope.se->sum_exec_runtime.min
>      927421 ±116%     -88.6%     105436 ± 29%  sched_debug.cfs_rq:/init.scope.se->vruntime.avg
>      927672 ±116%     -88.6%     105945 ± 29%  sched_debug.cfs_rq:/init.scope.se->vruntime.max
>      927171 ±117%     -88.7%     104926 ± 29%  sched_debug.cfs_rq:/init.scope.se->vruntime.min
>     -903221           -88.3%    -106040        sched_debug.cfs_rq:/init.scope.spread0.avg
>     -903221           -88.3%    -106040        sched_debug.cfs_rq:/init.scope.spread0.max
>     -903221           -88.3%    -106040        sched_debug.cfs_rq:/init.scope.spread0.min
>        1.08 ± 17%     -91.5%       0.09 ±176%  sched_debug.cfs_rq:/init.scope.tg_load_avg.avg
>        1.08 ± 17%     -91.5%       0.09 ±176%  sched_debug.cfs_rq:/init.scope.tg_load_avg.max
>        1.08 ± 17%     -91.5%       0.09 ±176%  sched_debug.cfs_rq:/init.scope.tg_load_avg.min
>        0.92 ± 36%     -90.0%       0.09 ±176%  sched_debug.cfs_rq:/init.scope.tg_load_avg_contrib.avg
>        1.08 ± 17%     -91.5%       0.09 ±176%  sched_debug.cfs_rq:/init.scope.tg_load_avg_contrib.max
>        0.92 ± 36%     -96.4%       0.03 ±111%  sched_debug.cfs_rq:/init.scope.util_avg.avg
>        1.08 ± 17%     -96.9%       0.03 ±111%  sched_debug.cfs_rq:/init.scope.util_avg.max
>      109.53 ±107%  +50485.6%      55405        sched_debug.cfs_rq:/kbuild.1.MIN_vruntime.avg
>        9638 ±107%    +475.0%      55414        sched_debug.cfs_rq:/kbuild.1.MIN_vruntime.max
>       -0.30        -1.9e+07%      55396        sched_debug.cfs_rq:/kbuild.1.MIN_vruntime.min
>        0.39 ±  2%  +11812.2%      46.70        sched_debug.cfs_rq:/kbuild.1.h_nr_running.avg
>        1.00         +4594.2%      46.94        sched_debug.cfs_rq:/kbuild.1.h_nr_running.max
>      410733 ±  2%  +11823.3%   48972868        sched_debug.cfs_rq:/kbuild.1.load.avg
>     1048576         +4594.2%   49221905        sched_debug.cfs_rq:/kbuild.1.load.max
>      659.13 ±  3%   +7394.5%      49398        sched_debug.cfs_rq:/kbuild.1.load_avg.avg
>        2647 ± 11%   +1777.5%      49713        sched_debug.cfs_rq:/kbuild.1.load_avg.max
>        0.03 ±223%  +1.8e+08%      49083 ±  2%  sched_debug.cfs_rq:/kbuild.1.load_avg.min
>      109.53 ±107%  +50489.2%      55409        sched_debug.cfs_rq:/kbuild.1.max_vruntime.avg
>        9638 ±107%    +475.0%      55418        sched_debug.cfs_rq:/kbuild.1.max_vruntime.max
>       -0.30        -1.9e+07%      55400        sched_debug.cfs_rq:/kbuild.1.max_vruntime.min
>       87264           -36.5%      55405        sched_debug.cfs_rq:/kbuild.1.min_vruntime.avg
>       99270           -44.2%      55414        sched_debug.cfs_rq:/kbuild.1.min_vruntime.max
>       75767           -26.9%      55396        sched_debug.cfs_rq:/kbuild.1.min_vruntime.min
>        5024 ±  7%     -99.8%       9.08 ±100%  sched_debug.cfs_rq:/kbuild.1.min_vruntime.stddev
>        0.39 ±  2%  +11812.2%      46.70        sched_debug.cfs_rq:/kbuild.1.nr_running.avg
>        1.00         +4594.2%      46.94        sched_debug.cfs_rq:/kbuild.1.nr_running.max
>       35.29 ± 22%    -100.0%       0.00        sched_debug.cfs_rq:/kbuild.1.removed.load_avg.avg
>      919.11 ± 14%    -100.0%       0.00        sched_debug.cfs_rq:/kbuild.1.removed.load_avg.max
>      156.52 ± 17%    -100.0%       0.00        sched_debug.cfs_rq:/kbuild.1.removed.load_avg.stddev
>       14.27 ± 27%    -100.0%       0.00        sched_debug.cfs_rq:/kbuild.1.removed.runnable_avg.avg
>      419.11 ± 25%    -100.0%       0.00        sched_debug.cfs_rq:/kbuild.1.removed.runnable_avg.max
>       65.99 ± 27%    -100.0%       0.00        sched_debug.cfs_rq:/kbuild.1.removed.runnable_avg.stddev
>       14.27 ± 27%    -100.0%       0.00        sched_debug.cfs_rq:/kbuild.1.removed.util_avg.avg
>      419.11 ± 25%    -100.0%       0.00        sched_debug.cfs_rq:/kbuild.1.removed.util_avg.max
>       65.99 ± 27%    -100.0%       0.00        sched_debug.cfs_rq:/kbuild.1.removed.util_avg.stddev
>      412.27        +10527.3%      43813        sched_debug.cfs_rq:/kbuild.1.runnable_avg.avg
>      967.14 ±  2%   +4443.7%      43944        sched_debug.cfs_rq:/kbuild.1.runnable_avg.max
>        0.03 ±223%  +1.6e+08%      43681        sched_debug.cfs_rq:/kbuild.1.runnable_avg.min
>      368.39           -64.4%     131.08 ±101%  sched_debug.cfs_rq:/kbuild.1.runnable_avg.stddev
>       13.05 ± 10%   +7646.3%       1011        sched_debug.cfs_rq:/kbuild.1.se->avg.load_avg.avg
>       87.56 ± 16%   +1069.5%       1023        sched_debug.cfs_rq:/kbuild.1.se->avg.load_avg.max
>      412.13        +10524.7%      43787        sched_debug.cfs_rq:/kbuild.1.se->avg.runnable_avg.avg
>      967.47 ±  2%   +4439.4%      43917        sched_debug.cfs_rq:/kbuild.1.se->avg.runnable_avg.max
>        0.03 ±223%  +1.6e+08%      43657        sched_debug.cfs_rq:/kbuild.1.se->avg.runnable_avg.min
>      368.51           -64.7%     129.95 ±101%  sched_debug.cfs_rq:/kbuild.1.se->avg.runnable_avg.stddev
>      411.92          +141.6%     995.10        sched_debug.cfs_rq:/kbuild.1.se->avg.util_avg.avg
>        0.03 ±223%  +3.5e+06%     983.40 ±  2%  sched_debug.cfs_rq:/kbuild.1.se->avg.util_avg.min
>      368.41           -96.8%      11.70 ±100%  sched_debug.cfs_rq:/kbuild.1.se->avg.util_avg.stddev
>      188343          +220.5%     603616        sched_debug.cfs_rq:/kbuild.1.se->exec_start.avg
>      188644          +220.2%     604099        sched_debug.cfs_rq:/kbuild.1.se->exec_start.max
>      186221          +223.9%     603133        sched_debug.cfs_rq:/kbuild.1.se->exec_start.min
>       51889 ±  7%   +1920.8%    1048576        sched_debug.cfs_rq:/kbuild.1.se->load.weight.avg
>      176539 ± 22%    +494.0%    1048576        sched_debug.cfs_rq:/kbuild.1.se->load.weight.max
>        1173 ± 53%  +89267.3%    1048576        sched_debug.cfs_rq:/kbuild.1.se->load.weight.min
>       41159 ± 21%    -100.0%       0.00        sched_debug.cfs_rq:/kbuild.1.se->load.weight.stddev
>       44377         +1155.3%     557089        sched_debug.cfs_rq:/kbuild.1.se->sum_exec_runtime.avg
>       52129          +968.7%     557092        sched_debug.cfs_rq:/kbuild.1.se->sum_exec_runtime.max
>       36817 ±  2%   +1413.1%     557086        sched_debug.cfs_rq:/kbuild.1.se->sum_exec_runtime.min
>        3173 ±  5%     -99.9%       3.27 ±100%  sched_debug.cfs_rq:/kbuild.1.se->sum_exec_runtime.stddev
>     2490096           -76.7%     580821        sched_debug.cfs_rq:/kbuild.1.se->vruntime.avg
>     2932328           -80.2%     581126        sched_debug.cfs_rq:/kbuild.1.se->vruntime.max
>     2062018 ±  2%     -71.8%     580516        sched_debug.cfs_rq:/kbuild.1.se->vruntime.min
>      182836 ±  7%     -99.8%     305.00 ±101%  sched_debug.cfs_rq:/kbuild.1.se->vruntime.stddev
>    -2388892           -78.0%    -525720        sched_debug.cfs_rq:/kbuild.1.spread0.avg
>    -2376905           -77.9%    -525711        sched_debug.cfs_rq:/kbuild.1.spread0.max
>    -2400349           -78.1%    -525729        sched_debug.cfs_rq:/kbuild.1.spread0.min
>        5008 ±  7%     -99.8%       9.10 ±100%  sched_debug.cfs_rq:/kbuild.1.spread0.stddev
>       59728 ±  4%     -16.5%      49878        sched_debug.cfs_rq:/kbuild.1.tg_load_avg.max
>        2203 ± 20%     -99.9%       1.82 ±223%  sched_debug.cfs_rq:/kbuild.1.tg_load_avg.stddev
>      661.43 ±  3%   +7393.3%      49562        sched_debug.cfs_rq:/kbuild.1.tg_load_avg_contrib.avg
>        2655 ± 11%   +1778.5%      49878        sched_debug.cfs_rq:/kbuild.1.tg_load_avg_contrib.max
>        0.03 ±223%  +1.8e+08%      49246 ±  2%  sched_debug.cfs_rq:/kbuild.1.tg_load_avg_contrib.min
>      412.06          +140.8%     992.05        sched_debug.cfs_rq:/kbuild.1.util_avg.avg
>        0.03 ±223%  +3.5e+06%     980.41 ±  2%  sched_debug.cfs_rq:/kbuild.1.util_avg.min
>      368.29           -96.8%      11.64 ±100%  sched_debug.cfs_rq:/kbuild.1.util_avg.stddev
>        0.00 ± 27%  +7.1e+08%       6.35 ± 16%  sched_debug.cfs_rq:/system.slice.MIN_vruntime.avg
>        0.00 ± 27%  +2.9e+09%      25.72        sched_debug.cfs_rq:/system.slice.MIN_vruntime.max
>        0.00 ± 27%     -70.0%       0.00 ± 25%  sched_debug.cfs_rq:/system.slice.MIN_vruntime.min
>      739.56 ± 54%     -90.0%      73.75 ± 36%  sched_debug.cfs_rq:/system.slice.load_avg.max
>      183.19 ± 53%     -82.7%      31.64 ± 37%  sched_debug.cfs_rq:/system.slice.load_avg.stddev
>        0.00 ± 27%  +7.3e+08%       6.45 ± 17%  sched_debug.cfs_rq:/system.slice.max_vruntime.avg
>        0.00 ± 27%  +2.9e+09%      26.12        sched_debug.cfs_rq:/system.slice.max_vruntime.max
>        0.00 ± 27%     -70.0%       0.00 ± 25%  sched_debug.cfs_rq:/system.slice.max_vruntime.min
>       30.65 ± 43%   +4649.8%       1455 ± 30%  sched_debug.cfs_rq:/system.slice.min_vruntime.avg
>       97.37 ± 36%   +1415.3%       1475 ± 30%  sched_debug.cfs_rq:/system.slice.min_vruntime.max
>        4.88 ±263%  +29568.6%       1449 ± 30%  sched_debug.cfs_rq:/system.slice.min_vruntime.min
>      739.56 ± 54%     -90.0%      73.75 ± 36%  sched_debug.cfs_rq:/system.slice.runnable_avg.max
>      183.44 ± 53%     -82.8%      31.64 ± 37%  sched_debug.cfs_rq:/system.slice.runnable_avg.stddev
>      698.25 ± 54%     -92.7%      51.19        sched_debug.cfs_rq:/system.slice.se->avg.load_avg.max
>      173.10 ± 53%     -87.3%      21.91 ±  5%  sched_debug.cfs_rq:/system.slice.se->avg.load_avg.stddev
>      739.56 ± 54%     -90.0%      73.76 ± 36%  sched_debug.cfs_rq:/system.slice.se->avg.runnable_avg.max
>      183.45 ± 53%     -82.8%      31.64 ± 37%  sched_debug.cfs_rq:/system.slice.se->avg.runnable_avg.stddev
>       50.39 ± 53%     -89.1%       5.49 ± 40%  sched_debug.cfs_rq:/system.slice.se->avg.util_avg.avg
>      739.39 ± 54%     -97.0%      22.29 ± 38%  sched_debug.cfs_rq:/system.slice.se->avg.util_avg.max
>      183.41 ± 53%     -94.8%       9.54 ± 39%  sched_debug.cfs_rq:/system.slice.se->avg.util_avg.stddev
>       10507 ± 54%     -92.1%     828.57 ±  5%  sched_debug.cfs_rq:/system.slice.se->exec_start.stddev
>      796179 ± 45%     -80.2%     157286 ± 19%  sched_debug.cfs_rq:/system.slice.se->load.weight.max
>        2018 ± 70%   +7694.2%     157286 ± 19%  sched_debug.cfs_rq:/system.slice.se->load.weight.min
>      299826 ± 43%    -100.0%       0.00        sched_debug.cfs_rq:/system.slice.se->load.weight.stddev
>       14.57 ±103%  +10710.8%       1574 ± 30%  sched_debug.cfs_rq:/system.slice.se->sum_exec_runtime.avg
>       98.32 ± 35%   +1522.3%       1595 ± 29%  sched_debug.cfs_rq:/system.slice.se->sum_exec_runtime.max
>        5.78 ±222%  +27036.3%       1568 ± 30%  sched_debug.cfs_rq:/system.slice.se->sum_exec_runtime.min
>       10560 ± 60%     -95.1%     519.51 ± 12%  sched_debug.cfs_rq:/system.slice.se->vruntime.stddev
>      781.68 ± 54%     -89.7%      80.14 ± 30%  sched_debug.cfs_rq:/system.slice.tg_load_avg.avg
>      783.75 ± 54%     -88.9%      86.65 ± 31%  sched_debug.cfs_rq:/system.slice.tg_load_avg.max
>      779.86 ± 54%     -90.5%      73.87 ± 36%  sched_debug.cfs_rq:/system.slice.tg_load_avg.min
>      739.36 ± 54%     -90.0%      73.87 ± 36%  sched_debug.cfs_rq:/system.slice.tg_load_avg_contrib.max
>      183.14 ± 53%     -82.7%      31.69 ± 37%  sched_debug.cfs_rq:/system.slice.tg_load_avg_contrib.stddev
>       50.40 ± 53%     -89.1%       5.49 ± 40%  sched_debug.cfs_rq:/system.slice.util_avg.avg
>      739.39 ± 54%     -97.0%      22.29 ± 38%  sched_debug.cfs_rq:/system.slice.util_avg.max
>      183.40 ± 53%     -94.8%       9.54 ± 39%  sched_debug.cfs_rq:/system.slice.util_avg.stddev
>      130276 ±  3%     -53.9%      60023 ± 30%  sched_debug.cpu.avg_idle.stddev
>      190561          +223.2%     615836        sched_debug.cpu.clock.avg
>      190566          +223.2%     615963        sched_debug.cpu.clock.max
>      190557          +223.1%     615766        sched_debug.cpu.clock.min
>        2.49 ±  2%   +3195.3%      82.17 ± 10%  sched_debug.cpu.clock.stddev
>      188349          +223.1%     608620        sched_debug.cpu.clock_task.avg
>      188650          +224.3%     611860        sched_debug.cpu.clock_task.max
>      186038          +224.3%     603373        sched_debug.cpu.clock_task.min
>      370.07 ± 40%    +680.3%       2887 ± 40%  sched_debug.cpu.clock_task.stddev
>       15323 ± 17%     -97.1%     451.92 ±  5%  sched_debug.cpu.curr->pid.avg
>       16512 ± 12%     -74.5%       4215 ±  5%  sched_debug.cpu.curr->pid.stddev
>        0.00 ±  5%    +351.8%       0.00 ± 10%  sched_debug.cpu.next_balance.stddev
>        0.38           +40.2%       0.54        sched_debug.cpu.nr_running.avg
>        1.11 ±  7%   +4138.2%      47.09        sched_debug.cpu.nr_running.max
>        0.42         +1084.1%       4.99        sched_debug.cpu.nr_running.stddev
>       34116           -48.2%      17664        sched_debug.cpu.nr_switches.avg
>       66559 ±  6%   +1204.5%     868266        sched_debug.cpu.nr_switches.max
>       26193 ±  2%     -96.9%     813.00 ±  3%  sched_debug.cpu.nr_switches.min
>        7164 ±  3%   +1254.8%      97055        sched_debug.cpu.nr_switches.stddev
>      190557          +223.1%     615766        sched_debug.cpu_clk
>      189985          +223.8%     615197        sched_debug.ktime
>      193775          +219.7%     619543        sched_debug.sched_clk
>
>
>
>
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
>
>


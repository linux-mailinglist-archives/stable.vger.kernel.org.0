Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E126B4E1A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 18:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCJRLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 12:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCJRLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 12:11:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFA177E28;
        Fri, 10 Mar 2023 09:11:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9303461B8E;
        Fri, 10 Mar 2023 17:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C86C433EF;
        Fri, 10 Mar 2023 17:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678468268;
        bh=5Ps2RalLOWwRL7VZ/7Agz0Am91ib0CqxqZSPVfmLHsE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=ebf0S7YvPAivJq+cxogI40xhVoaqoxZUgG9dkyAxZNwuvF64+waW1ffGJ/iW/udOx
         Z1wVz83Q/lYKOE3fO8NbpUZBV/S4zmJFUZan+zuk3AwFAmwiGtzi74MzdiuksyDaLO
         uYJRJvoo+PfJx8JNuvOs8J+q3x9b30+bUbX++3B4XFApzWkPNogjxoVbgenbNrb7fL
         GZfvMV+L9R16kT7fZz8qrqUXCLHaIuQkQFFA6D++n7s2dXa8f61AoTLQKbS56tl5xj
         u7bFlIZU0RwdsrGJs0kXjHqDZNpysx7x9dU7BwGg4E269+LhvRfgtJkK2NeUG14gKU
         sX8A9AifaMNGA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 82FA9154034B; Fri, 10 Mar 2023 09:11:07 -0800 (PST)
Date:   Fri, 10 Mar 2023 09:11:07 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Antonio Paolillo <antonio.paolillo@huawei.com>
Cc:     longman@redhat.com, David.Laight@aculab.com, akpm@osdl.org,
        arjan@linux.intel.com, boqun.feng@gmail.com,
        diogo.behrens@huawei.com, hernan.poncedeleon@huaweicloud.com,
        hernanl.leon@huawei.com, joel@joelfernandes.org,
        jonas.oberhauser@huawei.com, jonas.oberhauser@huaweicloud.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu, tglx@linutronix.de, will@kernel.org
Subject: Re: lock_torture results for different patches:
Message-ID: <bd01e9aa-bcf5-4ac1-961d-e969cff2b3f1@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <4122ef0d-1508-8ce2-df80-874565a612ce@redhat.com>
 <20230301163214.17530-1-antonio.paolillo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301163214.17530-1-antonio.paolillo@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 05:32:14PM +0100, Antonio Paolillo wrote:
> Dear all,
> 
> I want to provide some support to Hernan regarding performance claims.
> 
> I used lock_torture to evaluate the different proposed patches on two
> different server machines:
> - a Huawei TaiShan 200 (Model 2280) rack server that has 128 GB of RAM
>   and 2x Kunpeng 920-4826 processors, a HiSilicon chip with 48 ARMv8.2
>   64-bit cores totaling 96 cores (no SMT) [1, 2],
>   denoted as taishan200-96c;
> - a GIGABYTE R182-Z91-00 rack server that has 128 GB of RAM and 2x
>   EPYC 7352 processors, an AMD chip with 24 x86_64 cores, totaling 48
>   cores (96 CPUs when counting hyperthreading) [3, 4],
>   denoted as gigabyte-96c.
> 
> I ran the evaluation on a Ubuntu 22.04 distro, with custom kernels based
> on v6.2-rc6 (6d796c50f84ca79f1722bb131799e5a5710c4700).
> The different kernels are combination of patches:
> - (0) Stock kernel;
> - (1) With relaxed set owner barrier (as discussed in [5] and questioned
>   by Peter, the barrier seems not to be needed);
> - (2) With READ_ONCE(), as originally proposed in this thread;
> - (3) With atomic_long_or() as proposed by Peter;
> - (4) With relaxed set owner barrier and READ_ONCE();
> - (5) With relaxed set owner barrier and atomic_long_or().
> 
> I ran lock_torture several times, exploring the following parameter
> space:
> - torture_type="rtmutex_lock",
> - nwriters_stress=[1, 2, 3, 4, 8, 16, 32, 64, 95],
> - stat_interval=4,
> - stutter=0,
> - shuffle_interval=0.
> For each value of "nwriters_stress", I ran the configuration 5 times.
> 
> By feeding the lock_torture kthread pids to "taskset -p", I overruled
> the scheduling such that the distribution of kthreads to CPUs is fixed.
> I also disabled "irq balance" and "numa balance" daemons, fixed the
> frequency to 1.5GHz using the "userspace" cpufreq governor and isolated
> all the cores used (using isolcpus=1-95 at boot-time) to avoid any
> source of interference.
> 
> As a warm-up phase, I ignored the first reported results and only
> considered the latest 60 seconds of execution (after all kthreads
> migrated to their final CPU).
> The reported throughput is computed by dividing the reported number of
> operations by the duration of the measurement for each dot (60 seconds),
> so higher is better.
> 
> Here follows the results on taishan200-96c (the 'rel' column is the mean
> relative to the mean of the stock kernel, in percent, and each mean is
> the average over 5 independent runs):
> 
> Kernel:             k0-stock-6.2.0-rc6       k1-rmacq             k2-readonce             k3-alongor             k4-rmacq+readonce             k5-rmacq+alongor            
> Statistic (kops/s):               mean   std     mean   std   rel        mean   std   rel       mean   std   rel              mean   std   rel             mean   std   rel
> nwriters_stress:                                                                                                                                                           
> 1                               899.91 24.95   880.10 29.62   -2%      871.57 44.27   -3%     888.65 37.90   -1%            898.63 29.82   -0%           889.83 25.64   -1%
> 2                               359.30 25.92   416.83 32.77  +16%      360.65 28.32   +0%     404.79 42.64  +13%            380.65 21.29   +6%           404.37 23.27  +13%
> 3                               314.97 24.32   308.41  9.68   -2%      315.00  9.97   +0%     313.86 13.47   -0%            313.47  4.01   -0%           322.77 20.82   +2%
> 4                               328.02 15.09   330.65 29.33   +1%      314.83 24.28   -4%     305.71 12.72   -7%            322.95 10.39   -2%           343.32 13.73   +5%
> 8                               292.16 22.03   288.85 10.50   -1%      288.28 18.84   -1%     285.42 24.58   -2%            310.23 26.08   +6%           285.67 20.03   -2%
> 16                              297.03 26.89   281.89 29.22   -5%      265.19 33.73  -11%     279.02 22.43   -6%            284.40 36.21   -4%           285.21 36.33   -4%
> 32                              187.36 28.59   175.71 19.77   -6%      186.44 48.15   -0%     206.59 14.11  +10%            174.08 24.30   -7%           185.80 45.12   -1%
> 64                              148.13 48.65   172.48 34.29  +16%      154.59 47.05   +4%     164.22 29.81  +11%            142.13 47.40   -4%           136.39 29.95   -8%
> 95                              174.35 57.89   148.59 38.03  -15%      156.85 43.64  -10%     132.92 32.35  -24%            126.44 28.24  -27%           146.82 60.04  -16%
> 
> And the results on gigabyte-96c:
> 
> Kernel:             k0-stock-6.2.0-rc6       k1-rmacq               k2-readonce             k3-alongor             k4-rmacq+readonce             k5-rmacq+alongor            
> Statistic (kops/s):               mean   std     mean    std    rel        mean   std   rel       mean   std   rel              mean   std   rel             mean    std  rel
> nwriters_stress:                                                                                                                                                             
> 1                               713.72 25.68   707.32  17.73    -1%      718.81 12.63   +1%     712.80 13.57   -0%            709.17 14.10   -1%           730.33   9.14  +2%
> 2                               376.25  8.19   400.09  16.24    +6%      396.71 26.09   +5%     412.61 17.80  +10%            396.48  7.02   +5%           409.90  14.61  +9%
> 3                               415.07 16.83   410.19  19.82    -1%      423.39  9.68   +2%     417.28 10.23   +1%            424.94 17.48   +2%           422.92  11.75  +2%
> 4                               286.77 26.63   285.13   6.80    -1%      297.33 23.62   +4%     296.49 16.60   +3%            303.99 30.38   +6%           296.93   9.90  +4%
> 8                               296.56 20.45   308.97  12.53    +4%      305.49 19.91   +3%     294.24 17.24   -1%            294.71 24.03   -1%           294.09  25.20  -1%
> 16                              257.34 33.94   266.03  29.60    +3%      270.72 35.22   +5%     252.28 50.16   -2%            263.83 45.84   +3%           247.42  41.01  -4%
> 32                              278.78 51.45   215.35  68.40   -23%      259.77 87.44   -7%     217.26 79.67  -22%            201.23 70.46  -28%           282.47 116.65  +1%
> 64                               75.82 64.87   194.52 137.19  +157%       35.57 12.14  -53%      74.24 72.04   -2%             71.29 45.55   -6%            77.93  43.57  +3%
> 95                               60.37 68.13   198.38 116.93  +229%       43.12 17.60  -29%      58.80 36.47   -3%             57.78 63.00   -4%            61.33  71.18  +2%
> 
> We can safely conclude that the patches do not significatively affect
> the throughput of the lock_torture benchmark for rtmutex_lock.
> The values for nwriters_stress>=64 can safely be ignored as they are too
> spread.

Just so you know, locktorture is intended to be a stress test rather
than a performance benchmark.  Hugo Guiroux's dissertation gives a
much better locking performance methodology:

https://hugoguiroux.github.io/assets/these.pdf

							Thanx, Paul

> Please notice that I pushed a landing page [6] with results in HTML that
> may be more convenient to browse together with interactive charts.
> 
> Cheers,
> 
> Antonio
> 
> [1] https://e.huawei.com/uk/products/servers/taishan-server/taishan-2280-v2
> [2] https://en.wikichip.org/wiki/hisilicon/kunpeng/920-4826
> [3] https://www.gigabyte.com/Rack-Server/R182-Z91-rev-100
> [4] https://www.amd.com/en/products/cpu/amd-epyc-7352
> [5] https://lkml.org/lkml/2023/1/22/160
> [6] https://antonio.paolillo.be/public/rtlocks-locktorture-patches.html
> 

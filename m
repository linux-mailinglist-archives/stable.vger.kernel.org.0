Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CFC4D9000
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 00:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244106AbiCNXD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 19:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238795AbiCNXD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 19:03:29 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148513A5E7;
        Mon, 14 Mar 2022 16:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647298938; x=1678834938;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t7C/pcYibGXzuw1c7KT4Go7pZLQBu1j2wb9INd1xCZM=;
  b=TXWzrIinVGabdNU8yziLIBVl0joTOxV+usC9itSaefyR8RrDrxozn2ru
   OvhOkD/LkL5U4BakdXJJA9mCSw3uMvgVODaUaoKqT7jRurobZwwGtBhHi
   vkqaB7JN91VGExDTfI5kvnUrZaKFd11cS4rHwGf0jKAuFSCP3fwYBF/RA
   5hI39HtmS48lkCNZykQAHLjlXc6gOWzKiNtIdaXxnHpvhvKzhYee+9Nqd
   WCnuVmhiRH6QA4L5LQPCZmHgwEFZ7UCD/DJR+wJ1wtM3hNFLSN3i4ReY8
   zzlYTT2Vp5dIMhamZGIMap7apFZaVyim0+4e/qmb3nZqrFQZHVSKxHqeG
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236769721"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="236769721"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 16:02:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="515638274"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2022 16:02:13 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nTthc-000AJg-BB; Mon, 14 Mar 2022 23:02:12 +0000
Date:   Tue, 15 Mar 2022 07:02:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Darren Hart <darren@os.amperecomputing.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] arch_topology: Swap MC & CLS SD mask if MC weight==1 &
Message-ID: <202203150659.T51bnDgz-lkp@intel.com>
References: <9398d7ad-30e7-890a-3e18-c3011c383585@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9398d7ad-30e7-890a-3e18-c3011c383585@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dietmar,

I love your patch! Perhaps something to improve:

[auto build test WARNING on driver-core/driver-core-testing]
[also build test WARNING on v5.17-rc8 next-20220310]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Dietmar-Eggemann/arch_topology-Swap-MC-CLS-SD-mask-if-MC-weight-1/20220315-004742
base:   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git 4a248f85b3dd8e010ff8335755c927130e9b0764
config: riscv-randconfig-r042-20220314 (https://download.01.org/0day-ci/archive/20220315/202203150659.T51bnDgz-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 3e4950d7fa78ac83f33bbf1658e2f49a73719236)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/0day-ci/linux/commit/7528fb2ea1e30038ee1dcc48df9d413502977895
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Dietmar-Eggemann/arch_topology-Swap-MC-CLS-SD-mask-if-MC-weight-1/20220315-004742
        git checkout 7528fb2ea1e30038ee1dcc48df9d413502977895
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/base/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/base/arch_topology.c:617:23: warning: no previous prototype for function '_cpu_coregroup_mask' [-Wmissing-prototypes]
   const struct cpumask *_cpu_coregroup_mask(int cpu)
                         ^
   drivers/base/arch_topology.c:617:7: note: declare 'static' if the function is not intended to be used outside of this translation unit
   const struct cpumask *_cpu_coregroup_mask(int cpu)
         ^
   static 
>> drivers/base/arch_topology.c:634:23: warning: no previous prototype for function '_cpu_clustergroup_mask' [-Wmissing-prototypes]
   const struct cpumask *_cpu_clustergroup_mask(int cpu)
                         ^
   drivers/base/arch_topology.c:634:7: note: declare 'static' if the function is not intended to be used outside of this translation unit
   const struct cpumask *_cpu_clustergroup_mask(int cpu)
         ^
   static 
   2 warnings generated.


vim +/_cpu_coregroup_mask +617 drivers/base/arch_topology.c

   616	
 > 617	const struct cpumask *_cpu_coregroup_mask(int cpu)
   618	{
   619		const cpumask_t *core_mask = cpumask_of_node(cpu_to_node(cpu));
   620	
   621		/* Find the smaller of NUMA, core or LLC siblings */
   622		if (cpumask_subset(&cpu_topology[cpu].core_sibling, core_mask)) {
   623			/* not numa in package, lets use the package siblings */
   624			core_mask = &cpu_topology[cpu].core_sibling;
   625		}
   626		if (cpu_topology[cpu].llc_id != -1) {
   627			if (cpumask_subset(&cpu_topology[cpu].llc_sibling, core_mask))
   628				core_mask = &cpu_topology[cpu].llc_sibling;
   629		}
   630	
   631		return core_mask;
   632	}
   633	
 > 634	const struct cpumask *_cpu_clustergroup_mask(int cpu)
   635	{
   636		return &cpu_topology[cpu].cluster_sibling;
   637	}
   638	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

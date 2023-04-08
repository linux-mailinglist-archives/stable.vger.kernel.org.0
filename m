Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A036DB9AF
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 10:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjDHIfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 04:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDHIfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 04:35:45 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5880D52D;
        Sat,  8 Apr 2023 01:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680942944; x=1712478944;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lxkkBZdI9k/nHA+MzzcXBFUD0IJeMAc31c2hhqC60EQ=;
  b=OoE2s60dmCPnLta+MCTZtXGK+2I2+G+XON/kKOu2kL7wxnqNfUIG8M6Y
   16f4rH4WQLPy/m9zmd9nkqI52QiGra948IWZhNeIRUuk1sNWZIBrWV3v0
   exC3QQIPXOmChzAVP5oZfNMgBgqBXSR6U4xuNf8EWq11mAtbjLOzpsw9u
   7UoPusx8UTLTGeTGGOCJDAng9hW0OkB36COOhPFNmJHf/o8O7ckgORCPr
   5/eKDckGHf98xajY/fffE8sd28g5L2dFSFPnsXqIei+A3St+z1gqp83hL
   yGGAHO0B+87k3TnGj6HD7gIdzJ0hG4sXNGQlFB/KQ0S+3x0Rh401C1i0E
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="331785177"
X-IronPort-AV: E=Sophos;i="5.98,329,1673942400"; 
   d="scan'208";a="331785177"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2023 01:35:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="752249577"
X-IronPort-AV: E=Sophos;i="5.98,329,1673942400"; 
   d="scan'208";a="752249577"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2023 01:35:40 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pl42t-000TXp-20;
        Sat, 08 Apr 2023 08:35:39 +0000
Date:   Sat, 8 Apr 2023 16:35:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tze-nan Wu <Tze-nan.Wu@mediatek.com>, rostedt@goodmis.org,
        mhiramat@kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        bobule.chang@mediatek.com, wsd_upstream@mediatek.com,
        Tze-nan.Wu@mediatek.com, stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
Message-ID: <202304081615.eiaqpbV8-lkp@intel.com>
References: <20230408052226.25268-1-Tze-nan.Wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408052226.25268-1-Tze-nan.Wu@mediatek.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tze-nan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on rostedt-trace/for-next v6.3-rc5 next-20230406]
[cannot apply to rostedt-trace/for-next-urgent]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tze-nan-Wu/ring-buffer-Prevent-inconsistent-operation-on-cpu_buffer-resize_disabled/20230408-132502
patch link:    https://lore.kernel.org/r/20230408052226.25268-1-Tze-nan.Wu%40mediatek.com
patch subject: [PATCH] ring-buffer: Prevent inconsistent operation on cpu_buffer->resize_disabled
config: x86_64-randconfig-a002-20230403 (https://download.01.org/0day-ci/archive/20230408/202304081615.eiaqpbV8-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d404bc0af0a4bde3aa20704642d69a78bdc154f8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tze-nan-Wu/ring-buffer-Prevent-inconsistent-operation-on-cpu_buffer-resize_disabled/20230408-132502
        git checkout d404bc0af0a4bde3aa20704642d69a78bdc154f8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash kernel/trace/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304081615.eiaqpbV8-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/trace/ring_buffer.c:5359:15: warning: variable 'reset_online_mask' is uninitialized when used here [-Wuninitialized]
           cpumask_copy(reset_online_mask, cpu_online_mask);
                        ^~~~~~~~~~~~~~~~~
   kernel/trace/ring_buffer.c:5353:33: note: initialize the variable 'reset_online_mask' to silence this warning
           cpumask_var_t reset_online_mask;
                                          ^
                                           = NULL
   1 warning generated.


vim +/reset_online_mask +5359 kernel/trace/ring_buffer.c

  5344	
  5345	/**
  5346	 * ring_buffer_reset_online_cpus - reset a ring buffer per CPU buffer
  5347	 * @buffer: The ring buffer to reset a per cpu buffer of
  5348	 * @cpu: The CPU buffer to be reset
  5349	 */
  5350	void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
  5351	{
  5352		struct ring_buffer_per_cpu *cpu_buffer;
  5353		cpumask_var_t reset_online_mask;
  5354		int cpu;
  5355	
  5356		/* prevent another thread from changing buffer sizes */
  5357		mutex_lock(&buffer->mutex);
  5358	
> 5359		cpumask_copy(reset_online_mask, cpu_online_mask);
  5360	
  5361		for_each_cpu_and(cpu, buffer->cpumask, reset_online_mask) {
  5362			cpu_buffer = buffer->buffers[cpu];
  5363	
  5364			atomic_inc(&cpu_buffer->resize_disabled);
  5365			atomic_inc(&cpu_buffer->record_disabled);
  5366		}
  5367	
  5368		/* Make sure all commits have finished */
  5369		synchronize_rcu();
  5370	
  5371		for_each_cpu_and(cpu, buffer->cpumask, reset_online_mask) {
  5372			cpu_buffer = buffer->buffers[cpu];
  5373	
  5374			reset_disabled_cpu_buffer(cpu_buffer);
  5375	
  5376			atomic_dec(&cpu_buffer->record_disabled);
  5377			atomic_dec(&cpu_buffer->resize_disabled);
  5378		}
  5379	
  5380		mutex_unlock(&buffer->mutex);
  5381	}
  5382	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

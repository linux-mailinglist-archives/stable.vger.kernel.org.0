Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE296DBAD3
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 14:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDHMVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 08:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDHMVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 08:21:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B169F4;
        Sat,  8 Apr 2023 05:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680956511; x=1712492511;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eW13kTIIAfgyJU8/U8MXPKMLhPp5eP1G5Lfen3ZIMtc=;
  b=VBI1VWlLlICHD5offjd5ZLtQphwSd3h66zRvIKRrF3TnRihiMLVch79f
   Mhgyc5xbb4vQxNBuTqsECdsHuT4T5RN4FYPebPxr4i9kuhSC7yWzpu2o5
   9elKmxbnbS1Dn2qgpZ5LcgqqDpeSdkPrDgiqj2DZz+9ZdYrL+h7v7mgju
   3KEYmXDR1e095vRZSsrgnWZEysgQWgd+eX4wYTX8yhABz4Y0pCkfmoGcA
   SHg4qacsGZJTWpD2RtS67BGE9lZvM8iI01UhcAy+3Tn+scG8FjrXXqSaw
   NmrBOA6GSE+H0xM3a1Ks9K7j+ur+WYYZf+BXYKuZN7AkHU205fF7/n/hi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="322769829"
X-IronPort-AV: E=Sophos;i="5.98,329,1673942400"; 
   d="scan'208";a="322769829"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2023 05:21:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="681274312"
X-IronPort-AV: E=Sophos;i="5.98,329,1673942400"; 
   d="scan'208";a="681274312"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 08 Apr 2023 05:21:48 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pl7Zj-000TiP-1t;
        Sat, 08 Apr 2023 12:21:47 +0000
Date:   Sat, 8 Apr 2023 20:20:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tze-nan Wu <Tze-nan.Wu@mediatek.com>, rostedt@goodmis.org,
        mhiramat@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, bobule.chang@mediatek.com,
        wsd_upstream@mediatek.com, Tze-nan.Wu@mediatek.com,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
Message-ID: <202304082051.Dp50upfS-lkp@intel.com>
References: <20230408052226.25268-1-Tze-nan.Wu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408052226.25268-1-Tze-nan.Wu@mediatek.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tze-nan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[cannot apply to rostedt-trace/for-next-urgent]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tze-nan-Wu/ring-buffer-Prevent-inconsistent-operation-on-cpu_buffer-resize_disabled/20230408-132502
patch link:    https://lore.kernel.org/r/20230408052226.25268-1-Tze-nan.Wu%40mediatek.com
patch subject: [PATCH] ring-buffer: Prevent inconsistent operation on cpu_buffer->resize_disabled
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20230408/202304082051.Dp50upfS-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d404bc0af0a4bde3aa20704642d69a78bdc154f8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tze-nan-Wu/ring-buffer-Prevent-inconsistent-operation-on-cpu_buffer-resize_disabled/20230408-132502
        git checkout d404bc0af0a4bde3aa20704642d69a78bdc154f8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash kernel/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304082051.Dp50upfS-lkp@intel.com/

All warnings (new ones prefixed by >>):

   kernel/trace/ring_buffer.c: In function 'ring_buffer_reset_online_cpus':
>> kernel/trace/ring_buffer.c:5359:9: warning: 'reset_online_mask' is used uninitialized [-Wuninitialized]
    5359 |         cpumask_copy(reset_online_mask, cpu_online_mask);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/trace/ring_buffer.c:5353:23: note: 'reset_online_mask' was declared here
    5353 |         cpumask_var_t reset_online_mask;
         |                       ^~~~~~~~~~~~~~~~~


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

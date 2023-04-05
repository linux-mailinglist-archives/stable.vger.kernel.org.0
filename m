Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34866D7298
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 04:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236720AbjDECwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 22:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbjDECwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 22:52:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0043A90;
        Tue,  4 Apr 2023 19:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680663119; x=1712199119;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4cRIj5k4QHvBFCWEt1UKzqqvkGiVg/SrV18IyE5gB1E=;
  b=GDNhAlCcXvoX2+zV1NQV240eVrEamTeMBb58Un+c/a2ErhD0u0W16C8J
   iXInxcciK/YTN4HwWtkQrmMOl/s/r59EtrYhUfEj24hbZX5wa+41PkkMB
   S27Sarjn9qXaJlbGAFFOfQS1jtBJi0HU2OWO8RIVG0bVcblEN5hU7DS7N
   ToGOQqFUhAyUUAl8X9jb3mVuLEp/rp0KuOeQYdzaLIv+OoMNIjsf+4/Rg
   dKlKuTC/6FdcqWQuHFVXgw5R1Es1d+m2l6bUPMwK2jv4f2jUzRsWk9X1h
   kScm/Dr9u0PsRw3r1N4N3CMhYPn3BE+n0JXuwXQcC1Q9ZCI0TK/yq90Ut
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="322017008"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="322017008"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 19:51:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="663872550"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="663872550"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 04 Apr 2023 19:51:54 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjtFZ-000QDm-2o;
        Wed, 05 Apr 2023 02:51:53 +0000
Date:   Wed, 5 Apr 2023 10:51:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ross Zwisler <zwisler@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing: Fix ftrace_boot_snapshot command line logic
Message-ID: <202304051001.dL3Fvaxd-lkp@intel.com>
References: <20230404230308.501833715@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404230308.501833715@goodmis.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.3-rc5 next-20230404]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Have-tracing_snapshot_instance_cond-write-errors-to-the-appropriate-instance/20230405-070406
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20230404230308.501833715%40goodmis.org
patch subject: [PATCH 2/2] tracing: Fix ftrace_boot_snapshot command line logic
config: arc-buildonly-randconfig-r003-20230403 (https://download.01.org/0day-ci/archive/20230405/202304051001.dL3Fvaxd-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ac5e916ec8d65b5e0c13719694efd3084105f416
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Steven-Rostedt/tracing-Have-tracing_snapshot_instance_cond-write-errors-to-the-appropriate-instance/20230405-070406
        git checkout ac5e916ec8d65b5e0c13719694efd3084105f416
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash kernel/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304051001.dL3Fvaxd-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/trace/trace.c: In function 'ftrace_boot_snapshot':
>> kernel/trace/trace.c:10402:24: error: 'struct trace_array' has no member named 'allocated_snapshot'
   10402 |                 if (!tr->allocated_snapshot)
         |                        ^~


vim +10402 kernel/trace/trace.c

 10393	
 10394	void __init ftrace_boot_snapshot(void)
 10395	{
 10396		struct trace_array *tr;
 10397	
 10398		if (!snapshot_at_boot)
 10399			return;
 10400	
 10401		list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 10402			if (!tr->allocated_snapshot)
 10403				continue;
 10404	
 10405			tracing_snapshot_instance(tr);
 10406			trace_array_puts(tr, "** Boot snapshot taken **\n");
 10407		}
 10408	}
 10409	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

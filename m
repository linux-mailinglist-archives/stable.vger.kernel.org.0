Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68687488583
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 20:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiAHTFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 14:05:11 -0500
Received: from mga05.intel.com ([192.55.52.43]:5105 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbiAHTFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jan 2022 14:05:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641668709; x=1673204709;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K4X8Y8f1pY3S0dmZw5XiasYMbgEQb1XWFb9uzokkf2E=;
  b=VeLAgtqH886m25AZlCzyBUOrLVmwBS77q2YvIxYI5T9kTLCWUBGoRRa5
   B/08SyrLDHNwFNydXoyhWLl1Hscbc1gMaPqmCkhq5EQCXJZfma5ffXMso
   BInYbnA/+vuJdds1ATcwyCqk+OPPXKf45AjMB9CM55Cz7CqpoW7OlctYP
   8DFUjjcpYNvu+M9dMRNIQ/Q+D2auMhhnHFTnaoT25wnSXbtPKr05B/j0W
   Et7LR86U7XP+Lbe/+KE2aPJY7btHnq9p5nLDFRj9cbqygcK/z4DsLTAZO
   /HhBQBGEJNrAK6HCxoXe7waYOKE5fgL3SLckqu7KpXw28dLWuTpiQPnll
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10221"; a="329375662"
X-IronPort-AV: E=Sophos;i="5.88,273,1635231600"; 
   d="scan'208";a="329375662"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2022 11:05:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,273,1635231600"; 
   d="scan'208";a="690141548"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 08 Jan 2022 11:05:06 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n6H1V-0000wc-QO; Sat, 08 Jan 2022 19:05:05 +0000
Date:   Sun, 9 Jan 2022 03:04:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org,
        Pingfan Liu <kernelfans@gmail.com>
Subject: Re: [PATCH 2/2] tracing: Add test for user space strings when
 filtering on string pointers
Message-ID: <202201090343.IKIQqdk4-lkp@intel.com>
References: <20220107225840.003487216@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107225840.003487216@goodmis.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Steven,

I love your patch! Perhaps something to improve:

[auto build test WARNING on rostedt-trace/for-next]
[also build test WARNING on linux/master linus/master hnaz-mm/master v5.16-rc8 next-20220107]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Steven-Rostedt/tracing-Fix-filtering-on-string-pointers/20220108-070047
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git for-next
config: openrisc-randconfig-s031-20220107 (https://download.01.org/0day-ci/archive/20220109/202201090343.IKIQqdk4-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/19b8c1c0fee0d7bff07ed0d5862a29ac2bb4adc9
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Steven-Rostedt/tracing-Fix-filtering-on-string-pointers/20220108-070047
        git checkout 19b8c1c0fee0d7bff07ed0d5862a29ac2bb4adc9
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=openrisc SHELL=/bin/bash kernel/trace/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> kernel/trace/trace_events_filter.c:685:22: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected char [noderef] __user *ustr @@     got char *str @@
   kernel/trace/trace_events_filter.c:685:22: sparse:     expected char [noderef] __user *ustr
   kernel/trace/trace_events_filter.c:685:22: sparse:     got char *str
>> kernel/trace/trace_events_filter.c:685:22: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected char [noderef] __user *ustr @@     got char *str @@
   kernel/trace/trace_events_filter.c:685:22: sparse:     expected char [noderef] __user *ustr
   kernel/trace/trace_events_filter.c:685:22: sparse:     got char *str
>> kernel/trace/trace_events_filter.c:685:22: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected char [noderef] __user *ustr @@     got char *str @@
   kernel/trace/trace_events_filter.c:685:22: sparse:     expected char [noderef] __user *ustr
   kernel/trace/trace_events_filter.c:685:22: sparse:     got char *str
>> kernel/trace/trace_events_filter.c:685:22: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected char [noderef] __user *ustr @@     got char *str @@
   kernel/trace/trace_events_filter.c:685:22: sparse:     expected char [noderef] __user *ustr
   kernel/trace/trace_events_filter.c:685:22: sparse:     got char *str
>> kernel/trace/trace_events_filter.c:685:22: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected char [noderef] __user *ustr @@     got char *str @@
   kernel/trace/trace_events_filter.c:685:22: sparse:     expected char [noderef] __user *ustr
   kernel/trace/trace_events_filter.c:685:22: sparse:     got char *str
>> kernel/trace/trace_events_filter.c:685:22: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected char [noderef] __user *ustr @@     got char *str @@
   kernel/trace/trace_events_filter.c:685:22: sparse:     expected char [noderef] __user *ustr
   kernel/trace/trace_events_filter.c:685:22: sparse:     got char *str
>> kernel/trace/trace_events_filter.c:685:22: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected char [noderef] __user *ustr @@     got char *str @@
   kernel/trace/trace_events_filter.c:685:22: sparse:     expected char [noderef] __user *ustr
   kernel/trace/trace_events_filter.c:685:22: sparse:     got char *str
   kernel/trace/trace_events_filter.c:1066:20: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected struct event_filter * @@     got struct event_filter [noderef] __rcu *filter @@
   kernel/trace/trace_events_filter.c:1066:20: sparse:     expected struct event_filter *
   kernel/trace/trace_events_filter.c:1066:20: sparse:     got struct event_filter [noderef] __rcu *filter
   kernel/trace/trace_events_filter.c:1136:34: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct event_filter *filter @@     got struct event_filter [noderef] __rcu *filter @@
   kernel/trace/trace_events_filter.c:1136:34: sparse:     expected struct event_filter *filter
   kernel/trace/trace_events_filter.c:1136:34: sparse:     got struct event_filter [noderef] __rcu *filter
   kernel/trace/trace_events_filter.c:1153:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct event_filter *filter @@     got struct event_filter [noderef] __rcu *filter @@
   kernel/trace/trace_events_filter.c:1153:27: sparse:     expected struct event_filter *filter
   kernel/trace/trace_events_filter.c:1153:27: sparse:     got struct event_filter [noderef] __rcu *filter
   kernel/trace/trace_events_filter.c:1066:20: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected struct event_filter * @@     got struct event_filter [noderef] __rcu *filter @@
   kernel/trace/trace_events_filter.c:1066:20: sparse:     expected struct event_filter *
   kernel/trace/trace_events_filter.c:1066:20: sparse:     got struct event_filter [noderef] __rcu *filter
   kernel/trace/trace_events_filter.c:1066:20: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected struct event_filter * @@     got struct event_filter [noderef] __rcu *filter @@
   kernel/trace/trace_events_filter.c:1066:20: sparse:     expected struct event_filter *
   kernel/trace/trace_events_filter.c:1066:20: sparse:     got struct event_filter [noderef] __rcu *filter
   kernel/trace/trace_events_filter.c:1066:20: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected struct event_filter * @@     got struct event_filter [noderef] __rcu *filter @@
   kernel/trace/trace_events_filter.c:1066:20: sparse:     expected struct event_filter *
   kernel/trace/trace_events_filter.c:1066:20: sparse:     got struct event_filter [noderef] __rcu *filter

vim +685 kernel/trace/trace_events_filter.c

   666	
   667	static __always_inline char *test_string(char *str)
   668	{
   669		struct ustring_buffer *ubuf;
   670		char __user *ustr;
   671		char *kstr;
   672	
   673		if (!ustring_per_cpu)
   674			return NULL;
   675	
   676		ubuf = this_cpu_ptr(ustring_per_cpu);
   677		kstr = ubuf->buffer;
   678	
   679		if (likely((unsigned long)str >= TASK_SIZE)) {
   680			/* For safety, do not trust the string pointer */
   681			if (!strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE))
   682				return NULL;
   683		} else {
   684			/* user space address? */
 > 685			ustr = str;
   686			if (!strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE))
   687				return NULL;
   688		}
   689		return kstr;
   690	}
   691	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

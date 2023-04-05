Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16DC6D7256
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 04:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbjDECWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 22:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjDECWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 22:22:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1062A30EE;
        Tue,  4 Apr 2023 19:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680661318; x=1712197318;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o5MUwpw0pi7Od1jbsaS8V7OYPVV0L9QmQToAaq2i768=;
  b=TYHbGcHBGCApoPo3w/EKwg1kE21xQdmPZ6UmLVCYi7pjGrWDtRZ3Z4A8
   3A+bv3ZhzRmQbkv9pCIuWOFwhmXblSOkEQ2/NQqpMxCp0Cx6e2KpK87hH
   XpAgiKwyKQ4WOl8v39/f0xpvpUdNIoKwZk+h4SbpC5IvbLeC5z64HGAAf
   YNnLcFs7KxuDNqKDhLRbXQ+MVvGKZ0S6gO0RqUx/33QYBe3qPCiixixZv
   +lIo+O869JpS9O/5jU9o7drD+OMPLl35nZC8EQQQwHjcoArBJExGrO0Dm
   bHJd0AQeiFFH0WtV086q8DfZh1fw4POLcJc9YC5iTSQgF4BThXhkDFKWR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="341077331"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="341077331"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 19:21:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="860801494"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="860801494"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 04 Apr 2023 19:21:54 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjsmX-000QCs-10;
        Wed, 05 Apr 2023 02:21:53 +0000
Date:   Wed, 5 Apr 2023 10:20:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shaun Tancheff <shaun.tancheff@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     oe-kbuild-all@lists.linux.dev,
        Shaun Tancheff <shaun.tancheff@hpe.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] memcg-v1: Enable setting memory min, low, high
Message-ID: <202304051011.6E3fABwV-lkp@intel.com>
References: <20230404205013.31520-1-shaun.tancheff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404205013.31520-1-shaun.tancheff@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shaun,

kernel test robot noticed the following build errors:

[auto build test ERROR on v6.3-rc5]
[also build test ERROR on linus/master]
[cannot apply to akpm-mm/mm-everything next-20230404]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shaun-Tancheff/memcg-v1-Enable-setting-memory-min-low-high/20230405-045143
patch link:    https://lore.kernel.org/r/20230404205013.31520-1-shaun.tancheff%40gmail.com
patch subject: [PATCH] memcg-v1: Enable setting memory min, low, high
config: i386-randconfig-a011-20230403 (https://download.01.org/0day-ci/archive/20230405/202304051011.6E3fABwV-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/180e4266c809a61c2711599c6462bd719efed76c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shaun-Tancheff/memcg-v1-Enable-setting-memory-min-low-high/20230405-045143
        git checkout 180e4266c809a61c2711599c6462bd719efed76c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304051011.6E3fABwV-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: mm/memcontrol.o: in function `mem_cgroup_v1_set_defaults':
>> mm/memcontrol.c:3878: undefined reference to `__udivdi3'


vim +3878 mm/memcontrol.c

  3853	
  3854	static inline void mem_cgroup_v1_set_defaults(struct mem_cgroup *memcg,
  3855						       u64 nr_pages)
  3856	{
  3857		u64 max = (u64)(PAGE_COUNTER_MAX * PAGE_SIZE) / PAGE_SIZE;
  3858		u64 min, low, high;
  3859	
  3860		if (mem_cgroup_is_root(memcg) || max == nr_pages)
  3861			return;
  3862	
  3863		min = READ_ONCE(memcg->memory.min);
  3864		low = READ_ONCE(memcg->memory.low);
  3865		if (min || low)
  3866			return;
  3867	
  3868		if (!min && memcg_v1_min_default_percent) {
  3869			min = (nr_pages * memcg_v1_min_default_percent) / 100;
  3870			page_counter_set_min(&memcg->memory, min);
  3871		}
  3872		if (!low && memcg_v1_low_default_percent) {
  3873			low = (nr_pages * memcg_v1_low_default_percent) / 100;
  3874			page_counter_set_low(&memcg->memory, low);
  3875		}
  3876		high = READ_ONCE(memcg->memory.high);
  3877		if (high == PAGE_COUNTER_MAX && memcg_v1_high_default_percent) {
> 3878			high = (nr_pages * memcg_v1_high_default_percent) / 100;
  3879			page_counter_set_high(&memcg->memory, high);
  3880		}
  3881	}
  3882	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

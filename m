Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E146D72C3
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 05:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbjDEDxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 23:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbjDEDxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 23:53:03 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00D9107;
        Tue,  4 Apr 2023 20:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680666782; x=1712202782;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Xs2d4Ol2QjDYLWkGXWWGdLuKQ8sE/oI2HYq0eZOM2ck=;
  b=abboD3Jx7g5gpdFaZa/DwZWMBhBhfO2RHjbui4vX1WYhg3oW4wOcWLjB
   gI/wt+vrBCSAUL+dfpqF16Ru/OfT7n84imeja8b3bfc0FF5/UcTkHIqAD
   jIgQ2kD9LUlzCkIMQ/lAw7oIKPVH3cGrq9m7hcEXUHzk7kJkvnD4hhhOU
   GgV8yXBBSoAplmbxVxtFzae6vF5o1/Z7ki42gDQm8QNjmPVOVzkwXuxPK
   oOnHxHPf+/md30bxM+cMAJZEpHknl3GVyf/bC05tOCG16ttBrKVXIJ5pV
   pWb3yeq5H6y3Gi2PddpgJE7xNTxSzJdQ1wAEAYVKAaoAHacbxenkZ5rU1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="344076070"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="344076070"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 20:53:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="775892795"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="775892795"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Apr 2023 20:52:57 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjuCe-000QHa-2f;
        Wed, 05 Apr 2023 03:52:56 +0000
Date:   Wed, 5 Apr 2023 11:52:30 +0800
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
Message-ID: <202304051118.jpLmhRPu-lkp@intel.com>
References: <20230404205013.31520-1-shaun.tancheff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404205013.31520-1-shaun.tancheff@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
config: m68k-randconfig-r023-20230403 (https://download.01.org/0day-ci/archive/20230405/202304051118.jpLmhRPu-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/180e4266c809a61c2711599c6462bd719efed76c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shaun-Tancheff/memcg-v1-Enable-setting-memory-min-low-high/20230405-045143
        git checkout 180e4266c809a61c2711599c6462bd719efed76c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304051118.jpLmhRPu-lkp@intel.com/

All errors (new ones prefixed by >>):

   m68k-linux-ld: m68k-linux-ld: DWARF error: could not find abbrev number 99017497
   mm/memcontrol.o: in function `mem_cgroup_write':
>> memcontrol.c:(.text+0x4548): undefined reference to `__udivdi3'
>> m68k-linux-ld: memcontrol.c:(.text+0x45b4): undefined reference to `__udivdi3'
   m68k-linux-ld: memcontrol.c:(.text+0x45ec): undefined reference to `__udivdi3'
>> m68k-linux-ld: mm/memcontrol.o:(.debug_addr+0x1fc): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

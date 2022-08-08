Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3950958C53D
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 11:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiHHJF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 05:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbiHHJF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 05:05:26 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE3C5F66;
        Mon,  8 Aug 2022 02:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659949525; x=1691485525;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3RSyZs8bPpTGb7akeM8WJGQC1JyjSH4WIuABkHEYcYc=;
  b=Rl+jl+rgkyBlV4kKU56+r0XkfxpcIKrnWjx2rd3nfr6HgM7ufLBQzMlm
   4elYn2mhulbFAoMp3pEICVcMLe31waIoZIj7dTEu3PRVWuRreIlExAk8v
   ppe3+Ymcykbl4e6oYposi8vMiem8vZrrld9lcusdG94NJ205IVp4ptY+2
   20ZI81CYqqMzJn3sRlNkVmhmHe6N4aVBlq1aHb5vcVGt+JfjgQnsZ4pE6
   zWYupnzATXftZ1vOV31ldolttlD/gHzjMwzVuqZMVP2f8EpSDLdKHFFuu
   CuVcjUkr1Bq0FZArgi6vTJGQ10TxvlqJKhRKaFFq04foXQ28yHfThvlE+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="354542111"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="354542111"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 02:05:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="663858497"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 08 Aug 2022 02:05:21 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oKyhM-000MAw-0C;
        Mon, 08 Aug 2022 09:05:20 +0000
Date:   Mon, 8 Aug 2022 17:04:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Wen Jin <wen.jin@intel.com>, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix kdump kernels boot failure with
 scalable mode
Message-ID: <202208081636.6sNc86bT-lkp@intel.com>
References: <20220808034612.1691470-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808034612.1691470-1-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lu,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on next-20220808]
[cannot apply to joro-iommu/next v5.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lu-Baolu/iommu-vt-d-Fix-kdump-kernels-boot-failure-with-scalable-mode/20220808-115156
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 4e23eeebb2e57f5a28b36221aa776b5a1122dde5
config: x86_64-randconfig-a011-20220808 (https://download.01.org/0day-ci/archive/20220808/202208081636.6sNc86bT-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 5f1c7e2cc5a3c07cbc2412e851a7283c1841f520)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/335018299049ac5dc13ff12d320b5952bed7e8f8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Lu-Baolu/iommu-vt-d-Fix-kdump-kernels-boot-failure-with-scalable-mode/20220808-115156
        git checkout 335018299049ac5dc13ff12d320b5952bed7e8f8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from drivers/iommu/intel/dmar.c:33:
>> drivers/iommu/intel/iommu.h:705:14: error: no member named 'copied_tables' in 'struct intel_iommu'
           if (!iommu->copied_tables)
                ~~~~~  ^
   drivers/iommu/intel/iommu.h:708:51: error: no member named 'copied_tables' in 'struct intel_iommu'
           return test_bit(((long)bus << 8) | devfn, iommu->copied_tables);
                                                     ~~~~~  ^
   include/linux/bitops.h:61:50: note: expanded from macro 'test_bit'
   #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
                                                                ^~~~
   include/linux/bitops.h:50:37: note: expanded from macro 'bitop'
             __builtin_constant_p((uintptr_t)(addr) != (uintptr_t)NULL) && \
                                              ^~~~
   In file included from drivers/iommu/intel/dmar.c:33:
   drivers/iommu/intel/iommu.h:708:51: error: no member named 'copied_tables' in 'struct intel_iommu'
           return test_bit(((long)bus << 8) | devfn, iommu->copied_tables);
                                                     ~~~~~  ^
   include/linux/bitops.h:61:50: note: expanded from macro 'test_bit'
   #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
                                                                ^~~~
   include/linux/bitops.h:51:16: note: expanded from macro 'bitop'
             (uintptr_t)(addr) != (uintptr_t)NULL &&                       \
                         ^~~~
   In file included from drivers/iommu/intel/dmar.c:33:
   drivers/iommu/intel/iommu.h:708:51: error: no member named 'copied_tables' in 'struct intel_iommu'
           return test_bit(((long)bus << 8) | devfn, iommu->copied_tables);
                                                     ~~~~~  ^
   include/linux/bitops.h:61:50: note: expanded from macro 'test_bit'
   #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
                                                                ^~~~
   include/linux/bitops.h:52:50: note: expanded from macro 'bitop'
             __builtin_constant_p(*(const unsigned long *)(addr))) ?       \
                                                           ^~~~
   In file included from drivers/iommu/intel/dmar.c:33:
   drivers/iommu/intel/iommu.h:708:51: error: no member named 'copied_tables' in 'struct intel_iommu'
           return test_bit(((long)bus << 8) | devfn, iommu->copied_tables);
                                                     ~~~~~  ^
   include/linux/bitops.h:61:50: note: expanded from macro 'test_bit'
   #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
                                                                ^~~~
   include/linux/bitops.h:53:17: note: expanded from macro 'bitop'
            const##op(nr, addr) : op(nr, addr))
                          ^~~~
   In file included from drivers/iommu/intel/dmar.c:33:
   drivers/iommu/intel/iommu.h:708:51: error: no member named 'copied_tables' in 'struct intel_iommu'
           return test_bit(((long)bus << 8) | devfn, iommu->copied_tables);
                                                     ~~~~~  ^
   include/linux/bitops.h:61:50: note: expanded from macro 'test_bit'
   #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
                                                                ^~~~
   include/linux/bitops.h:53:32: note: expanded from macro 'bitop'
            const##op(nr, addr) : op(nr, addr))
                                         ^~~~
   6 errors generated.


vim +705 drivers/iommu/intel/iommu.h

   702	
   703	static inline bool context_copied(struct intel_iommu *iommu, u8 bus, u8 devfn)
   704	{
 > 705		if (!iommu->copied_tables)
   706			return false;
   707	
   708		return test_bit(((long)bus << 8) | devfn, iommu->copied_tables);
   709	}
   710	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

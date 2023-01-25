Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A082567B2CA
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 13:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbjAYMzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 07:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAYMzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 07:55:11 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42B311152;
        Wed, 25 Jan 2023 04:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674651310; x=1706187310;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MDLw4SI9AuliqMuFsm+CU5yI64+eZZfEdC5qdusTYOc=;
  b=FlpnBgZvzyK2b4n2P4pwOU5xC5OSYIi973TNz2i1qz06/OXuHWQYqTSR
   MCe62wszMz7sHC5zGgUSJqgCZXocXbGXD7CgVs2jhg9ZkGVNHE3tNvgx2
   GSexcAwQPs/G5OKhqaKeTTKjX9ZExLZYqWrJc6lrRzCnIszT5CIo5UJ8U
   Km0rSu7ngnCQa3BO62b6WIyuhe1+qmHH/QfRX0zRD1f+FSl6ffaqbKsZT
   nBXTmyth0KbggafANjNIicezDa7ZBXCWXGVpuGU2wKWdRSs/UeuzuqAWI
   Qab5HfAv7uVj8x5KH2RUNGzMp5RmyLdMbleZyQtW9I16NHc7ap4xU6UhJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="306209620"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="306209620"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 04:55:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="751180484"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="751180484"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Jan 2023 04:55:07 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pKfIx-0007JE-0c;
        Wed, 25 Jan 2023 12:55:07 +0000
Date:   Wed, 25 Jan 2023 20:54:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>,
        Yang Shi <shy828301@gmail.com>,
        Zach O'Keefe <zokeefe@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/MADV_COLLAPSE: catch !none !huge !bad pmd lookups
Message-ID: <202301252033.HoFIRXm4-lkp@intel.com>
References: <20230125015738.912924-2-zokeefe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125015738.912924-2-zokeefe@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Zach,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Zach-O-Keefe/mm-MADV_COLLAPSE-catch-none-huge-bad-pmd-lookups/20230125-095954
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20230125015738.912924-2-zokeefe%40google.com
patch subject: [PATCH 2/2] mm/MADV_COLLAPSE: catch !none !huge !bad pmd lookups
config: x86_64-randconfig-r025-20230123 (https://download.01.org/0day-ci/archive/20230125/202301252033.HoFIRXm4-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6001eb9a8f1687a1d0b72831d991886106cac37b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Zach-O-Keefe/mm-MADV_COLLAPSE-catch-none-huge-bad-pmd-lookups/20230125-095954
        git checkout 6001eb9a8f1687a1d0b72831d991886106cac37b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> mm/khugepaged.c:972:17: error: passing 'pmd_t **' to parameter of incompatible type 'pmd_t'
           if (pmd_devmap(pmd))
                          ^~~
   arch/x86/include/asm/pgtable.h:254:36: note: passing argument to parameter 'pmd' here
   static inline int pmd_devmap(pmd_t pmd)
                                      ^
   1 error generated.


vim +972 mm/khugepaged.c

   945	
   946	/*
   947	 * See pmd_trans_unstable() for how the result may change out from
   948	 * underneath us, even if we hold mmap_lock in read.
   949	 */
   950	static int find_pmd_or_thp_or_none(struct mm_struct *mm,
   951					   unsigned long address,
   952					   pmd_t **pmd)
   953	{
   954		pmd_t pmde;
   955	
   956		*pmd = mm_find_pmd(mm, address);
   957		if (!*pmd)
   958			return SCAN_PMD_NULL;
   959	
   960		pmde = pmdp_get_lockless(*pmd);
   961	
   962	#ifdef CONFIG_TRANSPARENT_HUGEPAGE
   963		/* See comments in pmd_none_or_trans_huge_or_clear_bad() */
   964		barrier();
   965	#endif
   966		if (pmd_none(pmde))
   967			return SCAN_PMD_NONE;
   968		if (!pmd_present(pmde))
   969			return SCAN_PMD_NULL;
   970		if (pmd_trans_huge(pmde))
   971			return SCAN_PMD_MAPPED;
 > 972		if (pmd_devmap(pmd))
   973			return SCAN_PMD_NULL;
   974		if (pmd_bad(pmde))
   975			return SCAN_PMD_NULL;
   976		return SCAN_SUCCEED;
   977	}
   978	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

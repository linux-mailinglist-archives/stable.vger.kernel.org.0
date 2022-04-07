Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768304F71D5
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 04:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiDGCIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 22:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiDGCIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 22:08:35 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909FDECC48;
        Wed,  6 Apr 2022 19:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649297196; x=1680833196;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dQrnEJaSMkZbyuRDxzwznPl1VKPOiEnuTwnVLSNQtLg=;
  b=DgYPMOc5wuc/rcUh8UiLCrHXCQiWLvpwcLDBoqwApYamonDq7dhCQLBA
   5UN/psvMQsDF0yOC1by6LX66s3xfaw0N9X7YrBjxJ5nioKKRhOkmKMBLO
   HaC+2LhTW3fGSRplgfnYei8THvZHAeiOpqRmt6VXXkRHRV0O8jO3RjH0V
   +fJ1ZanFpMiOB9arHYEkGy1BzOj1wsMcbqT2g9o/H+i90uDmREh8tiLnF
   MDOZdSyVwt9lWwwtl1whMiU43b9YwLUhPuiesWtQPmF1ehFGvdSwqTafp
   nnLmXtfs/m759C6RGGG4pn2GIRmslVmFnJfFONy84n2IzwZlOT+DXarZa
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="241799404"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="241799404"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 19:06:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="658861171"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 06 Apr 2022 19:06:33 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncHXc-0004yZ-MW;
        Thu, 07 Apr 2022 02:06:32 +0000
Date:   Thu, 7 Apr 2022 10:06:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: Re: [PATCH] xen/balloon: fix page onlining when populating new zone
Message-ID: <202204070950.mzGBYW2q-lkp@intel.com>
References: <20220406133229.15979-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406133229.15979-1-jgross@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Juergen,

I love your patch! Perhaps something to improve:

[auto build test WARNING on xen-tip/linux-next]
[also build test WARNING on linus/master linux/master v5.18-rc1 next-20220406]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Juergen-Gross/xen-balloon-fix-page-onlining-when-populating-new-zone/20220407-000935
base:   https://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git linux-next
config: arm64-randconfig-r036-20220406 (https://download.01.org/0day-ci/archive/20220407/202204070950.mzGBYW2q-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c4a1b07d0979e7ff20d7d541af666d822d66b566)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/b3deb59d5386ade4fb227038f202a9bdb8ade4ab
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Juergen-Gross/xen-balloon-fix-page-onlining-when-populating-new-zone/20220407-000935
        git checkout b3deb59d5386ade4fb227038f202a9bdb8ade4ab
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/media/platform/ drivers/xen/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/xen/balloon.c:518:10: error: implicit declaration of function 'alloc_page_for_balloon' [-Werror,-Wimplicit-function-declaration]
                   page = alloc_page_for_balloon(gfp);
                          ^
>> drivers/xen/balloon.c:518:8: warning: incompatible integer to pointer conversion assigning to 'struct page *' from 'int' [-Wint-conversion]
                   page = alloc_page_for_balloon(gfp);
                        ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/xen/balloon.c:545:3: error: implicit declaration of function 'add_page_to_balloon' [-Werror,-Wimplicit-function-declaration]
                   add_page_to_balloon(page);
                   ^
   1 warning and 2 errors generated.


vim +518 drivers/xen/balloon.c

   505	
   506	static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
   507	{
   508		enum bp_state state = BP_DONE;
   509		unsigned long i;
   510		struct page *page, *tmp;
   511		int ret;
   512		LIST_HEAD(pages);
   513	
   514		if (nr_pages > ARRAY_SIZE(frame_list))
   515			nr_pages = ARRAY_SIZE(frame_list);
   516	
   517		for (i = 0; i < nr_pages; i++) {
 > 518			page = alloc_page_for_balloon(gfp);
   519			if (page == NULL) {
   520				nr_pages = i;
   521				state = BP_EAGAIN;
   522				break;
   523			}
   524			list_add(&page->lru, &pages);
   525		}
   526	
   527		/*
   528		 * Ensure that ballooned highmem pages don't have kmaps.
   529		 *
   530		 * Do this before changing the p2m as kmap_flush_unused()
   531		 * reads PTEs to obtain pages (and hence needs the original
   532		 * p2m entry).
   533		 */
   534		kmap_flush_unused();
   535	
   536		/*
   537		 * Setup the frame, update direct mapping, invalidate P2M,
   538		 * and add to balloon.
   539		 */
   540		i = 0;
   541		list_for_each_entry_safe(page, tmp, &pages, lru) {
   542			frame_list[i++] = xen_page_to_gfn(page);
   543	
   544			list_del(&page->lru);
   545			add_page_to_balloon(page);
   546		}
   547	
   548		flush_tlb_all();
   549	
   550		ret = xenmem_reservation_decrease(nr_pages, frame_list);
   551		BUG_ON(ret != nr_pages);
   552	
   553		balloon_stats.current_pages -= nr_pages;
   554	
   555		return state;
   556	}
   557	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932FC4F6E8E
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 01:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbiDFXfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 19:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiDFXfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 19:35:31 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4794E223205;
        Wed,  6 Apr 2022 16:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649288013; x=1680824013;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pRwkOMm0qHu0lOS5zpitn48/SuLkUxM71YjsDbeCfgU=;
  b=j6Jo/5NdXON1TidgY6q+3RBApHgZOYNNK3aFQPluLBd0mDgm/oPBw6/P
   b4kx3mf7AotZyhvUOsYFDZbMu4my0ZFhQm5crDbkA2uHvnejgmRyLEaZo
   EJ+R0LTFrPmYHDPtU3MeSubh7B540ExBWGSuHFMQsg//4Rf7ZQAfYwVj3
   J+Hbh95EuC5Q4sS42dQVyT3xfAk4BAmZ89f9hOar0JxrFn5Q2O2ND8K5K
   PxbBIlpbTBRMNSNrkDtMZsXmEPP+VJQcB2cVqa6B19qeJX7YHVRvbwqYz
   MXxsr7RZnf7+ErnQnfOu8KWUBRuFaQleGFW6pE50ziQ25NvlqqigxjPr2
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="260022035"
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="260022035"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 16:32:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="722721744"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 06 Apr 2022 16:32:42 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncF8j-0004r5-Sb;
        Wed, 06 Apr 2022 23:32:41 +0000
Date:   Thu, 7 Apr 2022 07:31:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: Re: [PATCH] xen/balloon: fix page onlining when populating new zone
Message-ID: <202204070706.PKz2Th7L-lkp@intel.com>
References: <20220406133229.15979-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406133229.15979-1-jgross@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: arm64-randconfig-r011-20220406 (https://download.01.org/0day-ci/archive/20220407/202204070706.PKz2Th7L-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/b3deb59d5386ade4fb227038f202a9bdb8ade4ab
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Juergen-Gross/xen-balloon-fix-page-onlining-when-populating-new-zone/20220407-000935
        git checkout b3deb59d5386ade4fb227038f202a9bdb8ade4ab
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/xen/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/xen/balloon.c: In function 'decrease_reservation':
   drivers/xen/balloon.c:518:24: error: implicit declaration of function 'alloc_page_for_balloon' [-Werror=implicit-function-declaration]
     518 |                 page = alloc_page_for_balloon(gfp);
         |                        ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/xen/balloon.c:518:22: warning: assignment to 'struct page *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     518 |                 page = alloc_page_for_balloon(gfp);
         |                      ^
   drivers/xen/balloon.c:545:17: error: implicit declaration of function 'add_page_to_balloon' [-Werror=implicit-function-declaration]
     545 |                 add_page_to_balloon(page);
         |                 ^~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B4F699CDF
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 20:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBPTKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 14:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBPTKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 14:10:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EB02A6D7;
        Thu, 16 Feb 2023 11:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676574637; x=1708110637;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RG6FE89xEMZ8fRCJpypPavShNTygUNbwQaaGLRFV/uI=;
  b=Bq3LOZohyPrb/npHssKp7OL1HmPrkET98//tn3fb0uwejotZmqCUuseK
   Juq4nj6EcW/NdDP1mZgHWU/8TL++4oFgJkrIAlSKKsv1x3jkU5WVsIZX5
   LJi3soB2vEuxBcAQNI7CP8lkp+AOTjs81PvffLuecP++1BAf0NGpv6QLo
   ri+itLAS4ZJu/zOQp76NYrTV8K69lYsx+EbeIH33kcYdlcD8xZPfYCuHL
   HmLQ4Nw70LSYKv7c5Gdv71+cX+HlsPbfi3SaHXaFIOFighcmvbzlOOvW6
   +YOAndS/FXRp2B3CAyYWaxoALFzGSQc5BnnIiMyF3ZhHPLUGyBDHsBX9s
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="331812023"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="331812023"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 11:10:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="734022099"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="734022099"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2023 11:10:35 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pSjeM-000AS9-2d;
        Thu, 16 Feb 2023 19:10:34 +0000
Date:   Fri, 17 Feb 2023 03:09:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, hch@infradead.org,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] brd: only preload radix tree if we're using a
 blocking gfp mask
Message-ID: <202302170236.SynZo1Bx-lkp@intel.com>
References: <20230216151918.319585-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216151918.319585-4-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens,

I love your patch! Perhaps something to improve:

[auto build test WARNING on v6.2-rc8]
[also build test WARNING on linus/master next-20230216]
[cannot apply to axboe-block/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jens-Axboe/brd-return-0-error-from-brd_insert_page/20230216-234430
patch link:    https://lore.kernel.org/r/20230216151918.319585-4-axboe%40kernel.dk
patch subject: [PATCH 3/4] brd: only preload radix tree if we're using a blocking gfp mask
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230217/202302170236.SynZo1Bx-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/237074d417b50a21f2bed5585ceebe8398535b1a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jens-Axboe/brd-return-0-error-from-brd_insert_page/20230216-234430
        git checkout 237074d417b50a21f2bed5585ceebe8398535b1a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/block/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302170236.SynZo1Bx-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/block/brd.c: In function 'brd_insert_page':
>> drivers/block/brd.c:87:13: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
      87 |         int ret = 0;
         |             ^~~


vim +/ret +87 drivers/block/brd.c

    79	
    80	/*
    81	 * Insert a new page for a given sector, if one does not already exist.
    82	 */
    83	static int brd_insert_page(struct brd_device *brd, sector_t sector, gfp_t gfp)
    84	{
    85		pgoff_t idx;
    86		struct page *page;
  > 87		int ret = 0;
    88	
    89		page = brd_lookup_page(brd, sector);
    90		if (page)
    91			return 0;
    92	
    93		page = alloc_page(gfp | __GFP_ZERO | __GFP_HIGHMEM);
    94		if (!page)
    95			return -ENOMEM;
    96	
    97		if (gfpflags_allow_blocking(gfp) && radix_tree_preload(gfp)) {
    98			__free_page(page);
    99			return -ENOMEM;
   100		}
   101	
   102		spin_lock(&brd->brd_lock);
   103		idx = sector >> PAGE_SECTORS_SHIFT;
   104		page->index = idx;
   105		if (radix_tree_insert(&brd->brd_pages, idx, page)) {
   106			__free_page(page);
   107			page = radix_tree_lookup(&brd->brd_pages, idx);
   108			if (!page)
   109				ret = -ENOMEM;
   110			else if (page->index != idx)
   111				ret = -EIO;
   112		} else {
   113			brd->brd_nr_pages++;
   114		}
   115		spin_unlock(&brd->brd_lock);
   116	
   117		radix_tree_preload_end();
   118		return 0;
   119	}
   120	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C828F698AAE
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 03:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBPCzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 21:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBPCzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 21:55:19 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409514609A
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 18:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676516117; x=1708052117;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d7opapgYHxV0e1r4lhHkshJnywNZR/QjUzPjOtRV6Tc=;
  b=GOClUipZcBzeN3jO+UZa9wqcOVb/cgTCIXwwvWSQGItneMtP8I31bBvU
   LrIAwRNU5DirPPA6pVomNWjUsvsKOHfuN/k7i6MWBxAeBUdS8JmiwFIgi
   tURIq7lddVqdsdchBsrf37O4xsciMu2A7pAzCwnTufOCQyCGWN5iPoyso
   os9i1yDUcOGiLl1Mn3iUoMRXlvhEWgyCS4qXoTxyY9Wu3qP0v+NKDhCt7
   dvWsSytUj7xn4L16LNvuEuvksRB03Y/sg9Yhkh2KvwAQiIl+0sXddftha
   I4iAFsXkFcIEv/G7w5RCAmn5CGFxFr1GADWUo2/rILbVwtFKw6R1qOqO8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="315281179"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="315281179"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 18:55:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="663300766"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="663300766"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 15 Feb 2023 18:55:14 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pSUQT-0009xh-15;
        Thu, 16 Feb 2023 02:55:13 +0000
Date:   Thu, 16 Feb 2023 10:54:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     John.C.Harrison@intel.com, Intel-GFX@lists.freedesktop.org
Cc:     oe-kbuild-all@lists.linux.dev, intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        DRI-Devel@lists.freedesktop.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v2 2/2] drm/i915: Don't use BAR mappings for
 ring buffers with LLC
Message-ID: <202302161021.TjavhrpH-lkp@intel.com>
References: <20230216002248.1851966-3-John.C.Harrison@Intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216002248.1851966-3-John.C.Harrison@Intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on drm-tip/drm-tip]

url:    https://github.com/intel-lab-lkp/linux/commits/John-C-Harrison-Intel-com/drm-i915-Don-t-use-stolen-memory-for-ring-buffers-with-LLC/20230216-082552
base:   git://anongit.freedesktop.org/drm/drm-tip drm-tip
patch link:    https://lore.kernel.org/r/20230216002248.1851966-3-John.C.Harrison%40Intel.com
patch subject: [Intel-gfx] [PATCH v2 2/2] drm/i915: Don't use BAR mappings for ring buffers with LLC
config: i386-randconfig-a011-20230213 (https://download.01.org/0day-ci/archive/20230216/202302161021.TjavhrpH-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/fa748ad303922e4138a246d4db247dfa96e45651
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review John-C-Harrison-Intel-com/drm-i915-Don-t-use-stolen-memory-for-ring-buffers-with-LLC/20230216-082552
        git checkout fa748ad303922e4138a246d4db247dfa96e45651
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302161021.TjavhrpH-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/gpu/drm/i915/gt/intel_ring.c: In function 'intel_ring_unpin':
>> drivers/gpu/drm/i915/gt/intel_ring.c:103:9: error: expected '}' before 'else'
     103 |         else
         |         ^~~~


vim +103 drivers/gpu/drm/i915/gt/intel_ring.c

2871ea85c119e6f Chris Wilson           2019-10-24   92  
2871ea85c119e6f Chris Wilson           2019-10-24   93  void intel_ring_unpin(struct intel_ring *ring)
2871ea85c119e6f Chris Wilson           2019-10-24   94  {
2871ea85c119e6f Chris Wilson           2019-10-24   95  	struct i915_vma *vma = ring->vma;
2871ea85c119e6f Chris Wilson           2019-10-24   96  
2871ea85c119e6f Chris Wilson           2019-10-24   97  	if (!atomic_dec_and_test(&ring->pin_count))
2871ea85c119e6f Chris Wilson           2019-10-24   98  		return;
2871ea85c119e6f Chris Wilson           2019-10-24   99  
2871ea85c119e6f Chris Wilson           2019-10-24  100  	i915_vma_unset_ggtt_write(vma);
fa748ad303922e4 Daniele Ceraolo Spurio 2023-02-15  101  	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915)) {
2871ea85c119e6f Chris Wilson           2019-10-24  102  		i915_vma_unpin_iomap(vma);
2871ea85c119e6f Chris Wilson           2019-10-24 @103  	else
2871ea85c119e6f Chris Wilson           2019-10-24  104  		i915_gem_object_unpin_map(vma->obj);
2871ea85c119e6f Chris Wilson           2019-10-24  105  
2871ea85c119e6f Chris Wilson           2019-10-24  106  	i915_vma_make_purgeable(vma);
a266bf420060043 Chris Wilson           2019-11-18  107  	i915_vma_unpin(vma);
2871ea85c119e6f Chris Wilson           2019-10-24  108  }
2871ea85c119e6f Chris Wilson           2019-10-24  109  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

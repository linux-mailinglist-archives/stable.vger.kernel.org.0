Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB181698EFA
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 09:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBPIs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 03:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjBPIs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 03:48:28 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6A838E86
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 00:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676537306; x=1708073306;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZI0M1gB6CVRszJ80drCePHEr/lyzccBHVgAyVK/t4rs=;
  b=UbcROYRrW++2OONGOPG2SoRT9d8B8Ef+qd6i0gLPrZUa3h0PFm05xSBG
   2W8wxTbLTIXAItzk03/b4zrknhY7aT+MxrdI0F0vPId63EiWdYpQSpdBN
   1SH/HsyYC9Z69/FaKUntQs6rRVPNAFZ09w4zNkzQcJMLTOqjUO2gQUZ3A
   unqWWCOxH14AUsRnZknXp1/EPbrEuXtEwLzCqi482vMi3CYAv9LBtHc5K
   qdMS7ry5yTM0CE8k4UbB4gAwim9V4fRY6GnTbaUFSvlAw+l0TUeqmRr3B
   FdP6YCFLcMeOL3vsRPko6ehuxvblE8T2+RqowKy0GuwlZsvVz6n2O5HhU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="396304976"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="396304976"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 00:48:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="670045415"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="670045415"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 16 Feb 2023 00:48:22 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pSZwE-000A9r-0P;
        Thu, 16 Feb 2023 08:48:22 +0000
Date:   Thu, 16 Feb 2023 16:47:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     John.C.Harrison@intel.com, Intel-GFX@lists.freedesktop.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        DRI-Devel@lists.freedesktop.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v2 2/2] drm/i915: Don't use BAR mappings for
 ring buffers with LLC
Message-ID: <202302161616.UKxjGXPv-lkp@intel.com>
References: <20230216002248.1851966-3-John.C.Harrison@Intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230216002248.1851966-3-John.C.Harrison@Intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
config: i386-randconfig-a005-20230213 (https://download.01.org/0day-ci/archive/20230216/202302161616.UKxjGXPv-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fa748ad303922e4138a246d4db247dfa96e45651
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review John-C-Harrison-Intel-com/drm-i915-Don-t-use-stolen-memory-for-ring-buffers-with-LLC/20230216-082552
        git checkout fa748ad303922e4138a246d4db247dfa96e45651
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302161616.UKxjGXPv-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/gpu/drm/i915/gt/intel_ring.c:103:2: error: expected expression
           else
           ^
>> drivers/gpu/drm/i915/gt/intel_ring.c:111:1: error: function definition is not allowed here
   {
   ^
   drivers/gpu/drm/i915/gt/intel_ring.c:146:1: error: function definition is not allowed here
   {
   ^
   drivers/gpu/drm/i915/gt/intel_ring.c:184:1: error: function definition is not allowed here
   {
   ^
   drivers/gpu/drm/i915/gt/intel_ring.c:195:1: error: function definition is not allowed here
   {
   ^
   drivers/gpu/drm/i915/gt/intel_ring.c:230:1: error: function definition is not allowed here
   {
   ^
   drivers/gpu/drm/i915/gt/intel_ring.c:312:1: error: function definition is not allowed here
   {
   ^
>> drivers/gpu/drm/i915/gt/intel_ring.c:336:7: error: expected '}'
   #endif
         ^
   drivers/gpu/drm/i915/gt/intel_ring.c:94:1: note: to match this '{'
   {
   ^
   8 errors generated.


vim +103 drivers/gpu/drm/i915/gt/intel_ring.c

2871ea85c119e6 Chris Wilson           2019-10-24   92  
2871ea85c119e6 Chris Wilson           2019-10-24   93  void intel_ring_unpin(struct intel_ring *ring)
2871ea85c119e6 Chris Wilson           2019-10-24   94  {
2871ea85c119e6 Chris Wilson           2019-10-24   95  	struct i915_vma *vma = ring->vma;
2871ea85c119e6 Chris Wilson           2019-10-24   96  
2871ea85c119e6 Chris Wilson           2019-10-24   97  	if (!atomic_dec_and_test(&ring->pin_count))
2871ea85c119e6 Chris Wilson           2019-10-24   98  		return;
2871ea85c119e6 Chris Wilson           2019-10-24   99  
2871ea85c119e6 Chris Wilson           2019-10-24  100  	i915_vma_unset_ggtt_write(vma);
fa748ad303922e Daniele Ceraolo Spurio 2023-02-15  101  	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915)) {
2871ea85c119e6 Chris Wilson           2019-10-24  102  		i915_vma_unpin_iomap(vma);
2871ea85c119e6 Chris Wilson           2019-10-24 @103  	else
2871ea85c119e6 Chris Wilson           2019-10-24  104  		i915_gem_object_unpin_map(vma->obj);
2871ea85c119e6 Chris Wilson           2019-10-24  105  
2871ea85c119e6 Chris Wilson           2019-10-24  106  	i915_vma_make_purgeable(vma);
a266bf42006004 Chris Wilson           2019-11-18  107  	i915_vma_unpin(vma);
2871ea85c119e6 Chris Wilson           2019-10-24  108  }
2871ea85c119e6 Chris Wilson           2019-10-24  109  
2871ea85c119e6 Chris Wilson           2019-10-24  110  static struct i915_vma *create_ring_vma(struct i915_ggtt *ggtt, int size)
2871ea85c119e6 Chris Wilson           2019-10-24 @111  {
2871ea85c119e6 Chris Wilson           2019-10-24  112  	struct i915_address_space *vm = &ggtt->vm;
2871ea85c119e6 Chris Wilson           2019-10-24  113  	struct drm_i915_private *i915 = vm->i915;
2871ea85c119e6 Chris Wilson           2019-10-24  114  	struct drm_i915_gem_object *obj;
2871ea85c119e6 Chris Wilson           2019-10-24  115  	struct i915_vma *vma;
2871ea85c119e6 Chris Wilson           2019-10-24  116  
0d8ee5ba8db46c Thomas Hellström       2021-09-22  117  	obj = i915_gem_object_create_lmem(i915, size, I915_BO_ALLOC_VOLATILE |
0d8ee5ba8db46c Thomas Hellström       2021-09-22  118  					  I915_BO_ALLOC_PM_VOLATILE);
bb5623500723f7 John Harrison          2023-02-15  119  	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt) && !HAS_LLC(i915))
2871ea85c119e6 Chris Wilson           2019-10-24  120  		obj = i915_gem_object_create_stolen(i915, size);
2871ea85c119e6 Chris Wilson           2019-10-24  121  	if (IS_ERR(obj))
2871ea85c119e6 Chris Wilson           2019-10-24  122  		obj = i915_gem_object_create_internal(i915, size);
2871ea85c119e6 Chris Wilson           2019-10-24  123  	if (IS_ERR(obj))
2871ea85c119e6 Chris Wilson           2019-10-24  124  		return ERR_CAST(obj);
2871ea85c119e6 Chris Wilson           2019-10-24  125  
2871ea85c119e6 Chris Wilson           2019-10-24  126  	/*
2871ea85c119e6 Chris Wilson           2019-10-24  127  	 * Mark ring buffers as read-only from GPU side (so no stray overwrites)
2871ea85c119e6 Chris Wilson           2019-10-24  128  	 * if supported by the platform's GGTT.
2871ea85c119e6 Chris Wilson           2019-10-24  129  	 */
2871ea85c119e6 Chris Wilson           2019-10-24  130  	if (vm->has_read_only)
2871ea85c119e6 Chris Wilson           2019-10-24  131  		i915_gem_object_set_readonly(obj);
2871ea85c119e6 Chris Wilson           2019-10-24  132  
2871ea85c119e6 Chris Wilson           2019-10-24  133  	vma = i915_vma_instance(obj, vm, NULL);
2871ea85c119e6 Chris Wilson           2019-10-24  134  	if (IS_ERR(vma))
2871ea85c119e6 Chris Wilson           2019-10-24  135  		goto err;
2871ea85c119e6 Chris Wilson           2019-10-24  136  
2871ea85c119e6 Chris Wilson           2019-10-24  137  	return vma;
2871ea85c119e6 Chris Wilson           2019-10-24  138  
2871ea85c119e6 Chris Wilson           2019-10-24  139  err:
2871ea85c119e6 Chris Wilson           2019-10-24  140  	i915_gem_object_put(obj);
2871ea85c119e6 Chris Wilson           2019-10-24  141  	return vma;
2871ea85c119e6 Chris Wilson           2019-10-24  142  }
2871ea85c119e6 Chris Wilson           2019-10-24  143  
2871ea85c119e6 Chris Wilson           2019-10-24  144  struct intel_ring *
2871ea85c119e6 Chris Wilson           2019-10-24  145  intel_engine_create_ring(struct intel_engine_cs *engine, int size)
2871ea85c119e6 Chris Wilson           2019-10-24  146  {
2871ea85c119e6 Chris Wilson           2019-10-24  147  	struct drm_i915_private *i915 = engine->i915;
2871ea85c119e6 Chris Wilson           2019-10-24  148  	struct intel_ring *ring;
2871ea85c119e6 Chris Wilson           2019-10-24  149  	struct i915_vma *vma;
2871ea85c119e6 Chris Wilson           2019-10-24  150  
2871ea85c119e6 Chris Wilson           2019-10-24  151  	GEM_BUG_ON(!is_power_of_2(size));
2871ea85c119e6 Chris Wilson           2019-10-24  152  	GEM_BUG_ON(RING_CTL_SIZE(size) & ~RING_NR_PAGES);
2871ea85c119e6 Chris Wilson           2019-10-24  153  
2871ea85c119e6 Chris Wilson           2019-10-24  154  	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
2871ea85c119e6 Chris Wilson           2019-10-24  155  	if (!ring)
2871ea85c119e6 Chris Wilson           2019-10-24  156  		return ERR_PTR(-ENOMEM);
2871ea85c119e6 Chris Wilson           2019-10-24  157  
2871ea85c119e6 Chris Wilson           2019-10-24  158  	kref_init(&ring->ref);
2871ea85c119e6 Chris Wilson           2019-10-24  159  	ring->size = size;
5ba32c7be81e53 Chris Wilson           2020-02-07  160  	ring->wrap = BITS_PER_TYPE(ring->size) - ilog2(size);
2871ea85c119e6 Chris Wilson           2019-10-24  161  
2871ea85c119e6 Chris Wilson           2019-10-24  162  	/*
2871ea85c119e6 Chris Wilson           2019-10-24  163  	 * Workaround an erratum on the i830 which causes a hang if
2871ea85c119e6 Chris Wilson           2019-10-24  164  	 * the TAIL pointer points to within the last 2 cachelines
2871ea85c119e6 Chris Wilson           2019-10-24  165  	 * of the buffer.
2871ea85c119e6 Chris Wilson           2019-10-24  166  	 */
2871ea85c119e6 Chris Wilson           2019-10-24  167  	ring->effective_size = size;
2871ea85c119e6 Chris Wilson           2019-10-24  168  	if (IS_I830(i915) || IS_I845G(i915))
2871ea85c119e6 Chris Wilson           2019-10-24  169  		ring->effective_size -= 2 * CACHELINE_BYTES;
2871ea85c119e6 Chris Wilson           2019-10-24  170  
2871ea85c119e6 Chris Wilson           2019-10-24  171  	intel_ring_update_space(ring);
2871ea85c119e6 Chris Wilson           2019-10-24  172  
2871ea85c119e6 Chris Wilson           2019-10-24  173  	vma = create_ring_vma(engine->gt->ggtt, size);
2871ea85c119e6 Chris Wilson           2019-10-24  174  	if (IS_ERR(vma)) {
2871ea85c119e6 Chris Wilson           2019-10-24  175  		kfree(ring);
2871ea85c119e6 Chris Wilson           2019-10-24  176  		return ERR_CAST(vma);
2871ea85c119e6 Chris Wilson           2019-10-24  177  	}
2871ea85c119e6 Chris Wilson           2019-10-24  178  	ring->vma = vma;
2871ea85c119e6 Chris Wilson           2019-10-24  179  
2871ea85c119e6 Chris Wilson           2019-10-24  180  	return ring;
2871ea85c119e6 Chris Wilson           2019-10-24  181  }
2871ea85c119e6 Chris Wilson           2019-10-24  182  
2871ea85c119e6 Chris Wilson           2019-10-24  183  void intel_ring_free(struct kref *ref)
2871ea85c119e6 Chris Wilson           2019-10-24  184  {
2871ea85c119e6 Chris Wilson           2019-10-24  185  	struct intel_ring *ring = container_of(ref, typeof(*ring), ref);
2871ea85c119e6 Chris Wilson           2019-10-24  186  
2871ea85c119e6 Chris Wilson           2019-10-24  187  	i915_vma_put(ring->vma);
2871ea85c119e6 Chris Wilson           2019-10-24  188  	kfree(ring);
2871ea85c119e6 Chris Wilson           2019-10-24  189  }
2871ea85c119e6 Chris Wilson           2019-10-24  190  
2871ea85c119e6 Chris Wilson           2019-10-24  191  static noinline int
2871ea85c119e6 Chris Wilson           2019-10-24  192  wait_for_space(struct intel_ring *ring,
2871ea85c119e6 Chris Wilson           2019-10-24  193  	       struct intel_timeline *tl,
2871ea85c119e6 Chris Wilson           2019-10-24  194  	       unsigned int bytes)
2871ea85c119e6 Chris Wilson           2019-10-24 @195  {
2871ea85c119e6 Chris Wilson           2019-10-24  196  	struct i915_request *target;
2871ea85c119e6 Chris Wilson           2019-10-24  197  	long timeout;
2871ea85c119e6 Chris Wilson           2019-10-24  198  
2871ea85c119e6 Chris Wilson           2019-10-24  199  	if (intel_ring_update_space(ring) >= bytes)
2871ea85c119e6 Chris Wilson           2019-10-24  200  		return 0;
2871ea85c119e6 Chris Wilson           2019-10-24  201  
2871ea85c119e6 Chris Wilson           2019-10-24  202  	GEM_BUG_ON(list_empty(&tl->requests));
2871ea85c119e6 Chris Wilson           2019-10-24  203  	list_for_each_entry(target, &tl->requests, link) {
2871ea85c119e6 Chris Wilson           2019-10-24  204  		if (target->ring != ring)
2871ea85c119e6 Chris Wilson           2019-10-24  205  			continue;
2871ea85c119e6 Chris Wilson           2019-10-24  206  
2871ea85c119e6 Chris Wilson           2019-10-24  207  		/* Would completion of this request free enough space? */
2871ea85c119e6 Chris Wilson           2019-10-24  208  		if (bytes <= __intel_ring_space(target->postfix,
2871ea85c119e6 Chris Wilson           2019-10-24  209  						ring->emit, ring->size))
2871ea85c119e6 Chris Wilson           2019-10-24  210  			break;
2871ea85c119e6 Chris Wilson           2019-10-24  211  	}
2871ea85c119e6 Chris Wilson           2019-10-24  212  
2871ea85c119e6 Chris Wilson           2019-10-24  213  	if (GEM_WARN_ON(&target->link == &tl->requests))
2871ea85c119e6 Chris Wilson           2019-10-24  214  		return -ENOSPC;
2871ea85c119e6 Chris Wilson           2019-10-24  215  
2871ea85c119e6 Chris Wilson           2019-10-24  216  	timeout = i915_request_wait(target,
2871ea85c119e6 Chris Wilson           2019-10-24  217  				    I915_WAIT_INTERRUPTIBLE,
2871ea85c119e6 Chris Wilson           2019-10-24  218  				    MAX_SCHEDULE_TIMEOUT);
2871ea85c119e6 Chris Wilson           2019-10-24  219  	if (timeout < 0)
2871ea85c119e6 Chris Wilson           2019-10-24  220  		return timeout;
2871ea85c119e6 Chris Wilson           2019-10-24  221  
2871ea85c119e6 Chris Wilson           2019-10-24  222  	i915_request_retire_upto(target);
2871ea85c119e6 Chris Wilson           2019-10-24  223  
2871ea85c119e6 Chris Wilson           2019-10-24  224  	intel_ring_update_space(ring);
2871ea85c119e6 Chris Wilson           2019-10-24  225  	GEM_BUG_ON(ring->space < bytes);
2871ea85c119e6 Chris Wilson           2019-10-24  226  	return 0;
2871ea85c119e6 Chris Wilson           2019-10-24  227  }
2871ea85c119e6 Chris Wilson           2019-10-24  228  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

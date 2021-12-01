Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02BB465852
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 22:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbhLAV0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 16:26:16 -0500
Received: from mga07.intel.com ([134.134.136.100]:60547 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhLAV0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Dec 2021 16:26:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="299949803"
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="299949803"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 13:22:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="654944557"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 01 Dec 2021 13:22:51 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1msX3y-000FP8-FG; Wed, 01 Dec 2021 21:22:50 +0000
Date:   Thu, 2 Dec 2021 05:22:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jan Kara <jack@suse.cz>, Paolo Valente <paolo.valente@linaro.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        fvogt@suse.de, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        Fabian Vogt <fvogt@suse.com>
Subject: Re: [PATCH] bfq: Fix use-after-free with cgroups
Message-ID: <202112020559.l11FLFdN-lkp@intel.com>
References: <20211201133439.3309-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201133439.3309-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jan,

I love your patch! Yet something to improve:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on v5.16-rc3 next-20211201]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Jan-Kara/bfq-Fix-use-after-free-with-cgroups/20211201-213549
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: hexagon-randconfig-r045-20211128 (https://download.01.org/0day-ci/archive/20211202/202112020559.l11FLFdN-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 4b553297ef3ee4dc2119d5429adf3072e90fac38)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/2154a2da8d69308aca6bb431da2d4d9e3e687daa
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jan-Kara/bfq-Fix-use-after-free-with-cgroups/20211201-213549
        git checkout 2154a2da8d69308aca6bb431da2d4d9e3e687daa
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> block/bfq-iosched.c:5472:46: error: no member named 'children' in 'struct bfq_group'
           hlist_add_head(&bfqq->children_node, &bfqg->children);
                                                 ~~~~  ^
   1 error generated.


vim +5472 block/bfq-iosched.c

  5460	
  5461	static void bfq_init_bfqq(struct bfq_data *bfqd, struct bfq_group *bfqg,
  5462				  struct bfq_queue *bfqq, struct bfq_io_cq *bic,
  5463				  pid_t pid, int is_sync)
  5464	{
  5465		u64 now_ns = ktime_get_ns();
  5466	
  5467		RB_CLEAR_NODE(&bfqq->entity.rb_node);
  5468		INIT_LIST_HEAD(&bfqq->fifo);
  5469		INIT_HLIST_NODE(&bfqq->burst_list_node);
  5470		INIT_HLIST_NODE(&bfqq->woken_list_node);
  5471		INIT_HLIST_HEAD(&bfqq->woken_list);
> 5472		hlist_add_head(&bfqq->children_node, &bfqg->children);
  5473	
  5474		bfqq->ref = 0;
  5475		bfqq->bfqd = bfqd;
  5476	
  5477		if (bic)
  5478			bfq_set_next_ioprio_data(bfqq, bic);
  5479	
  5480		if (is_sync) {
  5481			/*
  5482			 * No need to mark as has_short_ttime if in
  5483			 * idle_class, because no device idling is performed
  5484			 * for queues in idle class
  5485			 */
  5486			if (!bfq_class_idle(bfqq))
  5487				/* tentatively mark as has_short_ttime */
  5488				bfq_mark_bfqq_has_short_ttime(bfqq);
  5489			bfq_mark_bfqq_sync(bfqq);
  5490			bfq_mark_bfqq_just_created(bfqq);
  5491		} else
  5492			bfq_clear_bfqq_sync(bfqq);
  5493	
  5494		/* set end request to minus infinity from now */
  5495		bfqq->ttime.last_end_request = now_ns + 1;
  5496	
  5497		bfqq->creation_time = jiffies;
  5498	
  5499		bfqq->io_start_time = now_ns;
  5500	
  5501		bfq_mark_bfqq_IO_bound(bfqq);
  5502	
  5503		bfqq->pid = pid;
  5504	
  5505		/* Tentative initial value to trade off between thr and lat */
  5506		bfqq->max_budget = (2 * bfq_max_budget(bfqd)) / 3;
  5507		bfqq->budget_timeout = bfq_smallest_from_now();
  5508	
  5509		bfqq->wr_coeff = 1;
  5510		bfqq->last_wr_start_finish = jiffies;
  5511		bfqq->wr_start_at_switch_to_srt = bfq_smallest_from_now();
  5512		bfqq->split_time = bfq_smallest_from_now();
  5513	
  5514		/*
  5515		 * To not forget the possibly high bandwidth consumed by a
  5516		 * process/queue in the recent past,
  5517		 * bfq_bfqq_softrt_next_start() returns a value at least equal
  5518		 * to the current value of bfqq->soft_rt_next_start (see
  5519		 * comments on bfq_bfqq_softrt_next_start).  Set
  5520		 * soft_rt_next_start to now, to mean that bfqq has consumed
  5521		 * no bandwidth so far.
  5522		 */
  5523		bfqq->soft_rt_next_start = jiffies;
  5524	
  5525		/* first request is almost certainly seeky */
  5526		bfqq->seek_history = 1;
  5527	}
  5528	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

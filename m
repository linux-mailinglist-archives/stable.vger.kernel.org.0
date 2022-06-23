Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AF3558803
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiFWTAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiFWTAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:00:03 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3620B858C;
        Thu, 23 Jun 2022 11:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656007536; x=1687543536;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wK7PtfVDpfomb57ubvzsIdHXetcpN8TvU96nmL+7ONE=;
  b=Gx8Io8lNmUovPdeCwhitpgIPAJztn4fk8shzk+RN6DEH6ZUJor9J6k9O
   aktvmuKjEeoBObUIA6DuC7elVPldLK7mFcezDHbCiaMPgvdaYvTBUuSde
   n3menpL0CTBW/0Oj231o7mQ4C/l2mIfxJ8IXgY6V74CftZc2FJdDUsAf6
   vZjpSLeerInw25rgH2ZH+TkbVQ94f3QtBDYA2gNCxJmc8DPWPcpmnDUDp
   J5ArLSDQIp3gwZIwHUDF6OEV8p68hxp2kLS2/AeUe8Z+pIubw3DcrOe4D
   ZMtHhXL/ns+IMkGy9WSvT+RodwBIqsVP2P7g4BSREm7QQDc+JykP+ARTL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="269523769"
X-IronPort-AV: E=Sophos;i="5.92,216,1650956400"; 
   d="scan'208";a="269523769"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 11:05:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,216,1650956400"; 
   d="scan'208";a="834750314"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jun 2022 11:05:24 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o4RCl-0002gr-Od;
        Thu, 23 Jun 2022 18:05:23 +0000
Date:   Fri, 24 Jun 2022 02:04:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org
Cc:     kbuild-all@lists.01.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] timekeeping: contribute wall clock to rng on time change
Message-ID: <202206240128.jVs1F5jD-lkp@intel.com>
References: <20220623165226.1335679-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623165226.1335679-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi "Jason,

I love your patch! Yet something to improve:

[auto build test ERROR on tip/timers/core]
[also build test ERROR on linus/master v5.19-rc3 next-20220623]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-A-Donenfeld/timekeeping-contribute-wall-clock-to-rng-on-time-change/20220624-010017
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git 57963a92a70b037aa22544fbc34742e5be689c04
config: i386-tinyconfig (https://download.01.org/0day-ci/archive/20220624/202206240128.jVs1F5jD-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/f2f11bc49b9a71c5663e44d46c8265f9b4fc8011
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jason-A-Donenfeld/timekeeping-contribute-wall-clock-to-rng-on-time-change/20220624-010017
        git checkout f2f11bc49b9a71c5663e44d46c8265f9b4fc8011
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash kernel/time/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   kernel/time/timekeeping.c: In function 'do_settimeofday64':
>> kernel/time/timekeeping.c:1349:9: error: implicit declaration of function 'add_device_randomness' [-Werror=implicit-function-declaration]
    1349 |         add_device_randomness(&xt, sizeof(xt));
         |         ^~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/add_device_randomness +1349 kernel/time/timekeeping.c

  1303	
  1304	/**
  1305	 * do_settimeofday64 - Sets the time of day.
  1306	 * @ts:     pointer to the timespec64 variable containing the new time
  1307	 *
  1308	 * Sets the time of day to the new time and update NTP and notify hrtimers
  1309	 */
  1310	int do_settimeofday64(const struct timespec64 *ts)
  1311	{
  1312		struct timekeeper *tk = &tk_core.timekeeper;
  1313		struct timespec64 ts_delta, xt;
  1314		unsigned long flags;
  1315		int ret = 0;
  1316	
  1317		if (!timespec64_valid_settod(ts))
  1318			return -EINVAL;
  1319	
  1320		raw_spin_lock_irqsave(&timekeeper_lock, flags);
  1321		write_seqcount_begin(&tk_core.seq);
  1322	
  1323		timekeeping_forward_now(tk);
  1324	
  1325		xt = tk_xtime(tk);
  1326		ts_delta = timespec64_sub(*ts, xt);
  1327	
  1328		if (timespec64_compare(&tk->wall_to_monotonic, &ts_delta) > 0) {
  1329			ret = -EINVAL;
  1330			goto out;
  1331		}
  1332	
  1333		tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts_delta));
  1334	
  1335		tk_set_xtime(tk, ts);
  1336	out:
  1337		timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
  1338	
  1339		write_seqcount_end(&tk_core.seq);
  1340		raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
  1341	
  1342		/* Signal hrtimers about time change */
  1343		clock_was_set(CLOCK_SET_WALL);
  1344	
  1345		if (!ret)
  1346			audit_tk_injoffset(ts_delta);
  1347	
  1348		ktime_get_real_ts64(&xt);
> 1349		add_device_randomness(&xt, sizeof(xt));
  1350	
  1351		return ret;
  1352	}
  1353	EXPORT_SYMBOL(do_settimeofday64);
  1354	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

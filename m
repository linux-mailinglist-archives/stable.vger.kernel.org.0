Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A8C4C6213
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 05:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiB1ENL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Feb 2022 23:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiB1ENK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Feb 2022 23:13:10 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AE2140CE;
        Sun, 27 Feb 2022 20:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646021552; x=1677557552;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ocK6ZP2mK1wKemwv/elqPI/0sCyXe1h1t41j25nr/28=;
  b=bkn0oFg9CUDCSqM2KQYfTyLyUB6sLizm7UvXQrxncVuU9GSDeeS3d0GH
   kITaEk6gllinPZITwDyByXLFdhzgPs9qfh5JNhjpQFbNch0IJcoMwSVtw
   Pu0oFbVoOwjYzY8C59zVhAEvHgT9XyQNsLYRsoLpYdkKWJIMlheZEUOzE
   hMOyjKcdidyq1SMt2Ilhjce1hShwK2wkqLj7uAaCaG+QUHhkGD1KqGoGk
   ftPYrzNtR4qQfsssC2so8TPpFHVsbhQq7nWbSAX2mqenpwnnmHWBTyyBz
   Yi5wp+TiemtSIu3FGAMVitQLRvoosiYJZCoBti1qDzZfGWlnEV3Fctm10
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240212221"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240212221"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 20:12:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="801398953"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.189])
  by fmsmga005.fm.intel.com with ESMTP; 27 Feb 2022 20:12:29 -0800
Date:   Mon, 28 Feb 2022 12:12:28 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Doug Smythies <dsmythies@telus.net>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220228041228.GH4548@shbuild999.sh.intel.com>
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAJZ5v0jsy0q3-ZqYvDrswY1F+tJsG6oNjNJPzz9zzkgdnoMwkw@mail.gmail.com>
 <20220224080830.GD4548@shbuild999.sh.intel.com>
 <5562542.DvuYhMxLoT@kreacher>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 04:36:53PM -0800, Doug Smythies wrote:
> On Fri, Feb 25, 2022 at 9:46 AM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >
> > On Thursday, February 24, 2022 9:08:30 AM CET Feng Tang wrote:
> ...
> > > > So it looks like a new mechanism is needed for that.
> > >
> > > If you think idle class is not the right place to solve it, I can
> > > also help testing new patches.
> >
> > So I have the appended experimental patch to address this issue that's not
> > been tested at all.  Caveat emptor.
> 
> Hi Rafael,
> 
> O.K., you gave fair warning.
> 
> The patch applied fine.
> It does not compile for me.
> The function cpuidle_update_retain_tick does not exist.
> Shouldn't it be somewhere in cpuidle.c?
> I used the function cpuidle_disable_device as a template
> for searching and comparing.
> 
> Because all of my baseline results are with kernel 5.17-rc3,
> that is what I am still using.
> 
> Error:
> ld: drivers/cpufreq/intel_pstate.o: in function `intel_pstate_update_perf_ctl':
> intel_pstate.c:(.text+0x2520): undefined reference to
> `cpuidle_update_retain_tick'
 
Same here, seems the cpuidle_update_retain_tick()'s implementation
is missing.

Thanks,
Feng

> ... Doug
> 
> >
> > I've been looking for something relatively low-overhead and taking all of the
> > dependencies into account.
> >
> > ---
> >  drivers/cpufreq/intel_pstate.c     |   40 ++++++++++++++++++++++++++++---------
> >  drivers/cpuidle/governors/ladder.c |    6 +++--
> >  drivers/cpuidle/governors/menu.c   |    2 +
> >  drivers/cpuidle/governors/teo.c    |    3 ++
> >  include/linux/cpuidle.h            |    4 +++
> >  5 files changed, 44 insertions(+), 11 deletions(-)

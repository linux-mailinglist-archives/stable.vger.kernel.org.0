Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403C44C0648
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 01:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbiBWAlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 19:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiBWAlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 19:41:11 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19735F8F7;
        Tue, 22 Feb 2022 16:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645576844; x=1677112844;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bXG/hqPanWAZqS1VkKyT5WERuxbLoNAjWQs8L+yqxEg=;
  b=YftGCQmzBOAr6wQwUjZ6cNYRcnQZMx1kGLyYkYhh9MC/xxUIosKClf/G
   3U4T1VZz5hmv3ymt1vfy7KqgePwItipphY8T4wQ8ToCJ3lXzWuGxoj/59
   0FqWkIiw9cnRU5meORy1qWOPAmzgkNEgqlfIG/2Zu2auln5JQ+BVJPqO1
   EoNF6tUkIEPnICWeZefEnRAYTaz5s8YofpFOY6b1hikZ1+mYTxjARoLhX
   27dQn3481V5C1UjQ2X4qzUrNi31u5BuUL9uCwc6AP0n+tTcjgLlWdb5TJ
   075q/2b3BmGemlpYdCQmSx18sbXGeb6qds8LedT5wVYeCzfze13RkosNo
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="235360402"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="235360402"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 16:40:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="776497120"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.189])
  by fmsmga006.fm.intel.com with ESMTP; 22 Feb 2022 16:40:41 -0800
Date:   Wed, 23 Feb 2022 08:40:41 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220223004041.GA4548@shbuild999.sh.intel.com>
References: <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com>
 <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <e185b89fb97f47758a5e10239fc3eed0@intel.com>
 <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
 <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
 <20220222073435.GB78951@shbuild999.sh.intel.com>
 <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
 <CAAYoRsX-iw+88R9ZizMwJw2qc99XJZ8Fe0M5ETOy4=RUNsxWhQ@mail.gmail.com>
 <24f7d485dc60ba3ed5938230f477bf22a220d596.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24f7d485dc60ba3ed5938230f477bf22a220d596.camel@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 22, 2022 at 04:32:29PM -0800, srinivas pandruvada wrote:
> Hi Doug,
> 
> On Tue, 2022-02-22 at 16:07 -0800, Doug Smythies wrote:
> > Hi All,
> > 
> > I am about 1/2 way through testing Feng's "hacky debug patch",
> > let me know if I am wasting my time, and I'll abort. So far, it
> > works fine.
> This just proves that if you add some callback during long idle,  you
> will reach a less aggressive p-state. I think you already proved that
> with your results below showing 1W less average power ("Kernel 5.17-rc3
> + Feng patch (6 samples at 300 sec per").
> 
> Rafael replied with one possible option. Alternatively when planing to
> enter deep idle, set P-state to min with a callback like we do in
> offline callback.
 
Yes, if the system is going to idle, it makes sense to goto a lower
cpufreq first (also what my debug patch will essentially lead to).

Given cprfreq-util's normal running frequency is every 10ms, doing
this before entering idle is not a big extra burden.

Thanks,
Feng

> So we need to think about a proper solution for this.
> 
> Thanks,
> Srinivas

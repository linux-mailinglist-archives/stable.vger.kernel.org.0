Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1886C4C3284
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 18:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiBXQ7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 11:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiBXQ7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 11:59:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FF56EB27;
        Thu, 24 Feb 2022 08:58:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49D55CE1FE7;
        Thu, 24 Feb 2022 16:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6D8C340F1;
        Thu, 24 Feb 2022 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645721906;
        bh=zaXNNO1abKZKfHvCHwy49+rsuy0+ifUZOLnYMGAI2AA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=MCGXVKasHCTJ4dwAiMJhuUOVUaTqXwjfXLXD1QM4yn/lzX9F5+u2xjiTEGNENfu/4
         In52Y2Jd3XdO/wpr1qWL1KaLHFiK7f490yVGe59N72+0mkCisq1TbHfjUeWQCVG8Ky
         LcOxKuhEeiX0a9uE5bPHl6C+clDc6KOHfORNSKJp6gRgN5mBhSqNtt2aduZ0OQEfMJ
         Qd0xYZgnl+9h4NcI8RoDBVZWiZJQtHQvq2uT5k/VX1/PSW6nU1H4ERTZ+1Y22twi7+
         kbWRiucTxu+1lm3XhcqVcmBPslfDkDOpB/QusJr1HIvU2NpTioBR6QYL098n1KMQ3T
         689kKArvEx0fw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 1747D5C0144; Thu, 24 Feb 2022 08:58:26 -0800 (PST)
Date:   Thu, 24 Feb 2022 08:58:26 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Doug Smythies <dsmythies@telus.net>
Cc:     "'Rafael J. Wysocki'" <rafael@kernel.org>,
        'srinivas pandruvada' <srinivas.pandruvada@linux.intel.com>,
        "'Zhang, Rui'" <rui.zhang@intel.com>,
        'Thomas Gleixner' <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-pm@vger.kernel.org,
        'Feng Tang' <feng.tang@intel.com>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220224165826.GW4285@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
 <20220222073435.GB78951@shbuild999.sh.intel.com>
 <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
 <CAAYoRsX-iw+88R9ZizMwJw2qc99XJZ8Fe0M5ETOy4=RUNsxWhQ@mail.gmail.com>
 <24f7d485dc60ba3ed5938230f477bf22a220d596.camel@linux.intel.com>
 <20220223004041.GA4548@shbuild999.sh.intel.com>
 <CAJZ5v0jsy0q3-ZqYvDrswY1F+tJsG6oNjNJPzz9zzkgdnoMwkw@mail.gmail.com>
 <20220224080830.GD4548@shbuild999.sh.intel.com>
 <20220224144423.GV4285@paulmck-ThinkPad-P17-Gen-1>
 <002901d8299b$af50d6d0$0df28470$@telus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002901d8299b$af50d6d0$0df28470$@telus.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 08:29:22AM -0800, Doug Smythies wrote:
> 
> On 2022.02.24 04:08:30 Paul E. McKenney wrote:
> > On Thu, Feb 24, 2022 at 04:08:30PM +0800, Feng Tang wrote:
> >> On Wed, Feb 23, 2022 at 03:23:20PM +0100, Rafael J. Wysocki wrote:
> >>> On Wed, Feb 23, 2022 at 1:40 AM Feng Tang <feng.tang@intel.com> wrote:
> >>> 
> >>> But this is not related to idle as such, but to the fact that idle
> >>> sometimes stops the scheduler tick which otherwise would run the
> >>> cpufreq governor callback on a regular basis.
> >>> 
> >>> It is stopping the tick that gets us into trouble, so I would avoid
> >>> doing it if the current performance state is too aggressive.
> >> 
> >> I've tried to simulate Doug's environment by using his kconfig, and
> >> offline my 36 CPUs Desktop to leave 12 CPUs online, and on it I can
> >> still see Local timer interrupts when there is no active load, with
> >> the longest interval between 2 timer interrupts is 4 seconds, while
> >> idle class's task_tick_idle() will do nothing, and CFS'
> >> task_tick_fair() will in turn call cfs_rq_util_change()
> >
> > Every four seconds?  Could you please post your .config?
> >
> >							Thanx, Paul
> 
> I steal the kernel config from the Ubuntu mainline PPA.
> See also earlier on this thread:
> 
> https://lore.kernel.org/linux-pm/CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com/
> 
> but relevant part copied here:
> 
> > I steal the kernel configuration file from the Ubuntu mainline PPA
> > [1], what they call "lowlatency", or 1000Hz tick. I make these
> > changes before compile:
> >
> > scripts/config --disable DEBUG_INFO
> > scripts/config --disable SYSTEM_TRUSTED_KEYS
> > scripts/config --disable SYSTEM_REVOCATION_KEYS
> >
> > I [will] also send you the config and dmesg files in an off-list email.
> >
> > [1] https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.17-rc3/
> 
> I put the same one I sent Feng on my web site where I was
> sharing stuff with Srinivas (coded to avoid the barrage of bots):
> 
> double u double u double u dot smythies dot com/~doug/linux/s18/hwp/srinivas/long_dur/

Thank you!

I don't see CONFIG_FAST_NO_HZ=y in your .config, so that is not the
reason for your every-four-second timers.  ;-)

(CONFIG_FAST_NO_HZ is being removed, FYI.)

							Thanx, Paul

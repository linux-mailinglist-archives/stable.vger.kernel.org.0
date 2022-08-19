Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E91599DF3
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349111AbiHSPC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348481AbiHSPC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:02:26 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D6FF491B;
        Fri, 19 Aug 2022 08:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660921344; x=1692457344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WGm39jjx7uGroPnb019eE2GYX5oo/Dv4oc7z73s25P4=;
  b=SQxe03wOaRoRgeTi9iWklWGnf6pC647A4F7p47ziw1IcTTBcnXn/QPfu
   S942h6naA/OOKPa43kZQj2LTLHW+M7/A2mKGw4NBfFnKMetWUWNRv0lik
   6F01LkLZbXXU47sHVpz6wq+afzJtYTvtdnPn0tXzkpx/6J91jr7hotIt5
   4vv4XU3UNRaksIQHtKlb3+fqzKIIUJrt7Kl1ru5Z/T1oX1jK5OHcrU4Tc
   zrEx1pvNqXodZ/Ex+DYgeyoOTNxT7YA37koxyAuBnylveUFRH1rGb5H1I
   D+vYRR0qnHrMEwE5BQQKMWyIm11udKg52yM1jk6Saxfj8nSuJQL52QUqz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="354767902"
X-IronPort-AV: E=Sophos;i="5.93,248,1654585200"; 
   d="scan'208";a="354767902"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 08:02:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,248,1654585200"; 
   d="scan'208";a="668624692"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 19 Aug 2022 08:02:14 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27JF2DAO002452;
        Fri, 19 Aug 2022 16:02:13 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
        lkp@intel.com, stable@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] kallsyms: add option to include relative filepaths into kallsyms
Date:   Fri, 19 Aug 2022 17:00:24 +0200
Message-Id: <20220819150024.1135360-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <Yv9t3y5kkuFKCPKp@kroah.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com> <20220818115306.1109642-4-alexandr.lobakin@intel.com> <Yv4vT6s6UHYvXOlX@kroah.com> <20220818135629.1113036-1-alexandr.lobakin@intel.com> <Yv5IfiwqGumJwVGT@kroah.com> <20220819105001.1130876-1-alexandr.lobakin@intel.com> <Yv9t3y5kkuFKCPKp@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Fri, 19 Aug 2022 13:02:55 +0200

> On Fri, Aug 19, 2022 at 12:50:01PM +0200, Alexander Lobakin wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Date: Thu, 18 Aug 2022 16:11:10 +0200
> > 
> > > On Thu, Aug 18, 2022 at 03:56:29PM +0200, Alexander Lobakin wrote:
> > > > From: Greg KH <gregkh@linuxfoundation.org>
> > > > Date: Thu, 18 Aug 2022 14:23:43 +0200
> > > > 
> > > > > On Thu, Aug 18, 2022 at 01:53:06PM +0200, Alexander Lobakin wrote:
> > > > > > Currently, kallsyms kernel code copes with symbols with the same
> > > > > > name by indexing them according to their position in vmlinux and
> > > > > > requiring to provide an index of the desired symbol. This is not
> > > > > > really quite reliable and is fragile to any features performing
> > > > > > symbol or section manipulations such as FG-KASLR.
> > > > > 
> > > > > Ah, here's the reasoning, stuff like this should go into the 0/X message
> > > > > too, right?
> > > > > 
> > > > > Anyway, what is currently broken that requires this?  What will this
> > > > > make easier in the future?  What in the future will depend on this?
> > > > 
> > > > 2) FG-KASLR will depend and probably some more crazy hardening
> > > >    stuff. And/or perf-based function/symbol placement, which is
> > > >    in the "discuss and dream sometimes" stage.
> > > 
> > > I have no idea what "FG-KASLR" is.  Why not submit these changes when
> > > whatever that is is ready for submission?
> > 
> > It doesn't matter much, the main idea is that the current approach
> > with relying on symbol positions in the vmlinux is broken when we
> > reorder symbols during the kernel initialization.
> > As I said, this is an early RFC do discuss the idea and the
> > implementation. I could submit it along with FG-KASLR, but then if
> > there would be major change requests, I'd need to redo lots of
> > stuff, which is not very efficient. It's better to settle down the
> > implementation details in advance.
> 
> It's better for you to get this all working on your own first, before
> asking the community to review and accept something that is not required
> at all for the kernel today.  Why waste our time for no benefit to the
> kernel now?

I didn't ask anyone to waste his time or review or accept (BTW,
accept RFC?). Who is interested, can take a look and do whatever
he wants.

I thought RFCs work that way... I remember one guy came to the
netdev several months with an idea. He also had early RFC which was
submitted only to show the direction of thought, many parts were
missing as they required establishing the design.
So there was a discussion with advices and no objections. After it
calmed cown, he went back to finish stuff and a week ago he came
with a "regular" version already, with all the stuff finished and
all the drivers converted (100+).
Would it be better if he didn't do an early RFC, finished all the
stuff first, then published v1, then someone told him "no, do it
the other way around" and he went back to redo 100+ drivers
conversion?
Confused =\

(not to mention his changeset only makes room for future features
 with no practical outcome for the current code)

> 
> You all know better than this.  As it is, Intel is on "thin ice" when it
> comes to kernel submissions and abusing the community by sending stuff
> out when it is not reviewed by anyone internally and needs correcting,
> don't make it any worse.

It will have all the tags needed once it's v1. For now, Reviewed-by
for what, for a [volunteer] discussion, which would better happen
either way?

(also, PeterZ told me to send FG-KALSR stuff directly last time :P)

> 
> greg k-h

Thanks,
Olek

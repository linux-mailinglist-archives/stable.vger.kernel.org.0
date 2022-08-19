Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AAC599E09
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349507AbiHSPTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349497AbiHSPTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:19:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79D483BFB;
        Fri, 19 Aug 2022 08:19:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5150CB8277D;
        Fri, 19 Aug 2022 15:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D477C433D6;
        Fri, 19 Aug 2022 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660922345;
        bh=WeTO5jxgCZ/KShRn9C07CqYN737Q/MY/MHe0aYDruDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fEH9Vu55btHIArSbPbp0cSwd3DyFqpINn/1wGIOfcwKnlEmZGxb3Oe9EvefMWiwpd
         g8lv1L5Ru9LIn2SYEWcOapXb27CESEUmKIMSrkF+5ZW01dEFUCeLPAOlN2lmQAMHkt
         HRSsh04CCfP1eVjkQ7+Gv05GzJNTgV4CWy2+5EaQ=
Date:   Fri, 19 Aug 2022 17:19:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     linux-kernel@vger.kernel.org,
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
Subject: Re: [RFC PATCH 3/3] kallsyms: add option to include relative
 filepaths into kallsyms
Message-ID: <Yv+p5dMjUDZpSGBe@kroah.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
 <20220818115306.1109642-4-alexandr.lobakin@intel.com>
 <Yv4vT6s6UHYvXOlX@kroah.com>
 <20220818135629.1113036-1-alexandr.lobakin@intel.com>
 <Yv5IfiwqGumJwVGT@kroah.com>
 <20220819105001.1130876-1-alexandr.lobakin@intel.com>
 <Yv9t3y5kkuFKCPKp@kroah.com>
 <20220819150024.1135360-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819150024.1135360-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 05:00:24PM +0200, Alexander Lobakin wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Fri, 19 Aug 2022 13:02:55 +0200
> 
> > On Fri, Aug 19, 2022 at 12:50:01PM +0200, Alexander Lobakin wrote:
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Date: Thu, 18 Aug 2022 16:11:10 +0200
> > > 
> > > > On Thu, Aug 18, 2022 at 03:56:29PM +0200, Alexander Lobakin wrote:
> > > > > From: Greg KH <gregkh@linuxfoundation.org>
> > > > > Date: Thu, 18 Aug 2022 14:23:43 +0200
> > > > > 
> > > > > > On Thu, Aug 18, 2022 at 01:53:06PM +0200, Alexander Lobakin wrote:
> > > > > > > Currently, kallsyms kernel code copes with symbols with the same
> > > > > > > name by indexing them according to their position in vmlinux and
> > > > > > > requiring to provide an index of the desired symbol. This is not
> > > > > > > really quite reliable and is fragile to any features performing
> > > > > > > symbol or section manipulations such as FG-KASLR.
> > > > > > 
> > > > > > Ah, here's the reasoning, stuff like this should go into the 0/X message
> > > > > > too, right?
> > > > > > 
> > > > > > Anyway, what is currently broken that requires this?  What will this
> > > > > > make easier in the future?  What in the future will depend on this?
> > > > > 
> > > > > 2) FG-KASLR will depend and probably some more crazy hardening
> > > > >    stuff. And/or perf-based function/symbol placement, which is
> > > > >    in the "discuss and dream sometimes" stage.
> > > > 
> > > > I have no idea what "FG-KASLR" is.  Why not submit these changes when
> > > > whatever that is is ready for submission?
> > > 
> > > It doesn't matter much, the main idea is that the current approach
> > > with relying on symbol positions in the vmlinux is broken when we
> > > reorder symbols during the kernel initialization.
> > > As I said, this is an early RFC do discuss the idea and the
> > > implementation. I could submit it along with FG-KASLR, but then if
> > > there would be major change requests, I'd need to redo lots of
> > > stuff, which is not very efficient. It's better to settle down the
> > > implementation details in advance.
> > 
> > It's better for you to get this all working on your own first, before
> > asking the community to review and accept something that is not required
> > at all for the kernel today.  Why waste our time for no benefit to the
> > kernel now?
> 
> I didn't ask anyone to waste his time or review or accept (BTW,
> accept RFC?). Who is interested, can take a look and do whatever
> he wants.
> 
> I thought RFCs work that way... I remember one guy came to the
> netdev several months with an idea. He also had early RFC which was
> submitted only to show the direction of thought, many parts were
> missing as they required establishing the design.
> So there was a discussion with advices and no objections. After it
> calmed cown, he went back to finish stuff and a week ago he came
> with a "regular" version already, with all the stuff finished and
> all the drivers converted (100+).
> Would it be better if he didn't do an early RFC, finished all the
> stuff first, then published v1, then someone told him "no, do it
> the other way around" and he went back to redo 100+ drivers
> conversion?
> Confused =\

I'll let you work out the issues with how Intel is supposed to be
submitting patches to the kernel with your internal management chain, as
there are some restrictions that you all have that other (i.e. everyone
else) do not have.

good luck!

greg k-h

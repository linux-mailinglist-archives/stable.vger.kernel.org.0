Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1505955FD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiHPJO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiHPJNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:13:54 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442C976766
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 00:29:33 -0700 (PDT)
Received: from quatroqueijos (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id B28C13FBF4;
        Tue, 16 Aug 2022 07:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660634970;
        bh=hw9sz7E+VvmZCg/wDbC6LaCMVEnM9RDZYdTyJ13W+Qw=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=kqEaykXZm/ukGq5kbbOL+SR6LaZwkdaeB8bPBDVqYJxh7irHt8RU7CU7koqd4IHxx
         dzQdvysEuZfNKG++FRK+UWYpWi+ESsfmcnwcKRZlP3BsNEnGbnChTsFV6hBT8SNl1X
         dSBM0Mq6Jp5IVLXAuaz9ZGJ+RyZAHSmurLXIkIPCG/XeTj31zmw8qV37DGoAtjhebp
         Edim/QtvhRD3GbrhsdZt16wDDF/UJ8m0RawmSCrGoe2mEVqEx2/Iron7OYCiycnO9T
         SrUoxOxWkESt2zEjIoR1fDYzHqScgPUzz6/kSj+it55YW5g0cWVMHBEPM6c/iWBQ1Y
         wtlniQ/HjxX/Q==
Date:   Tue, 16 Aug 2022 04:29:24 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: v5.15.57 regression - boot panic after retbleed backports with
 CONFIG_KPROBES_SANITY_TEST=y
Message-ID: <YvtHVORl4FqwEM9y@quatroqueijos>
References: <20220805200438.GC42579@windriver.com>
 <Yu2H/Rdg/U4bHWaY@quatroqueijos>
 <20220806001100.GD42579@windriver.com>
 <YvEULC3tjmzgan7J@kroah.com>
 <20220816041224.GE73154@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816041224.GE73154@windriver.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 12:12:24AM -0400, Paul Gortmaker wrote:
> [Re: v5.15.57 regression - boot panic after retbleed backports with CONFIG_KPROBES_SANITY_TEST=y] On 08/08/2022 (Mon 15:48) Greg Kroah-Hartman wrote:
> 
> > On Fri, Aug 05, 2022 at 08:11:00PM -0400, Paul Gortmaker wrote:
> > > [Re: v5.15.57 regression - boot panic after retbleed backports with CONFIG_KPROBES_SANITY_TEST=y] On 05/08/2022 (Fri 18:13) Thadeu Lima de Souza Cascardo wrote:
> 
> [...]
> 
> > > > Can you try the patch below?
> > > 
> > > [    2.529263] rcu: Hierarchical SRCU implementation.
> > > [    2.530393] Kprobe smoke test: started
> > > [    2.555965] Kprobe smoke test: passed successfully
> > > [    2.556454] smp: Bringing up secondary CPUs ...
> > > 
> > > As per above, the same spot in the kprobe test seems to manage to not
> > > panic anymore and the remainder of the boot looks clean and normal.
> > > 
> > > I tested directly on vanilla v5.15.57.
> > > 
> > > Thanks for the quick response!
> > 
> > Great, can someone send a "real" patch for this then?
> 
> Cascardo,
> 
> Was this a final patch or just a "can you test this so we can better
> understand the regression"  intermediate step?  I don't think anyone
> wants to guess at that or at what you wanted to put in the commit log.
> 
> It would be nice to close this out vs. leaving it hanging out there.
> 
> Thanks,
> Paul.
> --

Not a final thing, I was catching up on other stuff before I could go back to
it, was planning on doing it this week. Just need to sort out the order of some
commits here to get to that end result.

Cascardo.

> 
> > 
> > thanks,
> > 
> > greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C7958C9BB
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 15:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbiHHNsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 09:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235211AbiHHNse (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 09:48:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C37F63A5
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 06:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 234D960B2A
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 13:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F252BC433D6;
        Mon,  8 Aug 2022 13:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659966511;
        bh=YLweYGK26eEVgnzxUrDhkIJBGh8Vbv2cPQIlgTuFYN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HsT0F3IYUfU9uewY4UjjqMdSacXaq2qF+LVeOuYXVPzvRF3S6TV/9EhS22tiX1A05
         RNAyU7Nl0c+nwAPygPmsp27loOFt6aAalAdK29U31U/m6sVQL9cBiI/H7hVZW1FeMv
         s6nrXOwGcJfYWRNhe1PJYQwGXbybuFhe7M25F5kU=
Date:   Mon, 8 Aug 2022 15:48:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: v5.15.57 regression - boot panic after retbleed backports with
 CONFIG_KPROBES_SANITY_TEST=y
Message-ID: <YvEULC3tjmzgan7J@kroah.com>
References: <20220805200438.GC42579@windriver.com>
 <Yu2H/Rdg/U4bHWaY@quatroqueijos>
 <20220806001100.GD42579@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806001100.GD42579@windriver.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 05, 2022 at 08:11:00PM -0400, Paul Gortmaker wrote:
> [Re: v5.15.57 regression - boot panic after retbleed backports with CONFIG_KPROBES_SANITY_TEST=y] On 05/08/2022 (Fri 18:13) Thadeu Lima de Souza Cascardo wrote:
> 
> > On Fri, Aug 05, 2022 at 04:04:38PM -0400, Paul Gortmaker wrote:
> > > The panic comes from the sanity test code, but after trying to boil down the
> > > .config differences between the kitchen sink our test team uses, and a
> > > "defconfig", it seems there are at least a couple extra dependencies for
> > > creating a reproducer:
> 
> [...]
> 
> > > 
> > >    rcu: Hierarchical SRCU implementation.
> > >    Kprobe smoke test: started
> > >    BUG: unable to handle page fault for address: ffffffffc110f3e7
> > >    #PF: supervisor instruction fetch in kernel mode
> > >    #PF: error_code(0x0010) - not-present page
> > >    PGD b2c60f067 P4D b2c60f067 PUD b2c611067 PMD 0
> > >    Oops: 0010 [#1] SMP NOPTI
> > >    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.57 #33
> 
> [...]
> 
> > Can you try the patch below?
> 
> [    2.529263] rcu: Hierarchical SRCU implementation.
> [    2.530393] Kprobe smoke test: started
> [    2.555965] Kprobe smoke test: passed successfully
> [    2.556454] smp: Bringing up secondary CPUs ...
> 
> As per above, the same spot in the kprobe test seems to manage to not
> panic anymore and the remainder of the boot looks clean and normal.
> 
> I tested directly on vanilla v5.15.57.
> 
> Thanks for the quick response!

Great, can someone send a "real" patch for this then?

thanks,

greg k-h

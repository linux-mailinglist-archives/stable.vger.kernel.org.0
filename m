Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E776798DF
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbjAXNEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbjAXNEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:04:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C853D6E9A;
        Tue, 24 Jan 2023 05:04:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61AEF6118A;
        Tue, 24 Jan 2023 13:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7EBC433D2;
        Tue, 24 Jan 2023 13:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674565445;
        bh=2oB3pEL4+cS8Zxv6Zx0gL49GULwbzGDIpgdl3TDQdvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KsVbDZEVdpiIq7aBckjEQB0NO/GasxPLEeqBGhuc6h4jvFgSiiXvCNJ9ulbKmt6u7
         Xvn4BCrMbKhrEWa0JG2j6E21MDh+Q9ZsB2gGW6drLAGPJUmNCK8qubHCNvBt+hJIaX
         nOmVd0zwAEq1sMmf0QhIJpbqizeYNDCsG8iAWP6DNiGTPLyApgMtJXuZ8vZMz0okX+
         XWVx8RUVBXAFJFvFIAmc9tTXBFIJ7LKFVlmf2vpt64bh/dJ3nogRijlgqgejh3+sF1
         4WakmSh2KcULLlscFJzMPfr0THymEIRXkhCN/bThaA5Rq6b54cRctqyEiU9B5J4ZQK
         XwzY3AUrJGPJA==
Date:   Tue, 24 Jan 2023 14:59:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, darwi@linutronix.de,
        elena.reshetova@intel.com, kirill.shutemov@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Message-ID: <Y8/WPAqZACAHcmf+@unreal>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
 <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
 <Y8z7FPcuDXDBi+1U@unreal>
 <87v8kwp2t6.fsf@ubik.fi.intel.com>
 <Y8/Kyzh+stow83lQ@unreal>
 <87pmb4p0ik.fsf@ubik.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmb4p0ik.fsf@ubik.fi.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 02:42:11PM +0200, Alexander Shishkin wrote:
> Leon Romanovsky <leon@kernel.org> writes:
> 
> > On Tue, Jan 24, 2023 at 01:52:37PM +0200, Alexander Shishkin wrote:
> >> Leon Romanovsky <leon@kernel.org> writes:
> >> 
> >> > I'm not security expert here, but not sure that this protects from anything.
> >> > 1. Kernel relies on working and not-malicious HW. There are gazillion ways
> >> > to cause crashes other than changing MSI-X.
> >> 
> >> This particular bug was preventing our fuzzing from going deeper into
> >> the code and reaching some more of the aforementioned gazillion bugs.
> >
> > Your commit message says nothing about fuzzing, but talks about
> > malicious device. 
> 
> A malicious device is what the fuzzing is aiming to simulate. The fact
> of fuzzing process itself didn't seem relevant to the patch, so I didn't
> include it, going instead for the problem statement and proposed
> solution. Will the commit message benefit from mentioning fuzzing?

No, for most if not all kernel developers, the fuzzing means some sort of
random user-space input. PCI devices are trusted in the kernel.

> 
> > Do you see "gazillion bugs" for devices which don't change their MSI-X
> > table size under the hood, which is main kernel assumption?
> 
> Not so far.

So please share them with us.

> 
> > If yes, you should fix these bugs.
> 
> That's absolutely the intention.

So let's fix the bugs and not hide them.

> 
> >> > 2. Device can report large table size, kernel will cache it and
> >> > malicious device will reduce it back. It is not handled and will cause
> >> > to kernel crash too.
> >> 
> >> How would that happen? If the device decides to have fewer vectors,
> >> they'll all still fit in the ioremapped MSIX table. The worst thing that
> >> can happen is 0xffffffff reads from the mmio space, which a device can
> >> do anyway. But that shouldn't trigger a page fault or otherwise
> >> crash. Or am I missing something?
> >
> > Like I said, I'm no expert. You should tell me if it safe for all
> > callers of pci_msix_vec_count().
> 
> Well, since you stated that the reverse will cause a kernel crash, I had
> to ask how. I'll include some version of the above paragraph in the
> commit message to indicate that we reverse situation has been considered.

Not really. I didn't see any explanation how will it work if number
of vectors (which MSI-X table represents) is completely different from
seeing by PCI core.

Thanks

> 
> Regards,
> --
> Alex

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6296084A4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 07:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiJVFjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 01:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJVFju (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 01:39:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C197D4D816;
        Fri, 21 Oct 2022 22:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82CD960A6E;
        Sat, 22 Oct 2022 05:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40640C433D6;
        Sat, 22 Oct 2022 05:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666417180;
        bh=hqdMY7yPv6V7HyzJ2Rim7EGPPF8KuXBPRX6lKlqeDGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hZz3xX8LTH1IjkRCd7879LdRGN5fqr1oSjqfYbs6qQga6C2KYW4qBkOnuWYErFZXm
         d2eV8daHdyiRJXPxtaRqKYUMOfMtJsnDlDS89l6CYy8k+q/EoQgPQSYqnVWdQwp7zQ
         VfZ4DRoBQKuKgdfH6WNxvyv0+lINu9Ud+fU9vjew=
Date:   Sat, 22 Oct 2022 07:40:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joe Korty <joe.korty@concurrent-rt.com>
Cc:     Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: arch_timer: XGene-1 has 31 bit, not 32 bit, arch
 timer.
Message-ID: <Y1OCTh4z4qh8kx4I@kroah.com>
References: <20221021153424.GA25677@zipoli.concurrent-rt.com>
 <864jvxnj65.wl-maz@kernel.org>
 <20221021194746.GA5830@zipoli.concurrent-rt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021194746.GA5830@zipoli.concurrent-rt.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 03:47:46PM -0400, Joe Korty wrote:
> Hi Marc,
> 
> On Fri, Oct 21, 2022 at 07:08:50PM +0100, Marc Zyngier wrote:
> > Sorry, but you'll have to provide a bit more of an analysis here. As
> > far as I can tell, you're just changing a parameter without properly
> > describing what breaks and how.
> 
> There isn't much to analyse.  For ages, 0x7fffffff (31 bits) was the
> declared width of 'arch timer' for all arm architures, and that worked.
> Your patch series made the declared width vary according to which chipset
> was in use, which is good, but that rewrite changed the above mask for
> the XGene-1 from 0x7fffffff to 0xffffffff.  That change broke timers
> for the XGene-1 since it seems that, in actuality, it has only a 31 bit
> wide arch timer.  Thus declaring that arch timer has 32-bits is wrong.
> This mismatch between the actual and declared sizes would cause arithmetic
> errors in the calculation of timer deltas which more than accounts for
> the hrtimer failures I am seeing when running 5.16+ on my Mustang XGene1.
> 
> Only one line need change, the rest are fluff:
> 
> -             return CLOCKSOURCE_MASK(32);
> +             return CLOCKSOURCE_MASK(31);
> 
> > Also, this isn't much of a patch.
> 
> I don't know what this means.  The patch contains all that is needed for
> the fix, no more.  I could add more comments as to _why_ it is 31 bits
> not 32, but I don't know why.  I only know that the motherboard behaves
> as if 31 bits is all that is available in the hardware.
> 
> > Please see the documentation on how to properly submit one.
> 
> AFAICS, the only submission mistake is that the 'Cc: stable@vger.kernel.org'
> line is missing.

No, you need a much better changelog text and probably subject line, and
to properly cc: the correct maintainers and developers.  As my bot would
say:

- Kernel development is done in public, please always cc: a public
  mailing list with a patch submission.  Using the tool,
  scripts/get_maintainer.pl on the patch will tell you what mailing list
  to cc.

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.


Thanks,

greg k-h

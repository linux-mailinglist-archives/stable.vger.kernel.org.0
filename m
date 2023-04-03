Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59926D3EF1
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjDCI2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjDCI2R (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 3 Apr 2023 04:28:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EEF46BB;
        Mon,  3 Apr 2023 01:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20A23615CC;
        Mon,  3 Apr 2023 08:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2865BC433D2;
        Mon,  3 Apr 2023 08:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680510495;
        bh=pIseBgJLIy7GHXPUPaPVckdMpxOXWzFHsNtU54I64zE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S/rJjTExLRSbGKh6pIvorCMNVsWaqgufEAVHTG4JDWnabQroDPv2tGvfVfRFLv7Qs
         Bh5O2hDVMq01Yf8GiIeToh8Hl311EXgRUUsAHlNrQ1Yf571Y+e9YTzc21cDJMHVZuE
         yWyUuwXQnvHO6pCnNnYMrwFCfIRtfGgapIaL91eg=
Date:   Mon, 3 Apr 2023 10:28:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, Stable@vger.kernel.org
Subject: Re: [PATCH 3/3] xhci: Free the command allocated for setting LPM if
 we return early
Message-ID: <2023040339-eastbound-boggle-02ca@gregkh>
References: <20230330143056.1390020-1-mathias.nyman@linux.intel.com>
 <20230330143056.1390020-4-mathias.nyman@linux.intel.com>
 <2219a894-eb79-70a4-2b92-2b7ee7e1e966@alu.unizg.hr>
 <2023040352-case-barterer-ccd1@gregkh>
 <eb08643a-eae1-dd59-ba89-bf593405c09f@alu.unizg.hr>
 <711ff3f6-d449-c835-7c0b-4f7a1527a2f7@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <711ff3f6-d449-c835-7c0b-4f7a1527a2f7@alu.unizg.hr>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 10:01:22AM +0200, Mirsad Goran Todorovac wrote:
> On 3.4.2023. 9:57, Mirsad Goran Todorovac wrote:
> > On 3.4.2023. 9:24, Greg KH wrote:
> > > On Mon, Apr 03, 2023 at 09:17:21AM +0200, Mirsad Goran Todorovac wrote:
> > > > Hi, Mathias!
> > > > 
> > > > On 30.3.2023. 16:30, Mathias Nyman wrote:
> > > > > The command allocated to set exit latency LPM values need to be freed in
> > > > > case the command is never queued. This would be the case if there is no
> > > > > change in exit latency values, or device is missing.
> > > > > 
> > > > > Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> > > > > Link: https://lore.kernel.org/linux-usb/24263902-c9b3-ce29-237b-1c3d6918f4fe@alu.unizg.hr
> > > > > Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> > > > > Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
> > > > > Cc: <Stable@vger.kernel.org>
> > > > > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > > > ---
> > > > >    drivers/usb/host/xhci.c | 1 +
> > > > >    1 file changed, 1 insertion(+)
> > > > > 
> > > > > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > > > > index bdb6dd819a3b..6307bae9cddf 100644
> > > > > --- a/drivers/usb/host/xhci.c
> > > > > +++ b/drivers/usb/host/xhci.c
> > > > > @@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
> > > > >        if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
> > > > >            spin_unlock_irqrestore(&xhci->lock, flags);
> > > > > +        xhci_free_command(xhci, command);
> > > > >            return 0;
> > > > >        }
> > > > 
> > > > There seems to be a problem with applying this patch with "git am", as it
> > > > gives the following:
> > > > 
> > > > commit ff9de97baa02cb9362b7cb81e95bc9be424cab89
> > > > Author: @ <@>
> > > > Date:   Mon Apr 3 08:42:33 2023 +0200
> > > > 
> > > >      The command allocated to set exit latency LPM values need to be freed in
> > > >      case the command is never queued. This would be the case if there is no
> > > >      change in exit latency values, or device is missing.
> > > > 
> > > >      Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
> > > >      Cc: <Stable@vger.kernel.org>
> > > >      Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > 
> > > This is already commit f6caea485555 ("xhci: Free the command allocated
> > > for setting LPM if we return early") in Linus's tree, do you not see it
> > > there?
> > > 
> > > And how exactly did you save the message to apply it with 'git am'?  It
> > > worked for me.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > git am ../mathias-xhci.mail
> > 
> > mtodorov@domac:~/linux/kernel/linux_torvalds$ cat ../mathias-xhci.mail
> > From: Mathias Nyman @ 2023-03-27  9:50 UTC (permalink / raw)
> >    To: mirsad.todorovac, linux-usb, linux-kernel
> >    Cc: gregkh, ubuntu-devel-discuss, stern, arnd, Mathias Nyman, Stable
> > 
> > The command allocated to set exit latency LPM values need to be freed in
> > case the command is never queued. This would be the case if there is no
> > change in exit latency values, or device is missing.
> > 
> > Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
> > Cc: <Stable@vger.kernel.org>
> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

That is very odd, your mail program is not getting the full mbox
information here at all.  Try downloading it from lore.kernel.org as a
raw message:
	https://lore.kernel.org/all/20230330143056.1390020-4-mathias.nyman@linux.intel.com/raw
and applying that?

> > ---
> >   drivers/usb/host/xhci.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > index bdb6dd819a3b..6307bae9cddf 100644
> > --- a/drivers/usb/host/xhci.c
> > +++ b/drivers/usb/host/xhci.c
> > @@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
> > 
> >          if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
> >                  spin_unlock_irqrestore(&xhci->lock, flags);
> > +               xhci_free_command(xhci, command);
> >                  return 0;
> >          }
> > 
> > -- 
> > 2.25.1
> > 
> > Sorry, no commit f6caea485555 in the "git pull":
> > 
> > mtodorov@domac:~/linux/kernel/linux_torvalds$ git log --oneline | grep f6caea485555
> > mtodorov@domac:~/linux/kernel/linux_torvalds$ git log --oneline | head -10
> > 10de4cefccf7 memstick: fix memory leak if card device is never registered
> > feeedf59897c platform/x86: think-lmi: Clean up display of current_value on Thinkstation
> > 86cebdbfb8d2 platform/x86: think-lmi: Fix memory leaks when parsing ThinkStation WMI strings
> > ff9de97baa02 The command allocated to set exit latency LPM values need
> > to be freed in case the command is never queued. This would be the case
> > if there is no change in exit latency values, or device is missing.
> > 2ac6d07f1a81 platform/x86: think-lmi: Fix memory leak when showing current settings
> > 7e364e56293b Linux 6.3-rc5
> > 6ab608fe852b Merge tag 'for-6.3-rc4-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
> > f95b8ea79c47 Revert "venus: firmware: Correct non-pix start and end addresses"
> > a10ca0950afe Merge tag 'driver-core-6.3-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
> > 95d0b9d89d78 Merge tag 'powerpc-6.3-4' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux
> > You have mail in /var/mail/mtodorov
> > mtodorov@domac:~/linux/kernel/linux_torvalds$
> > 
> > I don't see it here either. But it is not critical (no security issue).
> > 
> > Have a nice day!
> 
> P.S.
> 
> Correction.
> 
> Yes, I found it here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f6caea4855553a8b99ba3ec23ecdb5ed8262f26c
> 
> "Notice: this object is not reachable from any branch."
> 
> I see Murphy's law in action :-)

Ah, sorry, no, my fault, it's in my usb.git tree and hasn't been sent to
Linus yet, that will happen later this week.  It is also in the
linux-next tree if you want to look there.

thanks,

greg k-h

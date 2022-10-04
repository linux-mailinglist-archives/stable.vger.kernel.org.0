Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EF75F43D8
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 15:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiJDNBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 09:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiJDNAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 09:00:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A81132EC9
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 05:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C3661359
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 12:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6609C433C1;
        Tue,  4 Oct 2022 12:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664888261;
        bh=XRLrVe5FJar3hOcKdcXWyUQ7ioExsUqdkDWT0AfgXNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L4OFRMF1m494hA11aDNKzQ5N3AIv1bvpyxFL244PWvWubrISXZKvurzFTTRyWgoGB
         G9vg6HoyBL/Fm8E3+GHQ7xgFkoh/FQ283kG608TG2cqraJFPz+M/2neVAZ59V4fPs8
         MwHMvmJE+lDEbMBU5rCWh913MSzPXTCJ8eRYnRM4=
Date:   Tue, 4 Oct 2022 14:57:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Slade Watkins <srw@sladewatkins.net>,
        Jerry Ling <jiling@cern.ch>, intel-gfx@lists.freedesktop.org,
        David Matthew Mattli <dmm@mattli.us>
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
Message-ID: <YzwtwjZVSJm/S9p0@kroah.com>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
 <YzZynE2FAMNQKm2E@kroah.com>
 <YzaFq7fzw5TbrJyv@kroah.com>
 <03147889-B21C-449B-B110-7E504C8B0EF4@sladewatkins.net>
 <aa8b9724-50c6-ae2e-062d-3791144ac97e@cern.ch>
 <e3e2915d-1411-a758-3991-48d6c2688a1e@leemhuis.info>
 <YzsfrkJcwqKOO+E/@intel.com>
 <YzsgeXOK6JeVQGHF@intel.com>
 <714903fa-16c8-4247-d69d-74af6ef50bfa@leemhuis.info>
 <YzwooNdMECzuI5+h@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YzwooNdMECzuI5+h@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 04, 2022 at 03:35:44PM +0300, Ville Syrjälä wrote:
> On Mon, Oct 03, 2022 at 08:28:50PM +0200, Thorsten Leemhuis wrote:
> > 
> > 
> > On 03.10.22 19:48, Ville Syrjälä wrote:
> > > On Mon, Oct 03, 2022 at 08:45:18PM +0300, Ville Syrjälä wrote:
> > >> On Sat, Oct 01, 2022 at 12:07:39PM +0200, Thorsten Leemhuis wrote:
> > >>> On 30.09.22 14:26, Jerry Ling wrote:
> > >>>>
> > >>>> looks like someone has done it:
> > >>>> https://bbs.archlinux.org/viewtopic.php?pid=2059823#p2059823
> > >>>>
> > >>>> and the bisect points to:
> > >>>>
> > >>>> |# first bad commit: [fc6aff984b1c63d6b9e54f5eff9cc5ac5840bc8c]
> > >>>> drm/i915/bios: Split VBT data into per-panel vs. global parts Best, Jerry |
> > >>>
> > >>> FWIW, that's 3cf050762534 in mainline. Adding Ville, its author to the
> > >>> list of recipients.
> > >>
> > >> I definitely had no plans to backport any of that stuff,
> > >> but I guess the automagics did it anyway.
> > >>
> > >> Looks like stable is at least missing this pile of stuff:
> > >> 50759c13735d drm/i915/pps: Keep VDD enabled during eDP probe
> > >> 67090801489d drm/i915/pps: Reinit PPS delays after VBT has been fully parsed
> > >> 8e75e8f573e1 drm/i915/pps: Split PPS init+sanitize in two
> > >> 586294c3c186 drm/i915/pps: Stash away original BIOS programmed PPS delays
> > >> 89fcdf430599 drm/i915/pps: Don't apply quirks/etc. to the VBT PPS delays if they haven't been initialized
> > >> 60b02a09598f drm/i915/pps: Introduce pps_delays_valid()
> > >>
> > >> But dunno if even that is enough.
> > 
> > If you need testers: David (now CCed) apparently has a affected machine
> > and offered to test patches in a different subthread of this thread.
> > 
> > >> This bug report is probably the same thing:
> > >> https://gitlab.freedesktop.org/drm/intel/-/issues/7013
> > 
> > Sounds like it.
> > 
> >  > Also cc intel-gfx...
> > 
> > Ahh, sorry, should have done that when I CCed you.
> 
> After looking at some logs we do end up with potentially bogus
> panel power sequencing delays, which may harm the LCD panel.
> 
> 
> Greg, I recommend immediate revert of this stuff, and new stable
> release ASAP. Plus a recommendation that no one using laptops
> with Intel GPUs run 5.19.12.

Ok, will do, I'll go do that right now, thanks and sorry for the
problems.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D576A2017
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 17:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjBXQzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 11:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjBXQzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 11:55:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C4A5EED5;
        Fri, 24 Feb 2023 08:55:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F043361947;
        Fri, 24 Feb 2023 16:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D758C4339B;
        Fri, 24 Feb 2023 16:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677257745;
        bh=WkAsswgR4+hQzfKBDFB+xhU49P2+yeEhH/3Zu2LBbuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ccq6bD1bO3PnEyrOl8qScPAxPBtyoI6VJ2DipjQKQVqOVvREVpfkOCd8I/7C0Cz0S
         p4Zo0JbTP8VrOHZwGTtPuKCcZrHGvKMpddppxMj4GyT3hPtnXMQ3J5Eux0VKbf8Us/
         OraJ8mb5s9GTJUJPU0GH09a/GpgQiHHT4IWdsSDo=
Date:   Fri, 24 Feb 2023 17:55:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Message-ID: <Y/jsDRlxwsORAf1K@kroah.com>
References: <20230223141542.672463796@linuxfoundation.org>
 <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com>
 <cfd03ee0-b47a-644d-4364-79601025f35f@roeck-us.net>
 <CAHk-=whCG1zudvDsqdFo89pHARvDv4=r6vaZ8GWc_Q9amxBM6Q@mail.gmail.com>
 <Y/fC3d3RqoeawG0Y@dev-arch.thelio-3990X>
 <CAHk-=whkNnShBugM01Kzcypkp+f-uHeBWuAgtUiMpiSZuW+QDQ@mail.gmail.com>
 <Y/fZbQEEPBNZQ2w7@kroah.com>
 <CAHk-=whiuJH_DYQZw1hPtibDQZcNy8QYf1cZJCsezuPobSXCKw@mail.gmail.com>
 <Y/iQoRDIRYRNu/34@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/iQoRDIRYRNu/34@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 24, 2023 at 11:25:37AM +0100, Greg Kroah-Hartman wrote:
> On Thu, Feb 23, 2023 at 01:39:42PM -0800, Linus Torvalds wrote:
> > On Thu, Feb 23, 2023 at 1:24 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > Quilt should be depending on patch here, I think it's something in my
> > > set of "turn this series of patches into a mbox, split the mbox up into
> > > patches" sequence that is causing the problem.
> > 
> > Well, it might also be that quilt just re-generates the patch with
> > 'diff', and then in the process loses the information again.
> > 
> > We can happily continue to support the "we lost the executable bit",
> > since it sounds like Nathan is willing to cook up a patch.
> > 
> > I'm just too lazy and personally unaffected to care (and too busy with
> > merges - excuses, excuses).
> 
> Ok, I figured it out.  git is doing the right thing, my scripts are
> doing the right thing, patch is doing the right thing, but quilt is
> not looking at the permissions on the file at all when refreshing a
> patch that has been applied to a tree.
> 
> This might be a configuration setting on my end for quilt, or a bug in
> quilt, I'll try to track this down, but in the meantime, I've fixed up
> the stable queue of patches and pushed out a -rc3 with this hopefully
> all fixed up.

Ok, it's not quilt's fault, it's GNU diff's fault from what I can tell.
quilt relies on diff to generate the patch, and I can't figure out how
to get diff to notice file permissions at all.  Am I just missing
an option to 'diff' somewhere that I can't find in the manual?  What
tool originally generated diffs with the file permission settings that
patch can read if it wasn't 'diff'?

Anyway, quilt can handle replacing what it uses for 'diff', so I'll just
replace it with 'git diff' and that seems to solve the problem for me!

thanks,

greg k-h

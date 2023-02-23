Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48986A11DF
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 22:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBWVYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 16:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjBWVYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 16:24:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B0830E4;
        Thu, 23 Feb 2023 13:24:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69879B81B2D;
        Thu, 23 Feb 2023 21:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8D6C433D2;
        Thu, 23 Feb 2023 21:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677187440;
        bh=yRw1icoUbrG/fdcDSvr0XqBLTk5tcnOlHanN9Sc3uvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cx6tcCD2umxhYo0UY7sEDkRIGN15O6NdoK6VDMlI5aWApKyFk/BSQGT0tehVf8O1x
         co3/ScbVx8fr3WY2yi0tUhd5GkFkkoHxXpoUzWg6D3LxqgjA5T+/qBt3sXt6WTszd+
         SGeoY7WdDp2AWPAFE8xK2HXnyd+fmNebXlkq+JzI=
Date:   Thu, 23 Feb 2023 22:23:57 +0100
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
Message-ID: <Y/fZbQEEPBNZQ2w7@kroah.com>
References: <20230223141542.672463796@linuxfoundation.org>
 <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com>
 <cfd03ee0-b47a-644d-4364-79601025f35f@roeck-us.net>
 <CAHk-=whCG1zudvDsqdFo89pHARvDv4=r6vaZ8GWc_Q9amxBM6Q@mail.gmail.com>
 <Y/fC3d3RqoeawG0Y@dev-arch.thelio-3990X>
 <CAHk-=whkNnShBugM01Kzcypkp+f-uHeBWuAgtUiMpiSZuW+QDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whkNnShBugM01Kzcypkp+f-uHeBWuAgtUiMpiSZuW+QDQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 01:18:31PM -0800, Linus Torvalds wrote:
> On Thu, Feb 23, 2023 at 11:47 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > I can send a patch unless you want to take those changes directly, you
> > have half a commit message there already I think :)
> 
> Not being one of those old fogeys myself, I don't feel hugely motivated to care.
> 
> In fact, I think GNU patch implemented the git patch format extensions
> more than a decade ago, so we might even simply decide that it's past
> time to even worry about this at all.
> 
> In fact, with all the base infrastructure supporting git patches, I'm
> not quite sure just _how_ quilt is able to apply patches without
> dealing with mode bits.
> 
> Does quilt parse the patches and actively remove those lines before
> applying them? Or does quilt have some actual built-in patch
> application code that doesn't depend on GNU patch?
> 
> (Side note: GNU patch may support git patches, but I don't think GNU
> diffutils will generate them, so I guess not all base infrastructure
> supports that fancy new "mode" line)

Quilt should be depending on patch here, I think it's something in my
set of "turn this series of patches into a mbox, split the mbox up into
patches" sequence that is causing the problem.  I'll look into it in the
morning, but for now, I'm blaming my horrid scripts, not git or quilt
just yet...

thanks,

greg k-h

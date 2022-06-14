Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D685054B3FD
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 16:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343942AbiFNO4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 10:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344015AbiFNO4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 10:56:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276233DDCC;
        Tue, 14 Jun 2022 07:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1308B818E5;
        Tue, 14 Jun 2022 14:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC67AC3411B;
        Tue, 14 Jun 2022 14:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655218592;
        bh=TRpy2LPBk6Ws5BcIlnifdZmMbbfi6y75yfHCg/p5oXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YhP6L28kWAWq1wka+gGHgznGlETe5QGP2Hk8N/Rk3sv+2yiun6b2FT86xT1lV3uKk
         b+oxIW26Fe4SooXXF6UHqMSCi56tY+dJMPJZZAY/VYwpTPWJK0zMjtDSOw1n46rEH5
         D5RIMVmJgkfRJ5a0yW0sD0HO9UWte/PkmD+JzrTg=
Date:   Tue, 14 Jun 2022 16:56:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
Message-ID: <YqihnavPcyzMMw8l@kroah.com>
References: <20220613181233.078148768@linuxfoundation.org>
 <CAK8fFZ68+xZ2Z0vDWnihF8PeJKEmEwCyyF-8W9PCZJTd8zfp-A@mail.gmail.com>
 <YqgsDXdY3OttH8Mc@kroah.com>
 <CAK8fFZ5SP4zAra2X8B3Q9zkhQGMfif+y-oEvkpR4fDpL8_upKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK8fFZ5SP4zAra2X8B3Q9zkhQGMfif+y-oEvkpR4fDpL8_upKg@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 04:41:31PM +0200, Jaroslav Pulchart wrote:
> út 14. 6. 2022 v 8:34 odesílatel Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> napsal:
> >
> > On Tue, Jun 14, 2022 at 07:56:36AM +0200, Jaroslav Pulchart wrote:
> > > Hello,
> > >
> > > I would like to report that the ethernet ice driver is not capable of
> > > setting promisc mode on at E810-XXV physical interface in the whole
> > > 5.18.y kernel line.
> > >
> > > Reproducer:
> > >    $ ip link set promisc on dev em1
> > > Dmesg error message:
> > >    Error setting promisc mode on VSI 6 (rc=-17)
> > >
> > > the problem was not observed with 5.17.y
> >
> > Any chance you can use 'git bisect' to track down the problem commit and
> > let the developers of it know?
> >
> > thanks,
> 
> I tried it, but it makes the system unbootable. I expect the reason is
> that it happened somewhere between 5.17->5.18 so I'm using an
> "unstable" kernel.
> 
> Is there some way I could bisect just one driver, not a full kernel
> between 5.17->5.18?

How do you know it is just "one driver"?

Anyway, yes, I think there are options to give to git bisect, you can
feed it just the path to the driver as part of 'git bisect start' and I
think that should work.  The man page for 'git bisect' shows this with
the following example:
	 git bisect start -- arch/i386 include/asm-i386
to just test changes for those directories.

thanks,

greg k-h

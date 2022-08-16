Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD27595E79
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 16:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbiHPOny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 10:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiHPOny (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 10:43:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F7B2B609;
        Tue, 16 Aug 2022 07:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B596109A;
        Tue, 16 Aug 2022 14:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C24C433C1;
        Tue, 16 Aug 2022 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660661030;
        bh=wo3uzjLEQ9FF0AJoVCvMsccN9VjqdoMOt42ULZ3bE0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B4M99VheJXHMBYhn3leorYxe4BYAU1ZkwFvmPIHtkZxtQcXcbLkpKOO4IFoYyKjBk
         txTY6evNoBKpmQSO6Hle6bzbHZaw2YcxhQFkFaj2VCGEQHVljrSrrBWRcmc9R7gfgj
         5Up4pZD4axyEWHmXSAd/OOcaxHsOLrRbdBmURseM=
Date:   Tue, 16 Aug 2022 16:43:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0000/1094] 5.18.18-rc2 review
Message-ID: <YvutIhMRZW/nKOPi@kroah.com>
References: <20220816124604.978842485@linuxfoundation.org>
 <CADVatmPOCPfHQHEuwVmOb5oeN2HfWWMztVok3qvoq7Ndndb14A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmPOCPfHQHEuwVmOb5oeN2HfWWMztVok3qvoq7Ndndb14A@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 03:34:56PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, Aug 16, 2022 at 1:59 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.18.18 release.
> > There are 1094 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 18 Aug 2022 12:43:14 +0000.
> > Anything received after that time might be too late.
> 
> The hung task problem I reported for v5.18.18-rc1 is not seen with rc2.

Nice!

> The drm warning is still there and a bisect pointed it to:
> 4b8701565b59 ("drm/vc4: hdmi: Move HDMI reset to
> pm_resume")4b8701565b59 ("drm/vc4: hdmi: Move HDMI reset to
> pm_resume")

What drm warning?

> I have not noticed earlier, the warning is there with mainline also. I
> will verify tonight and send another mail for mainline.

Ah, ok, being bug compatible is good :)

> Also, mips and csky allmodconfig build fails with gcc-12 due to
> 85d03e83bbfc ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
> regression").
> Mainline also has the same build failure reported at
> https://lore.kernel.org/lkml/YvY4xdZEWAPosFdJ@debian/

Looks like they have a fix somewhere for that, any hints on where to
find it?

thanks,

greg k-h

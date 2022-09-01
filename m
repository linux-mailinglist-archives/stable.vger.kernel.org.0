Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E7D5A937A
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 11:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiIAJqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 05:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbiIAJqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 05:46:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E629D8E2A;
        Thu,  1 Sep 2022 02:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8A3961A41;
        Thu,  1 Sep 2022 09:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B30C433C1;
        Thu,  1 Sep 2022 09:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662025575;
        bh=X+Rpcegr4gCD1s7VnqgB04RiJpDceCNnsx9AdRYB5yQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1gGrXkjt/mD69eGP47R46W3s6Byph7asoJRnSNFPU5YJRmAvtZYToEV3ZDVDde2qd
         H7E4p2RAeKpICsTOx77actjn3p+636UpXuatH0wCdPbvyADRghWaNFBc+vI8PKpNWh
         LFM+1bGaIygRx0xsHPKjL9v4DQ8kBkCobphdl9kU=
Date:   Thu, 1 Sep 2022 11:46:12 +0200
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
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
Message-ID: <YxB/ZPFEQG9zS+wa@kroah.com>
References: <20220829105804.609007228@linuxfoundation.org>
 <CADVatmOLoaGgAW951JqEk3v88EA7mn3qur84Xd30QJWP21+eVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmOLoaGgAW951JqEk3v88EA7mn3qur84Xd30QJWP21+eVg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 09:11:28PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Aug 29, 2022 at 12:00 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.64 release.
> > There are 136 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> > Anything received after that time might be too late.
> 
> My builds are still running, but just an initial report for gcc-12. (I
> know v5.15.y still does not build completely with gcc-12).
> 
> x86_64 and arm64 allmodconfig build fails with gcc-12, with the error:
> 
> drivers/acpi/thermal.c: In function 'acpi_thermal_resume':
> drivers/acpi/thermal.c:1101:21: error: the comparison will always
> evaluate as 'true' for the address of 'active' will never be NULL
> [-Werror=address]
>  1101 |                 if (!(&tz->trips.active[i]))
>       |                     ^
> drivers/acpi/thermal.c:151:36: note: 'active' declared here
>   151 |         struct acpi_thermal_active active[ACPI_THERMAL_MAX_ACTIVE];
> 
> Will need e5b5d25444e9 ("ACPI: thermal: drop an always true check").

Now applied.

> powerpc allmodconfig fails with gcc-12, the error is:
> 
> In function 'memcmp',
>     inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:278:9,
>     inlined from 'l2cap_global_chan_by_psm' at
> net/bluetooth/l2cap_core.c:2003:15:
> ./include/linux/fortify-string.h:19:33: error: '__builtin_memcmp'
> specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>    19 | #define __underlying_memcmp     __builtin_memcmp
>       |                                 ^
> ./include/linux/fortify-string.h:235:16: note: in expansion of macro
> '__underlying_memcmp'
>   235 |         return __underlying_memcmp(p, q, size);
>       |                ^~~~~~~~~~~~~~~~~~~
> In function 'memcmp',
>     inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:278:9,
>     inlined from 'l2cap_global_chan_by_psm' at
> net/bluetooth/l2cap_core.c:2004:15:
> ./include/linux/fortify-string.h:19:33: error: '__builtin_memcmp'
> specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
>    19 | #define __underlying_memcmp     __builtin_memcmp
>       |                                 ^
> ./include/linux/fortify-string.h:235:16: note: in expansion of macro
> '__underlying_memcmp'
>   235 |         return __underlying_memcmp(p, q, size);
>       |                ^~~~~~~~~~~~~~~~~~~
> 
> Introduced in v5.15.61 due to 2711bedab26c ("Bluetooth: L2CAP: Fix
> l2cap_global_chan_by_psm regression").
> But v5.19.y and mainline does not show the build failure as they also
> have 41b7a347bf14 ("powerpc: Book3S 64-bit outline-only KASAN
> support").

Ick, ok, what to do here?  I can't really backport 41b7a347bf14 to 5.15
easily as it's huge and a new feature.  Any other ideas?

thanks,

greg k-h

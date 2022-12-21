Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08E06533D0
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 17:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiLUQMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 11:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbiLUQMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 11:12:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCBA205E8;
        Wed, 21 Dec 2022 08:12:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAB73B81B97;
        Wed, 21 Dec 2022 16:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61CDC433EF;
        Wed, 21 Dec 2022 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671639126;
        bh=hMWOzJQfGrw2VL5wnUwgg7mMwK3iZwR3rvS7osSgTt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iprb43Ps2hq4dF7WNEy32ZrQBxFf4DPgGbQiRk2liWNRucM2WQ8AxSEMjs4EsINTP
         8EZyveHceJ7MeIWBzWW0tGAivl6bt2iqcXB/iWKaTHFd37vL8/Ghfw7yvmpXIOrMCc
         z31B5tiz66mfKYdRZBazgafXZbugQEJY9Q5Wc778=
Date:   Wed, 21 Dec 2022 17:12:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <Y6MwU0kvczAkzT6C@kroah.com>
References: <20221219182943.395169070@linuxfoundation.org>
 <20221220150049.GE3748047@roeck-us.net>
 <Y6HQfwEnw75iajYr@kroah.com>
 <20221220161135.GA1983195@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220161135.GA1983195@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 08:11:35AM -0800, Guenter Roeck wrote:
> On Tue, Dec 20, 2022 at 04:10:55PM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Dec 20, 2022 at 07:00:49AM -0800, Guenter Roeck wrote:
> > > On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.1.1 release.
> > > > There are 25 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > Build results:
> > > 	total: 155 pass: 155 fail: 0
> > > Qemu test results:
> > > 	total: 500 pass: 498 fail: 2
> > > Failed tests:
> > > 	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:net,default:zynq-zc702:rootfs
> > > 	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:zynq-zed:rootfs
> > > 
> > > The failure bisects to commit e013ba1e4e12 ("usb: ulpi: defer ulpi_register on
> > > ulpi_read_id timeout") and is inherited from mainline. Reverting the offending
> > > patch fixes the problem.
> > 
> > Odd, yet that same commit works just fine on 6.0 and 5.15 and 5.10?  I
> > hadn't had any reports of this being an issue on Linus's tree either,
> > did I miss those?
> > 
> 
> I testbed has a bad hair day. The reports for the other branches are wrong.
> I restarted the tests and expect them to fail there as well. Sorry for that.

No worries, I've deleted this patch from all branches now, thanks.

greg k-h

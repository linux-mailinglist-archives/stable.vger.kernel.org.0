Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA3695918
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 07:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjBNGUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 01:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBNGUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 01:20:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE491C336;
        Mon, 13 Feb 2023 22:20:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4595060E8C;
        Tue, 14 Feb 2023 06:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4B4C433EF;
        Tue, 14 Feb 2023 06:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676355649;
        bh=S4jqq7VhGw4LBwFTGJheW0/oEWFrtHDP7F1uVtcRTCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vxqBoAD0pj0noMeUTYqItKeZokj715a7MWXTZMK2uOqcODzKTUfUxX0sEFzLGDkAv
         S6+BYCZyJPDJ2YxEo+QquOc0VNVm9UWYax1hlfAPWoncwqhdmT/Yy8lWA9T2LvllZG
         uztpBj4l0c9watZg/yBXtWgN+eg2DSFhGjXYe19c=
Date:   Tue, 14 Feb 2023 07:20:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Message-ID: <Y+soPsujgwChdgr7@kroah.com>
References: <20230213144745.696901179@linuxfoundation.org>
 <cc3f4cfb-adbc-c3b7-1c21-bb28e98499d8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc3f4cfb-adbc-c3b7-1c21-bb28e98499d8@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 13, 2023 at 11:50:24AM -0800, Florian Fainelli wrote:
> On 2/13/23 06:49, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.168 release.
> > There are 139 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> There is a regression coming from:
> 
> nvmem: core: fix registration vs use race
> 
> which causes the following to happen for MTD devices:
> 
> [    6.031640] kobject_add_internal failed for mtd0 with -EEXIST, don't try
> to register things with the same name in the same directory.
> [    7.846965] spi-nor: probe of spi0.0 failed with error -17
> 
> attached is a full log with the call trace. This does not happen with
> v6.2-rc8 where the MTD partitions are successfully registered.

Can you use `git bisect` to find the offending commit?

thanks,

greg k-h

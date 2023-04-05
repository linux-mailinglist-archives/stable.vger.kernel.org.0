Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6A06D785E
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237764AbjDEJbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237727AbjDEJb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:31:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8128461A8;
        Wed,  5 Apr 2023 02:30:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 707E2622AF;
        Wed,  5 Apr 2023 09:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C42C433D2;
        Wed,  5 Apr 2023 09:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680687027;
        bh=cF6ZOA0CTBRp5JFa60UbcgjM/2p3p51Z/7tMkQoCO3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H25qKiSE+jO39WNSW4o2s1CVd8pn+kfJfVprHotKSA+GhxXRq4Y2FmnUle7BPYdtP
         RpnNPrwrfahm0pw9eL8ECc4bBl3em5Vuo5tHBU9pX86Ego27t08LhQcjA2Qy3wBTuB
         M5xn5FRHuO7lCYHQz6A/c6Ge4y5JUIl28AXyGtHk=
Date:   Wed, 5 Apr 2023 11:30:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kelsey Steele <kelseysteele@linux.microsoft.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        decui@microsoft.com, petrtesarik@huaweicloud.com,
        linux-hyperv@vger.kernel.org, iommu@lists.linux.dev,
        robin.murphy@arm.com, dexuan.linux@gmail.com,
        tyler.hicks@microsoft.com
Subject: Re: [PATCH 6.1 000/179] 6.1.23-rc2 review
Message-ID: <2023040503-perkiness-nutty-f8f4@gregkh>
References: <20230404183150.381314754@linuxfoundation.org>
 <20230405003549.GA21326@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405003549.GA21326@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 05:35:49PM -0700, Kelsey Steele wrote:
> On Tue, Apr 04, 2023 at 08:32:15PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.23 release.
> > There are 179 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 06 Apr 2023 18:31:13 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Hi Greg, 
> 
> 6.1.23-rc2 is failing to boot on x86 WSL. A bisect leads to commit
> c2f05366b687 ("swiotlb: fix slot alignment checks") being the problem
> and reverting this patch puts everything back in a working state.
> 
> There's a report from Dexuan who also encountered this error on a Linux
> VM on Hyper-V:
> 
> https://lore.kernel.org/all/CAA42JLa1y9jJ7BgQvXeUYQh-K2mDNHd2BYZ4iZUz33r5zY7oAQ@mail.gmail.com/
> 
> Adding a chunk of my log below which shows errors occuring from the hv_strvsc driver.

Is this also a problem on 6.2-rc1, and Linus's tree?

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDC45AFBF0
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 07:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiIGFth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 01:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIGFtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 01:49:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7724215730;
        Tue,  6 Sep 2022 22:49:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C3C661589;
        Wed,  7 Sep 2022 05:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD13C433C1;
        Wed,  7 Sep 2022 05:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662529773;
        bh=RWRKXwOTcTy8VPewA7SDv2a/Y8GViYdktXr3TqkZAYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YwAFdiM1Lckx7XzOXhvBcEjvcTClR6OXnXceNXEQ57Fnch0XBkWdjXoq9OCLjkKWt
         9Tri4g2uWQ081iKJ2Gwa7e4PjapOYR4tktTXEiA+Iiw8PR1KQjjktVdb4y7XX9Cvsk
         aP6OC8ZpP0KS/F51dL8X2uVrkOxB5LT/+gsqGvNE=
Date:   Wed, 7 Sep 2022 07:49:29 +0200
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
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
Message-ID: <Yxgw6SrPaF43s/pw@kroah.com>
References: <20220906132821.713989422@linuxfoundation.org>
 <CADVatmMTbnOm1bHWdbxVZ26QfbjyhhB+_ZRBMM53GicJczE5=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmMTbnOm1bHWdbxVZ26QfbjyhhB+_ZRBMM53GicJczE5=Q@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 09:46:37PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, Sep 6, 2022 at 2:37 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.66 release.
> > There are 107 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> > Anything received after that time might be too late.
> 
> My test pipelines are still running, but x86_64 allmodconfig failed
> with gcc-12 with the error:
> 
> drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c: In function
> 'ipc_protocol_dl_td_process':
> drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:406:13: error: the
> comparison will always evaluate as 'true' for the address of 'cb' will
> never be NULL [-Werror=address]
>   406 |         if (!IPC_CB(skb)) {
>       |             ^
> In file included from drivers/net/wwan/iosm/iosm_ipc_imem.h:9,
>                  from drivers/net/wwan/iosm/iosm_ipc_protocol.h:9,
>                  from drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:6:
> ./include/linux/skbuff.h:794:33: note: 'cb' declared here
>   794 |         char                    cb[48] __aligned(8);
> 
> It will need dbbc7d04c549 ("net: wwan: iosm: remove pointless null check").

Thanks, I have not been testing any branches with gcc12 just yet because
of these issues :(

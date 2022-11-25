Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A7463847E
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 08:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiKYHfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 02:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYHff (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 02:35:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C958F264BF;
        Thu, 24 Nov 2022 23:35:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D099B82962;
        Fri, 25 Nov 2022 07:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CA4C433C1;
        Fri, 25 Nov 2022 07:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669361731;
        bh=R7jrnvlhAIaa2Rt9W0pB40Y3hHbvvTnOSc25lysB9Mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g3EjvAi+99f3AgmQhCefRRhzRcqyt8IrnmZH8nH1Od+fCuD0goSBUluPcCYvkXplg
         GgIlVsfCaFR3N5UZyyoOfj1YTmuZAF7jKiJLf3q6QzQp7jcDcGON8J6qnlCAdLKp0Z
         sTNW9nG8VzwcV/cIIj9DwfPxiCHuRVUhg14VEBQA=
Date:   Fri, 25 Nov 2022 08:35:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <Y4BwPwOkjrwMC7+Y@kroah.com>
References: <20221123084625.457073469@linuxfoundation.org>
 <20221123170322.GB3745358@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123170322.GB3745358@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 09:03:22AM -0800, Guenter Roeck wrote:
> On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.0.10 release.
> > There are 314 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build reference: v6.0.9-315-gdcf677c
> Compiler version: arm-linux-gnueabi-gcc (GCC) 11.3.0
> Assembler version: GNU assembler (GNU Binutils) 2.39
> 
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> drivers/rtc/rtc-cmos.c:1347:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
>  1347 | static void rtc_wake_setup(struct device *dev)

Now fixed, this commit should not have been added, as it wasn't obvious
that it was fixing an issue only in 6.1-rc, not the stable trees.

Dropped from everywhere.

greg k-h

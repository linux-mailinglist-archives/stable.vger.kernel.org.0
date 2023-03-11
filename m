Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB2D6B5BB4
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 13:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjCKMbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 07:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjCKMbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 07:31:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445C812DC02;
        Sat, 11 Mar 2023 04:31:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA73760B9E;
        Sat, 11 Mar 2023 12:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99470C433EF;
        Sat, 11 Mar 2023 12:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678537862;
        bh=w9TCBSJxLRN61cNOcGXqJ4rfKYTm28LpgtgDLQfcBLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z/szS/ruxcHd39YFgGdd7sb/CLgOTSN96FrdWEbJnRa/R9reqCkFcwrOq7MzQ+O2w
         3IDELZUcHkiPeBqGzYIGG5Rgd4X6sb/mS0dsLFc3HCG4QxhbwshIaLUb5gOBgTkfPj
         6ma4+H0V/hF4/M7YjP8VLzR6ZktBsLTspldnNK/c=
Date:   Sat, 11 Mar 2023 13:30:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
Message-ID: <ZAx0gyVQhOukSHbB@kroah.com>
References: <20230310133804.978589368@linuxfoundation.org>
 <ZAxzrMh1zu6WOKyR@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAxzrMh1zu6WOKyR@debian>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 12:27:24PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Fri, Mar 10, 2023 at 02:32:23PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.173 release.
> > There are 529 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> > Anything received after that time might be too late.
> 
> Build test (gcc version 11.3.1 20230210):
> mips: 63 configs -> no failure
> arm: 104 configs -> no failure
> arm64: 3 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> failure
> xtensa allmodconfig -> no failure
> 
> Note:
> s390 build failed with the error:
> drivers/s390/block/dasd_diag.c:656:23: error: initialization of 'int (*)(struct dasd_device *, __u8)' {aka 'int (*)(struct dasd_device *, unsigned char)'} from incompatible pointer type 'int (*)(struct dasd_device *, __u8,  __u8)' {aka 'int (*)(struct dasd_device *, unsigned char,  unsigned char)'} [-Werror=incompatible-pointer-types]
>   656 |         .pe_handler = dasd_diag_pe_handler,
>       |                       ^~~~~~~~~~~~~~~~~~~~
> drivers/s390/block/dasd_diag.c:656:23: note: (near initialization for 'dasd_diag_discipline.pe_handler')

Should be fixed in -rc2.

thanks,

greg k-h

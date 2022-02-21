Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BCC4BEA83
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 20:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiBUSMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 13:12:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiBUSKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 13:10:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E8425C71;
        Mon, 21 Feb 2022 10:00:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ED1AB816FC;
        Mon, 21 Feb 2022 18:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCEBC340E9;
        Mon, 21 Feb 2022 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645466403;
        bh=RuobRZ3E8jrPNKhyG/2lgwwr/3tmYkSCyeq+C5N5NoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w6oNiPh4+XjmZaI+eTNi9LoDFvkC/JZVszV/Kn3Fz/5NDDxBy9YJtUMNOiMbpr5IU
         YOBxA3BFSE6tO8UpMZ9Rz/fPBPYsSBDupRU78Bs+JDGqk2PAKYP+To+0iWSnqKaCit
         VPoj9iBoW41aTfJF7hCUt2EFzKNrpZr/K0O9NusI=
Date:   Mon, 21 Feb 2022 19:00:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>,
        Jens Wiklander <jens.wiklander@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
Message-ID: <YhPTIFmCxjnELRyP@kroah.com>
References: <20220221084930.872957717@linuxfoundation.org>
 <d72c8af1-e93d-44ae-15e0-737302523961@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d72c8af1-e93d-44ae-15e0-737302523961@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 09:15:52AM -0800, Guenter Roeck wrote:
> On 2/21/22 00:47, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.25 release.
> > There are 196 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> > Anything received after that time might be too late.
> > 
> 
> 
> Building arm:allmodconfig ... failed
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> drivers/tee/optee/core.c: In function 'optee_probe':
> drivers/tee/optee/core.c:726:20: error: operation on 'rc' may be undefined


Jens, did you build the 5.15 patch you sent?

This line looks a bit odd:

+               rc = rc = PTR_ERR(ctx);

And given that rc is an int, that is not guaranteed to hold a pointer
here :(

thanks,

greg k-h

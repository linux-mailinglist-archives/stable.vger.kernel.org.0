Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751234F7CA5
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 12:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237450AbiDGKZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 06:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbiDGKZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 06:25:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F50436158;
        Thu,  7 Apr 2022 03:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 257DFB82717;
        Thu,  7 Apr 2022 10:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3C2C385A0;
        Thu,  7 Apr 2022 10:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649327024;
        bh=Det7vFTZ9fHfuPZDd9VIUsmbC+m9DmLSFb2XzDdd7YM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pyLkCB2OUOEU4p0hVKahWW2nD1ZW0HM/e9Nvq8XgSovtOQw9eypWrbrEH2vucmQO8
         4iAAs+nEvIQqDB8sO6gv0vmt3EV820mtyB0TGF35aXEH7o8Ddhj+El6cDXEG1EuEGg
         zEuerHAkY1B08fUcgiqTaufi/FS38CLyY6JvcRIY=
Date:   Thu, 7 Apr 2022 12:23:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     James Morse <james.morse@arm.com>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/43] 4.9.310-rc1 review
Message-ID: <Yk67rfu4XQSl5j6c@kroah.com>
References: <20220406182436.675069715@linuxfoundation.org>
 <20220407093238.GA3041848@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407093238.GA3041848@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 02:32:38AM -0700, Guenter Roeck wrote:
> On Wed, Apr 06, 2022 at 08:26:09PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.310 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 08 Apr 2022 18:24:27 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 163 pass: 161 fail: 2
> Failed builds:
> 	arm64:allnoconfig
> 	arm64:tinyconfig
> Qemu test results:
> 	total: 397 pass: 397 fail: 0
> 
> arch/arm64/kernel/cpu_errata.c: In function 'is_spectrev2_safe':
> arch/arm64/kernel/cpu_errata.c:829:39: error: 'arm64_bp_harden_smccc_cpus' undeclared 
> 
> arch/arm64/kernel/cpu_errata.c: In function 'spectre_bhb_enable_mitigation':
> arch/arm64/kernel/cpu_errata.c:839:39: error: '__hardenbp_enab' undeclared
> 
> arch/arm64/kernel/cpu_errata.c:879:42: error: 'bp_hardening_data' undeclared

Ick, odds are James did not build with those two configs :(

James, any chance you can look into this and see what needs to be added
or changed with your patch series?

thanks,

greg k-h

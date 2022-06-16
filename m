Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D6854E187
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbiFPNLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiFPNLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:11:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7287F26113;
        Thu, 16 Jun 2022 06:11:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07A2761BD4;
        Thu, 16 Jun 2022 13:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE6DC34114;
        Thu, 16 Jun 2022 13:11:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="YO/lfzaG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655385101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NBxq3wX4V8CBHa+ItaJq1tCv4j6jgALcJ8eLTTWkvB8=;
        b=YO/lfzaGzbUdUIEQ73AJA+Nayx3Ea9wGmFkiNhvkalyqsdpjeHioGVAmfdA8+KxPlG95t9
        CtPpePO3QylqR2r/viosVl2VJfqR3d7LW+9p8NQ2YFoP2AHI9lA1so2f6c3yiHWFYj2zuz
        PcF9Q64xMMx0e4tBZunIB+1oysVH4BQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 58d9ae71 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 16 Jun 2022 13:11:40 +0000 (UTC)
Date:   Thu, 16 Jun 2022 15:11:34 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
Message-ID: <YqssBl7QRyp0nytW@zx2c4.com>
References: <20220614183719.878453780@linuxfoundation.org>
 <9e43b35e-31da-7e51-006c-1aa69acb10d4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e43b35e-31da-7e51-006c-1aa69acb10d4@nvidia.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jon,

On Thu, Jun 16, 2022 at 09:48:37AM +0100, Jon Hunter wrote:
> No new regressions for Tegra. I am seeing the following kernel warning 
> that is causing a boot test to fail, but this has been happening for a 
> few releases now (I would have reported it earlier but we have been 
> having some infrastructure issues) ...
> 
>   WARNING KERN urandom_read_iter: 82 callbacks suppressed
> 
> This appears to be introduced by commit "random: convert to using 
> fops->read_iter()" [0]. Interestingly, I am not seeing this in the 
> mainline as far as I can tell and so I am not sure if there is something 
> else that is missing?
> 
> 
> Test results for stable-v5.10:
>      10 builds:	10 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      75 tests:	74 pass, 1 fail
> 
> Linux version:	5.10.123-rc1-gf67ea0f67087
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> 
> Jon
> 
> [0] 
> https://lore.kernel.org/lkml/20220527084907.568432116@linuxfoundation.org/

Please CC me on RNG issues.

I'm surprised that this message results in a failure. It's not a
WARN_ON() or a BUG() that's being triggered here. This is just the
simple `pr_warn("%s: %d callbacks suppressed\n")` in lib/ratelimit.c,
which really shouldn't be causing your CI to fail. Sounds like your
harness could use some adjusting.

Nonetheless, you have found a 4 year old bug in the urandom warning
accounting that was recently made more easily triggerable by a newer
commit, though not the one you mentioned. I'll fix this up and keep you
CC'd on the patch, which should make it into stable as well.

Jason

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD6A54D8E3
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 05:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350856AbiFPD1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 23:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350554AbiFPD1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 23:27:23 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E424B381B3;
        Wed, 15 Jun 2022 20:27:22 -0700 (PDT)
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 910C020C3274;
        Wed, 15 Jun 2022 20:27:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 910C020C3274
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655350042;
        bh=KmuenCdUSnCAGNScSGTmi0OCkO7JKKTVJwq6fccnzjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z3PBoCNofaNQwB075aSKsknPxrFmdnRmrH5awTaQxvLs2FJ40h5rdZwg2D16iS0ma
         gk9Pohalj/oFvyvP1JoqEwgu7izZ2rF+MSEqsiznhLmHXdrpeYah5RqOJTl809Y0mA
         nfOiLIsma5s35UCsJ2QCfu5L6R0S45Unp6DOyfqs=
Date:   Wed, 15 Jun 2022 22:26:54 -0500
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/11] 5.15.48-rc1 review
Message-ID: <20220616032654.GA396338@sequoia>
References: <20220614183720.512073672@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-06-14 20:40:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.48 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.48-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Hi Greg - I successfully tested this release candidate in x86_64 Hyper-V
Azure VMs with speculation controls both enabled and disabled.
Speculation controls are passed through to the guest and, of particular
interest for this release candidate, set the FB_CLEAR bit in the
IA32_ARCH_CAPABILITIES MSR.

The FB_CLEAR bit's presence is accurately conveyed in the kernel log
messages during boot and in the
/sys/devices/system/cpu/vulnerabilities/mmio_stale_data file.

I did a full LTP run in both scenarios (the results were the same) and
also compared the results to a previous run against the v5.15.45 release
(there were no regressions).

Tested-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Tyler

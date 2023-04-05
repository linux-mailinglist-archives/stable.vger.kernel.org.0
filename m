Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB5A6D787A
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbjDEJfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237105AbjDEJf2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:35:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E809E5BA2;
        Wed,  5 Apr 2023 02:35:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4544862497;
        Wed,  5 Apr 2023 09:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7807C433D2;
        Wed,  5 Apr 2023 09:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680687218;
        bh=pmrkInESBupA1IULFtTUzfqP+rSifNdAVvi3q309jOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tHsi1rWdTQpDeWUvfBsc2QxvStbgUaRkiD2dAWoNXpUfKl2/iVNqxLjtcDZgajnoC
         EE63zApOOSIaOQTRHtsbhArKaORJZA7izdkkRHEpc0bA6fpJBCLY2fVFG0vngbKAeK
         MWL/H2UQmSK84nvSi8+O06pYXCZjIodojF3RHyY8=
Date:   Wed, 5 Apr 2023 11:33:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
Message-ID: <2023040516-flirt-provolone-d254@gregkh>
References: <20230403140403.549815164@linuxfoundation.org>
 <20230404203312.2ofkv4jxyvgscxpk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404203312.2ofkv4jxyvgscxpk@oracle.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 02:33:12PM -0600, Tom Saeger wrote:
> On Mon, Apr 03, 2023 at 04:07:52PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.240 release.
> > There are 104 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.240-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Hey Greg,
> 
> This still reproduces:
> 
> 
> cp arch/mips/configs/lasat_defconfig .config
> make ARCH=mips olddefconfig
> make ARCH=mips
> 
> 
> .../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:42:44: error: expected ')' before '&' token
>    42 | static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);
>       |                                            ^~
>       |                                            )
> .../linux-stable-5.4/arch/mips/lasat/picvue_proc.c: In function 'pvc_line_proc_write':
> .../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:87:20: error: 'pvc_display_tasklet' undeclared (first use in this function)
>    87 |  tasklet_schedule(&pvc_display_tasklet);
>       |                    ^~~~~~~~~~~~~~~~~~~
> .../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:87:20: note: each undeclared identifier is reported only once for each function it appears in
> At top level:
> .../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:33:13: error: 'pvc_display' defined but not used [-Werror=unused-function]
>    33 | static void pvc_display(unsigned long data)
>       |             ^~~~~~~~~~~
> cc1: all warnings being treated as errors
> 
> Attached is mbox of fixed-up revert/backports.

Odd that no one else is reporting this.  Thanks for the patches, I've
queued them up for the next 5.4.y release.

greg k-h

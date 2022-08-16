Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD59595BA1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiHPMTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbiHPMSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:18:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368F313E84;
        Tue, 16 Aug 2022 05:17:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCCA3B8188B;
        Tue, 16 Aug 2022 12:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E990AC433D6;
        Tue, 16 Aug 2022 12:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660652223;
        bh=nofA9ptQDb1h/gvhqEy4REcEOPebrt4+12qzsya4d+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zuUHw4EiV3eaffoaD7us/ZQEjSBizwYfczYcy0j7P4JNgmTbsatP/ouEmweY1zP3w
         rmkdDCEGsrpKSB9glDK7/7/btEu3JYP77uy90qMra1iQTdMIvnrd9HHPY8VIapm+gN
         zoGJEi4LyKXzP/+KRgkv7UYjh6fnFSqpWfwdEfdg=
Date:   Tue, 16 Aug 2022 14:17:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/779] 5.15.61-rc1 review
Message-ID: <YvuKvBUIGUXPUUDz@kroah.com>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220816113407.GA1809610@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816113407.GA1809610@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 04:34:07AM -0700, Guenter Roeck wrote:
> On Mon, Aug 15, 2022 at 07:54:04PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.61 release.
> > There are 779 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building powerpc:ppc32_allmodconfig ... failed
> Building powerpc:ppc6xx_defconfig ... failed
> --------------
> Error log:
> arch/powerpc/sysdev/fsl_pci.c: In function 'fsl_add_bridge':
> arch/powerpc/sysdev/fsl_pci.c:601:39: error: 'PCI_CLASS_BRIDGE_PCI_NORMAL' undeclared
> 
> This affects v5.15.y and earlier branches. Several patches
> would be needded to make this work. In mainline:
> 
> 0c551abfa004 powerpc/fsl-pci: Fix Class Code of PCIe Root Port
> 113fe88eed53 powerpc: Don't include asm/setup.h in asm/machdep.h
> e6f6390ab7b9 powerpc: Add missing headers
> 904b10fb189c PCI: Add defines for normal and subtractive PCI bridges
> 
> There may be others since the patches touch several files, and it seems
> quite unlikely that they all apply to older kernels. It may be easier
> to define PCI_CLASS_BRIDGE_PCI_NORMAL locally.

Yeah, I'll just pick that portion out of 904b10fb189c ("PCI: Add defines
for normal and subtractive PCI bridges") to fix this build up (and the
build on older queues.)

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB426BC7E7
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 08:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCPH5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 03:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjCPH5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 03:57:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4B82684F;
        Thu, 16 Mar 2023 00:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CDA361F5F;
        Thu, 16 Mar 2023 07:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD40C433EF;
        Thu, 16 Mar 2023 07:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678953420;
        bh=U90ZMSPQK2MYhhnAxVsMkqjkud9BNXEmnkyodFogRV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e8L/5opVflJbJfQ7hrnF2RfLPcEH2LFifd3MtUHLerNnioEBM5B4IRzH2DKQ676sF
         GOY1J7erp0v5ZERQsWAGFVq0QaMQivEA+yo8n9X2BtzAAF6si09e0GToQcRJDEqkT4
         IhelLOPzT+8a1C9OrgnNFXRG/A9YWEnDfndLc7r0=
Date:   Thu, 16 Mar 2023 08:56:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
Message-ID: <ZBLLyoYelPSiYI0W@kroah.com>
References: <20230315115731.942692602@linuxfoundation.org>
 <4584471d-d216-3edd-058c-e362e048462f@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4584471d-d216-3edd-058c-e362e048462f@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 07:26:05AM -0700, Guenter Roeck wrote:
> On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.175 release.
> > There are 104 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Another build failure, almost drowning in the noise.
> 
> Building riscv32:allmodconfig ... failed
> --------------
> Error log:
> drivers/pci/pci-driver.c: In function 'pci_pm_runtime_resume':
> drivers/pci/pci-driver.c:1297:9: error: implicit declaration of function 'pci_restore_standard_config' [-Werror=implicit-function-declaration]
>  1297 |         pci_restore_standard_config(pci_dev);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> At top level:
> drivers/pci/pci-driver.c:536:13: warning: 'pci_pm_default_resume_early' defined but not used [-Wunused-function]
>   536 | static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Ah, nice catch, I've now fixed this up and it should be good in -rc2

greg k-h

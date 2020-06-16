Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697A01FBC8C
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 19:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgFPRPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 13:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725979AbgFPRPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 13:15:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43B4420C09;
        Tue, 16 Jun 2020 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592327731;
        bh=yVmadiXPj3YA78xJ6RPHRN4od3kbbuDc2djuT7TwZjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2eEAusNRLihUQpSK3+VMacIAdZhbJeE4mvypV2jBLyM7y9rd2dyxjZgUWxzaOa7nN
         fxkM8S9I7AAhDt53ylMPECPP821ycBOBff1n7W3VmYQ0aLCHUgxQDcQElCq/InJUPB
         FgsoLIdyn9r6Teg4WveaPxHhpXo+o2l8pTW11XBU=
Date:   Tue, 16 Jun 2020 19:15:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/134] 5.4.47-rc1 review
Message-ID: <20200616171526.GB4161772@kroah.com>
References: <20200616153100.633279950@linuxfoundation.org>
 <b9e8fbc5-9a25-723c-1ea5-09bc7f1cee89@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9e8fbc5-9a25-723c-1ea5-09bc7f1cee89@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 10:07:04AM -0700, Guenter Roeck wrote:
> On 6/16/20 8:33 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.47 release.
> > There are 134 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 18 Jun 2020 15:30:25 +0000.
> > Anything received after that time might be too late.
> > 
> 
> We should see see lots of failures along the line of
> 
> ERROR: "imx_sc_misc_set_control" [sound/soc/sof/imx/snd-sof-imx8.ko] undefined!
> ERROR: "imx_scu_get_handle" [sound/soc/sof/imx/snd-sof-imx8.ko] undefined!
> ERROR: "imx_sc_pm_cpu_start" [sound/soc/sof/imx/snd-sof-imx8.ko] undefined!
> 
> for several architectures. This will affect 5.4.y, 5.6.y, and 5.7.y.
> 
> I say "should" because my builders didn't catch up yet, but a quick sanity
> check suggests that the problem is still there. alpha:allmodconfig, for
> example, reports dependency issues.
> 
> WARNING: unmet direct dependencies detected for SND_SOC_SOF_IMX8
>   Depends on [n]: SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_SOC_SOF_TOPLEVEL [=y] && SND_SOC_SOF_IMX_TOPLEVEL [=y] && IMX_SCU
>   Selected by [m]:
>   - SND_SOC_SOF_IMX_OF [=m] && SOUND [=m] && !UML && SND [=m] && SND_SOC [=m] && SND_SOC_SOF_TOPLEVEL [=y] && SND_SOC_SOF_IMX_TOPLEVEL [=y] && SND_SOC_SOF_IMX8_SUPPORT [=y]

Ick, ok, I'll go drop 2 Kconfig imx SOC patches that look to be causing
this and will push out some -rc2 versions...

thanks,

greg k-h

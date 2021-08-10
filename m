Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487383E510A
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 04:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbhHJC11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 22:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230048AbhHJC10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 22:27:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF40960FC4;
        Tue, 10 Aug 2021 02:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628562425;
        bh=V1yHooFhkSBbQPsI+2LU39Dr1EraKzTTsf0iyDGNGEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D+SzzFQSZRgFCKy7vm8TQNSgchPxu1VO2bPwaRtkGv8/Yk6jpAUSqwecV0J+BuhqC
         Pq+pGoD9D5gDisPiItRa7qPP47IivUBXbPbMUz1krQOhgf4sPDSuLWEDqXaMegWEJe
         YSks2BJGMauj01I+ZA1Qln445a/PHUK1oscjc6zh3MKQDY1v8EkAxHuY4oi6K92Kxo
         kWaP3XYGLy0+gxIdSTQEmNc6gdvPaTx9ISSOuYmW56bVT+8Lnu6+k0QRfPrKieCI4a
         k//e9ewS6zNhGpcDGPXExJzbgYnLaS0TEz+S1RY2Oe+ix6ow++/UfnkYMRVyDJNW7c
         rxroroJWMHlHw==
Date:   Mon, 9 Aug 2021 22:27:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [stable-rc/4.19.y] Build fails with commit 6642eb4eb918 ("ARM:
 imx: add missing iounmap()")
Message-ID: <YRHj96skjBbU4/9c@sashalap>
References: <20210809172421.wcrije6p7qyy55jj@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210809172421.wcrije6p7qyy55jj@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 02:24:21AM +0900, Nobuhiro Iwamatsu wrote:
>Hi,
>
>Build failed commit 6642eb4eb918 ("ARM: imx: add missing iounmap()") on
>stable-rc/linux-4.19.y.
>
>````
>arch/arm/mach-imx/mmdc.c: In function 'imx_mmdc_probe':
>arch/arm/mach-imx/mmdc.c:568:2: error: 'err' undeclared (first use in this function)
>  err = imx_mmdc_perf_init(pdev, mmdc_base);
>  ^~~
>arch/arm/mach-imx/mmdc.c:568:2: note: each undeclared identifier is reported only once for each function it appears in
>arch/arm/mach-imx/mmdc.c:573:1: error: control reaches end of non-void function [-Werror=return-type]
> }
> ^
>cc1: some warnings being treated as errors
>make[1]: *** [scripts/Makefile.build:303: arch/arm/mach-imx/mmdc.o] Error 1
>
>````
>
>It seems that err has not been declared.
>I attached a patch which revise this issue.

Thanks for the report. Instead of fixing up 6642eb4eb918 ("ARM: imx: add
missing iounmap()"), I'll take 9454a0caff6a ("ARM: imx: add mmdc ipg
clock operation for mmdc") - this way we'll diverge less from upstream.

-- 
Thanks,
Sasha

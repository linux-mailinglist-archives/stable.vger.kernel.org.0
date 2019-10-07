Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1F3CE5B8
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfJGOtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbfJGOtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 10:49:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 795EB21721;
        Mon,  7 Oct 2019 14:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570459794;
        bh=r4K7HAwLnCeGJFkWlb4lenJOAqclCLAOXkLixnCX080=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D52K+4pPEnFckx8ZJgeQB5pQg9bw/NPoVMCLRzoJC/bFTaCjswMxxBhdMP2PqRmNX
         MXB9/A1fV1FaZ8fb8tfslbeiQR+vEv2T9gP+0vyMEr5b7n/nBALrofKtuhOozThz28
         mYWblVLt26i79NTfFjiVgatl2Jswp0V47JYfdWhI=
Date:   Mon, 7 Oct 2019 16:49:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/36] 4.4.196-stable review
Message-ID: <20191007144951.GB966828@kroah.com>
References: <20191006171038.266461022@linuxfoundation.org>
 <d3e1e6ae-8ca4-a43b-d30d-9a9a9a7e5752@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3e1e6ae-8ca4-a43b-d30d-9a9a9a7e5752@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 05:53:55AM -0700, Guenter Roeck wrote:
> On 10/6/19 10:18 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.196 release.
> > There are 36 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> powerpc:defconfig fails to build.
> 
> arch/powerpc/kernel/eeh_driver.c: In function ‘eeh_handle_normal_event’:
> arch/powerpc/kernel/eeh_driver.c:678:2: error: implicit declaration of function ‘eeh_for_each_pe’; did you mean ‘bus_for_each_dev’?
> 
> It has a point:
> 
> ... HEAD is now at 13cac61d31df Linux 4.4.196-rc1
> $ git grep eeh_for_each_pe
> arch/powerpc/kernel/eeh_driver.c:       eeh_for_each_pe(pe, tmp_pe)
> arch/powerpc/kernel/eeh_driver.c:                               eeh_for_each_pe(pe, tmp_pe)
> 
> Caused by commit 3fb431be8de3a ("powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag").
> Full report will follow later.

Thanks for letting me know, I've dropped this from the queue now and
pushed out a -rc2 with that removed.

Sasha, I thought your builder would have caught stuff like this?

thanks,

greg k-h

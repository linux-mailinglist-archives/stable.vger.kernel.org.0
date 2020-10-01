Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8562C27FC24
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 11:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgJAJBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 05:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgJAJBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 05:01:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B38420B1F;
        Thu,  1 Oct 2020 09:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601542908;
        bh=kt+4CylB+BZPiTZXLju78o9i/t8YIwtWvmLyQi9Y4AU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yp2wmWYN6Qsr5guNc5v9xvC9lJgzO3b4wS6w1ihGIXqePHE3TjvSj8EjbpEP0HX4v
         hP3ggO2/ovS1XGNrzFjJibdQAV/v4FrZnYrHK9M4KA8l9/nvEGFZsYz+IVEYe9U7nB
         FmJ8EuU2XDHZFJ8YJxX0CeMgQdHTYKKW3QFiID+g=
Date:   Thu, 1 Oct 2020 11:01:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/121] 4.9.238-rc1 review
Message-ID: <20201001090149.GA1892419@kroah.com>
References: <20200929105930.172747117@linuxfoundation.org>
 <20200929204835.GB152716@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929204835.GB152716@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 01:48:35PM -0700, Guenter Roeck wrote:
> On Tue, Sep 29, 2020 at 12:59:04PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.238 release.
> > There are 121 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 171 pass: 171 fail: 0
> Qemu test results:
> 	total: 386 pass: 377 fail: 9
> Failed tests:
> 	arm:xilinx-zynq-a9:multi_v7_defconfig:mem128:zynq-zc702:initrd
> 	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zc702:rootfs
> 	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zc706:rootfs
> 	arm64:xlnx-zcu102:defconfig:smp:mem2G:initrd:xilinx/zynqmp-ep108
> 	arm64:xlnx-zcu102:defconfig:smp:mem2G:sata:rootfs:xilinx/zynqmp-ep108
> 	arm64:xlnx-zcu102:defconfig:nosmp:mem2G:initrd:xilinx/zynqmp-ep108
> 	arm64be:xlnx-zcu102:defconfig:smp:mem2G:initrd:xilinx/zynqmp-ep108
> 	arm64be:xlnx-zcu102:defconfig:smp:mem2G:sata:rootfs:xilinx/zynqmp-ep108
> 	arm64be:xlnx-zcu102:defconfig:nosmp:mem2G:initrd:xilinx/zynqmp-ep108
> 
> The Xilinx problems appears to be due to the following two commits.
> 
> 1156dd2483fd serial: uartps: Wait for tx_empty in console setup
> 9a13572bf02b serial: uartps: Add a timeout to the tx empty wait
> 
> I didn't try all tests, but reverting those two patches fixes the problem
> at least for arm64:xlnx-zcu102.
> 
> I don't see this problem in any other stable releases.

Thanks for the report, I'll drop these two and push out a -rc2, thanks.

greg k-h

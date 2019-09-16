Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1EFB3492
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 08:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfIPGH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 02:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbfIPGH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 02:07:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 420BC2067B;
        Mon, 16 Sep 2019 06:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568614045;
        bh=9e6cKEympx0Dm5cBaVQPQD0KMRh8TSl8HZvRr3mnCiQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JlE6Ze2IvO1KDrnkJ0dkYBAeVgKFwEPxNPS/l7sDkAA/G5jmIB4BbW2YnUTn7UN+U
         mUhoof0vWfY6YYlNirwfTpaD/5F9GmLddmUhV0i8jNX+2a+7zLA6z5mQEPsCmSsMsv
         E6cufvoyiCDt/JrMiApt/qn3jxAcC4kSBEcwnaaY=
Date:   Mon, 16 Sep 2019 08:07:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: Please revert upstream commit e4849aff1e16 ("MIPS: SiByte:
 Enable swiotlb ...") in v4.4.y and v4.14.y
Message-ID: <20190916060723.GA605279@kroah.com>
References: <4318a9db-0c54-319d-cc32-ed26ac95ddee@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4318a9db-0c54-319d-cc32-ed26ac95ddee@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 15, 2019 at 04:01:08PM -0700, Guenter Roeck wrote:
> Upstream commit e4849aff1e16 ("MIPS: SiByte: Enable swiotlb for SWARM,
> LittleSur and BigSur") results in build failures in v4.4.y and v4.14.y.
> 
> make bigsur_defconfig:
> 
> warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)
> warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)
> 
> and the actual build:
> 
> lib/swiotlb.o: In function `swiotlb_tbl_map_single':
> (.text+0x1c0): undefined reference to `iommu_is_span_boundary'
> Makefile:1021: recipe for target 'vmlinux' failed
> 
> Please revert.

Shouldn't I also revert it in 4.9.y?

thanks,

greg k-h

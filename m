Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1580B3D10
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 17:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfIPPDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 11:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfIPPDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 11:03:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 217B920650;
        Mon, 16 Sep 2019 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568646214;
        bh=3zppaszjifflO4CFJDAFpiOEzs4HqPvQMUcIbQpu808=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1OuuwF11gtVcalPduUAK5sWrnF9X+BRU+81OkZeoyokMsiiOhWzyCj76y9ZafAt/N
         aTwt82KVFGH8LsBoXeaKbpXDtxtbVXoK3e2gugVCKSCpykLy+4ZNmUlvRH9ummayTd
         JlZQi6HEjOe+i9TocWmo7R0binTKk86JR6gZs26E=
Date:   Mon, 16 Sep 2019 17:03:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: Please revert upstream commit e4849aff1e16 ("MIPS: SiByte:
 Enable swiotlb ...") in v4.4.y and v4.14.y
Message-ID: <20190916150332.GA1645163@kroah.com>
References: <4318a9db-0c54-319d-cc32-ed26ac95ddee@roeck-us.net>
 <20190916060723.GA605279@kroah.com>
 <c7bc60c5-1219-089d-8062-17c63a3210d1@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7bc60c5-1219-089d-8062-17c63a3210d1@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 16, 2019 at 06:15:59AM -0700, Guenter Roeck wrote:
> On 9/15/19 11:07 PM, Greg Kroah-Hartman wrote:
> > On Sun, Sep 15, 2019 at 04:01:08PM -0700, Guenter Roeck wrote:
> > > Upstream commit e4849aff1e16 ("MIPS: SiByte: Enable swiotlb for SWARM,
> > > LittleSur and BigSur") results in build failures in v4.4.y and v4.14.y.
> > > 
> > > make bigsur_defconfig:
> > > 
> > > warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)
> > > warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)
> > > 
> > > and the actual build:
> > > 
> > > lib/swiotlb.o: In function `swiotlb_tbl_map_single':
> > > (.text+0x1c0): undefined reference to `iommu_is_span_boundary'
> > > Makefile:1021: recipe for target 'vmlinux' failed
> > > 
> > > Please revert.
> > 
> > Shouldn't I also revert it in 4.9.y?
> > 
> 
> Yes, of course. Sorry. Somehow 4.9 keeps slipping my mind :-(.

Now queued up for all of those branches, thanks.

greg k-h

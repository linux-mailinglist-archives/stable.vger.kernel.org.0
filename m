Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F91DB445B
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 00:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbfIPW6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 18:58:49 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:59958 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbfIPW6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 18:58:49 -0400
Received: (from localhost user: 'macro', uid#1010) by eddie.linux-mips.org
        with ESMTP id S23991872AbfIPW6rK7bqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 00:58:47 +0200
Date:   Mon, 16 Sep 2019 23:58:47 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Guenter Roeck <linux@roeck-us.net>, stable <stable@vger.kernel.org>
Subject: Re: Please revert upstream commit e4849aff1e16 ("MIPS: SiByte: Enable
 swiotlb ...") in v4.4.y and v4.14.y
In-Reply-To: <20190916060723.GA605279@kroah.com>
Message-ID: <alpine.LFD.2.21.1909162353480.31718@eddie.linux-mips.org>
References: <4318a9db-0c54-319d-cc32-ed26ac95ddee@roeck-us.net> <20190916060723.GA605279@kroah.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 Sep 2019, Greg Kroah-Hartman wrote:

> > Upstream commit e4849aff1e16 ("MIPS: SiByte: Enable swiotlb for SWARM,
> > LittleSur and BigSur") results in build failures in v4.4.y and v4.14.y.
> > 
> > make bigsur_defconfig:
> > 
> > warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)
> > warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)
> > 
> > and the actual build:
> > 
> > lib/swiotlb.o: In function `swiotlb_tbl_map_single':
> > (.text+0x1c0): undefined reference to `iommu_is_span_boundary'
> > Makefile:1021: recipe for target 'vmlinux' failed
> > 
> > Please revert.
> 
> Shouldn't I also revert it in 4.9.y?

 NB there's certainly a dependency of some kind between this series and 
Christoph's swiotlb rework, which preceded it just a little, so I'm not at 
all surprised it can't be backported to the beginning of time without also 
pulling a pile of other changes.

 Thank you both for taking care of this revert.

  Maciej

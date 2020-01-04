Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D9D13025C
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 13:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgADMbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 07:31:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgADMbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jan 2020 07:31:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D846620848;
        Sat,  4 Jan 2020 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578141068;
        bh=QVpjc1/4jlPVd2gtunIVnBcBi4YgLlgOIz3IUTkp1Dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iduUkJNBpHF62ZC98P46HgSPBOXZwjopv/NCb6k2lqvkGvdinQEjSblWa6PpLuObk
         NEXIV13S5I91mer+4T/YS07VGa+EcpqXzcp/3V4f/gSAWK4YQEPiU40kQyKqZ2K0Bo
         ceHppjRkx+0I8EgqR5H5YGhV5JuFcMaPefOkL0fU=
Date:   Sat, 4 Jan 2020 13:31:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Barry Song <Baohua.Song@csr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 055/191] mfd: mfd-core: Honour Device Trees request
 to disable a child-device
Message-ID: <20200104123106.GB1296856@kroah.com>
References: <20200102215829.911231638@linuxfoundation.org>
 <20200102215835.819082035@linuxfoundation.org>
 <20200103102347.GA879@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103102347.GA879@gerhold.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 11:23:47AM +0100, Stephan Gerhold wrote:
> On Thu, Jan 02, 2020 at 11:05:37PM +0100, Greg Kroah-Hartman wrote:
> > From: Lee Jones <lee.jones@linaro.org>
> > 
> > [ Upstream commit 6b5c350648b857047b47acf74a57087ad27d6183 ]
> > 
> > Until now, MFD has assumed all child devices passed to it (via
> > mfd_cells) are to be registered. It does not take into account
> > requests from Device Tree and the like to disable child devices
> > on a per-platform basis.
> > 
> > Well now it does.
> > 
> > Link: https://www.spinics.net/lists/arm-kernel/msg366309.html
> > Link: https://lkml.org/lkml/2019/8/22/1350
> 
> As far as I understand it, this commit is not suitable for backporting.
> The link above explains the problem for a similar patch:
> 
> 	But I believe this would introduce a rather ugly bug in
> 	mfd_remove_devices() if the first sub-device is set to disabled:
> 	It iterates over the children devices to find the base address
> 	of the allocated "usage count" array, which is then used to free it.
> 	If the first sub-device is missing, it would free the wrong address.
> 
> This problem does not exist in mainline because the MFD usage counting
> was removed entirely as part of the larger "Simplify MFD Core" series [1].
> 
> None of the device trees in the stable kernels should depend on
> disabling MFD devices from the device tree. (They were written at a time
> when the MFD core ignored that request entirely...)
> Therefore, I would suggest to drop this patch entirely.

Thanks for catching this, now dropped from all stable queues.

greg k-h

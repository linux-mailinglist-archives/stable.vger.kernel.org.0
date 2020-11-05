Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44F22A88D5
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 22:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgKEVTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 16:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgKEVTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 16:19:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 793E720724;
        Thu,  5 Nov 2020 21:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604611188;
        bh=opztCN1CbpbvRa2OwmVvmLYZdokMDmKmCBDkSHQYN6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YWNipqEyu8W6dMj87PpEzh2LilWMPqCRX+EbO63iF3EEfLJDWVQ8sRV/6hkCCmR5f
         +c5sT7STzSBg24UhSUuKNGLU2DMNgOP77qb2BCIvVV6/qFWpT5n34uihvgYUGH6s79
         7wyFDSXd6qw1BJqaOU99c1sosnglXMGp+CPnzmgw=
Date:   Thu, 5 Nov 2020 22:20:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <benh@debian.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 4.4-4.19] xen/events: don't use chip_data for legacy IRQs
Message-ID: <20201105212036.GB2123793@kroah.com>
References: <20201104195807.GA464862@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104195807.GA464862@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 07:58:07PM +0000, Ben Hutchings wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> commit 0891fb39ba67bd7ae023ea0d367297ffff010781 upstream.
> 
> Since commit c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
> Xen is using the chip_data pointer for storing IRQ specific data. When
> running as a HVM domain this can result in problems for legacy IRQs, as
> those might use chip_data for their own purposes.
> 
> Use a local array for this purpose in case of legacy IRQs, avoiding the
> double use.
> 
> Cc: stable@vger.kernel.org
> Fixes: c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Tested-by: Stefan Bader <stefan.bader@canonical.com>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Link: https://lore.kernel.org/r/20200930091614.13660-1-jgross@suse.com
> Signed-off-by: Juergen Gross <jgross@suse.com>
> [bwh: Backported to 4.9: adjust context]
> Signed-off-by: Ben Hutchings <benh@debian.org>
> ---
>  drivers/xen/events/events_base.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)

This was in the 4.19.155 release, but I have added this to the other
kernels now too.

thanks,

greg k-h

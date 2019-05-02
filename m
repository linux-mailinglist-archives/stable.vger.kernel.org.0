Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C968011B38
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 16:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfEBOTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 10:19:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfEBOTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 10:19:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05EEE206DF;
        Thu,  2 May 2019 14:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556806763;
        bh=1JdhKEewSGbSUeLnPzy0xs36pOSOL2T8EUnudgHi9d8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n80eU9c0PewIJLLVBGzdOshV+E06yLNLv2B+EUGzJNxF4OPaFYkWjG+5eCyNwGKGf
         0Mj71d9iQJ63EflZG785OpG8FA6mMXTJegel7XhcNBFxQoGkpSwnExbnGx9RqbdFwn
         yj9giOI0kYx7IMpk7fhyo0SQEKIzGvVJSx2x6kpc=
Date:   Thu, 2 May 2019 16:19:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v4.4,v4.9] vfio/type1: Limit DMA mappings per container
Message-ID: <20190502141921.GA17577@kroah.com>
References: <1556804003-2561-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556804003-2561-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 06:33:23AM -0700, Guenter Roeck wrote:
> From: Alex Williamson <alex.williamson@redhat.com>
> 
> commit 492855939bdb59c6f947b0b5b44af9ad82b7e38c upstream.
> 
> Memory backed DMA mappings are accounted against a user's locked
> memory limit, including multiple mappings of the same memory.  This
> accounting bounds the number of such mappings that a user can create.
> However, DMA mappings that are not backed by memory, such as DMA
> mappings of device MMIO via mmaps, do not make use of page pinning
> and therefore do not count against the user's locked memory limit.
> These mappings still consume memory, but the memory is not well
> associated to the process for the purpose of oom killing a task.
> 
> To add bounding on this use case, we introduce a limit to the total
> number of concurrent DMA mappings that a user is allowed to create.
> This limit is exposed as a tunable module option where the default
> value of 64K is expected to be well in excess of any reasonable use
> case (a large virtual machine configuration would typically only make
> use of tens of concurrent mappings).
> 
> This fixes CVE-2019-3882.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Tested-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> [groeck: Adjust for missing upstream commit]
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Nice, thanks for the backport, now queued up!

greg k-h

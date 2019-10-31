Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16EFFEB12E
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 14:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfJaN24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 09:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbfJaN24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Oct 2019 09:28:56 -0400
Received: from localhost (173-25-83-245.client.mchsi.com [173.25.83.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D376220862;
        Thu, 31 Oct 2019 13:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572528535;
        bh=Vdsn3ouGQqdKJxg6rBIxYfacsyFRzG6/XTHAj2EWdFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ILRPGrHpRJTaD8MzLwhSMUGNfpsMQmgiCICKFXUcL7Sd7Y5UVPjrrH3NZlV8bvuIs
         4NzTRlP4QCsShkbDl9wwBIFjR5aYDWNeqxPDqu0Z2T+yw5DWrXrMWCC16L/XgrHEB1
         fKK/7X0bJ72f05QxiEgJhnqTCJclx+tHO8r9dgQ8=
Date:   Thu, 31 Oct 2019 08:28:53 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] Revert "nvme: Add quirk for Kingston NVME SSD running
 FW E8FK11.T"
Message-ID: <20191031132853.GA46011@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031093408.9322-1-jian-hong@endlessm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 05:34:09PM +0800, Jian-Hong Pan wrote:
> Since commit 253eaf4faaaa ("PCI/MSI: Fix incorrect MSI-X masking on
> resume") is merged, we can revert the previous quirk now.

253eaf4faaaa is pending on my pci/msi branch, planned to be merged
during the v5.5 merge window.

This revert patch must not be merged before 253eaf4faaaa.  The easiest
way to do that would be for me to merge this one as well; otherwise
we have to try to make things happen in the right order during the
merge window.

If the NVMe folks ack this idea and the patch, I'd be happy to merge
it.

> This reverts commit 19ea025e1d28c629b369c3532a85b3df478cc5c6.
> 
> Fixes: 19ea025e1d28 ("nvme: Add quirk for Kingston NVME SSD running FW E8FK11.T")
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204887
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Cc: stable@vger.kernel.org
> ---
> v2:
>   Re-send for mailing failure
> 
>  drivers/nvme/host/core.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index fa7ba09dca77..94bfbee1e5f7 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2404,16 +2404,6 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
>  		.vid = 0x14a4,
>  		.fr = "22301111",
>  		.quirks = NVME_QUIRK_SIMPLE_SUSPEND,
> -	},
> -	{
> -		/*
> -		 * This Kingston E8FK11.T firmware version has no interrupt
> -		 * after resume with actions related to suspend to idle
> -		 * https://bugzilla.kernel.org/show_bug.cgi?id=204887
> -		 */
> -		.vid = 0x2646,
> -		.fr = "E8FK11.T",
> -		.quirks = NVME_QUIRK_SIMPLE_SUSPEND,
>  	}
>  };
>  
> -- 
> 2.23.0
> 

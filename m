Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756831C82FE
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 09:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgEGHDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 03:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgEGHDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 03:03:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A466D208CA;
        Thu,  7 May 2020 07:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588835000;
        bh=XCPVdF3UwFxMM7odgf8RikTO6HE0wV4OoOQhYLN1XBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ghg81mVHuXO2uoxyREOLSiLc+KRtQwvsXMUpEAMp/g3Uu6c5P0DBFvRcZ2RuyaZLK
         si8DHJApvFlm25F+EGnD8bNMz6iU2iHcC4y5w2Cii2BXXfQbvnnIoM6MNR3quvD1Zr
         7+xCZbSWX8gQdronDHsJfpS3Kq2o7VBKwdsVbz/Q=
Date:   Thu, 7 May 2020 09:03:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH stable 5.4+] nvme: fix possible hang when ns scanning
 fails during error recovery
Message-ID: <20200507070317.GB841650@kroah.com>
References: <20200506231451.23145-1-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506231451.23145-1-sagi@grimberg.me>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 06, 2020 at 04:14:51PM -0700, Sagi Grimberg wrote:
> When the controller is reconnecting, the host fails I/O and admin
> commands as the host cannot reach the controller. ns scanning may
> revalidate namespaces during that period and it is wrong to remove
> namespaces due to these failures as we may hang (see 205da2434301).
> 
> One command that may fail is nvme_identify_ns_descs. Since we return
> success due to having ns descriptor list optional, we continue to
> validate ns identifiers in nvme_revalidate_disk, obviously fail and
> return -ENODEV to nvme_validate_ns, which will remove the namespace.
> 
> Exactly what we don't want to happen.
> 
> Fixes: 22802bf742c2 ("nvme: Namepace identification descriptor list is optional")
> Tested-by: Anton Eidelman <anton@lightbitslabs.com>
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> 
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/nvme/host/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What is the git commit id of this patch in Linus's tree?

And why sign-off on a patch twice with a blank line?

thanks,

greg k-h

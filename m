Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990E55A958
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 08:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfF2G6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jun 2019 02:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbfF2G6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Jun 2019 02:58:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4BDF204FD;
        Sat, 29 Jun 2019 06:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561791492;
        bh=ZXzRwctHC4DOxlSu7xr7Wm6mnNJ57OTUn/VkTgpTXDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gaYBvipPogWZoL6nHrObmK6Bg2xbHt/mmVqfrTg2v7tY0kFNgCpdN67TbOiPmKcdP
         /jc3CS1b6CoO9H9c6uI7vb9QMlJK9/HnlyCAqj9A+S/NpMgyZqQ/HHC1kmKfJ7nK/f
         Rc0h5t5O642K8WHQx6bYG6aIlTqNsMXMYORinoyk=
Date:   Sat, 29 Jun 2019 08:58:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     stable@vger.kernel.org, Gen Zhang <blackgod016574@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com
Subject: Re: [4.19.y PATCH 2/3] ip_sockglue: Fix missing-check bug in
 ip_ra_control()
Message-ID: <20190629065809.GB365@kroah.com>
References: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
 <156174734089.34985.7694357051190385114.stgit@srivatsa-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156174734089.34985.7694357051190385114.stgit@srivatsa-ubuntu>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 11:42:30AM -0700, Srivatsa S. Bhat wrote:
> From: Gen Zhang <blackgod016574@gmail.com>
> 
> commit 425aa0e1d01513437668fa3d4a971168bbaa8515 upstream.
> 
> In function ip_ra_control(), the pointer new_ra is allocated a memory
> space via kmalloc(). And it is used in the following codes. However,
> when  there is a memory allocation error, kmalloc() fails. Thus null
> pointer dereference may happen. And it will cause the kernel to crash.
> Therefore, we should check the return value and handle the error.
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> ---
> 
>  net/ipv4/ip_sockglue.c |    2 ++
>  1 file changed, 2 insertions(+)

Unless you can actually trigger these kmalloc failures, I do not want to
take these patches as they are not worth it at all.

thanks,

greg k-h

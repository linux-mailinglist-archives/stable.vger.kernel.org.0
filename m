Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AB331BB23
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 15:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhBOOdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 09:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhBOOdC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 09:33:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3857464DF4;
        Mon, 15 Feb 2021 14:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613399541;
        bh=wkAC5+Pz1fyPNEDU1s3uWND5jzs7Q96skLsoF5pmDvY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XZ9fhlHw2ebNfM71Rug5UflI2pWXxWLEJY+08rXCXjNAeDgQqhAyt0K9IhHTCDU7s
         wsbGwqlowVRZ2N+DHDdfYrNLW+ET8fMu30uonh/xQBSFZiWAlMXWna0lBS57v4b65P
         I8vKTQaoUvoFgPYxo2sIK6WMXh5MRP4y7rNpMDxk=
Date:   Mon, 15 Feb 2021 15:32:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH for 5.10] vdpa_sim: fix param validation in
 vdpasim_get_config()
Message-ID: <YCqF891BLn5zsUwd@kroah.com>
References: <20210211162519.215418-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211162519.215418-1-sgarzare@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 05:25:19PM +0100, Stefano Garzarella wrote:
> Commit 65b709586e222fa6ffd4166ac7fdb5d5dad113ee upstream.

No, this really is not that commit, so please do not say it is.

> Before this patch, if 'offset + len' was equal to
> sizeof(struct virtio_net_config), the entire buffer wasn't filled,
> returning incorrect values to the caller.
> 
> Since 'vdpasim->config' type is 'struct virtio_net_config', we can
> safely copy its content under this condition.
> 
> Commit 65b709586e22 ("vdpa_sim: add get_config callback in
> vdpasim_dev_attr") unintentionally solved it upstream while
> refactoring vdpa_sim.c to support multiple devices. But we don't want
> to backport it to stable branches as it contains many changes.
> 
> Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 6a90fdb9cbfc..8ca178d7b02f 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -572,7 +572,7 @@ static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
>  {
>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>  
> -	if (offset + len < sizeof(struct virtio_net_config))
> +	if (offset + len <= sizeof(struct virtio_net_config))
>  		memcpy(buf, (u8 *)&vdpasim->config + offset, len);
>  }

I'll be glad to take a one-off patch, but why can't we take the real
upstream patch?  That is always the better long-term solution, right?

thanks,

greg k-h

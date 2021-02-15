Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B5731BC3F
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhBOPYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:24:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhBOPYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:24:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF1AA64DA3;
        Mon, 15 Feb 2021 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402637;
        bh=D5A20jsw271QhgK0FxaYxiq0qi2ogTSlmiy9YeXbzJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A8kdKYnh9/BOzdQTjXtAoWAqZ4yiDv5yLJWvyK0N/AtjOs2t08Ft/ju6dfmTD2WAp
         2xxCSr7rejhF6MlFr4/iqkfvgBEXd2ikD2uxB8WQxEPlVurR/V97hob4adjQr0svNQ
         jfF0+EwMvwXkeLIsXGbn+z9UPUUhMv9VTGFUdjZw=
Date:   Mon, 15 Feb 2021 16:23:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH for 5.10] vdpa_sim: fix param validation in
 vdpasim_get_config()
Message-ID: <YCqSCg4gugL/bX8f@kroah.com>
References: <20210211162519.215418-1-sgarzare@redhat.com>
 <YCqF891BLn5zsUwd@kroah.com>
 <20210215150321.anwcogkifg6sefp6@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215150321.anwcogkifg6sefp6@steredhat>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 15, 2021 at 04:03:21PM +0100, Stefano Garzarella wrote:
> On Mon, Feb 15, 2021 at 03:32:19PM +0100, Greg KH wrote:
> > On Thu, Feb 11, 2021 at 05:25:19PM +0100, Stefano Garzarella wrote:
> > > Commit 65b709586e222fa6ffd4166ac7fdb5d5dad113ee upstream.
> > 
> > No, this really is not that commit, so please do not say it is.
> 
> Oops, sorry.
> 
> > 
> > > Before this patch, if 'offset + len' was equal to
> > > sizeof(struct virtio_net_config), the entire buffer wasn't filled,
> > > returning incorrect values to the caller.
> > > 
> > > Since 'vdpasim->config' type is 'struct virtio_net_config', we can
> > > safely copy its content under this condition.
> > > 
> > > Commit 65b709586e22 ("vdpa_sim: add get_config callback in
> > > vdpasim_dev_attr") unintentionally solved it upstream while
> > > refactoring vdpa_sim.c to support multiple devices. But we don't want
> > > to backport it to stable branches as it contains many changes.
> > > 
> > > Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
> > > Cc: <stable@vger.kernel.org> # 5.10.x
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > >  drivers/vdpa/vdpa_sim/vdpa_sim.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > > index 6a90fdb9cbfc..8ca178d7b02f 100644
> > > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > > @@ -572,7 +572,7 @@ static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
> > >  {
> > >  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> > > 
> > > -	if (offset + len < sizeof(struct virtio_net_config))
> > > +	if (offset + len <= sizeof(struct virtio_net_config))
> > >  		memcpy(buf, (u8 *)&vdpasim->config + offset, len);
> > >  }
> > 
> > I'll be glad to take a one-off patch, but why can't we take the real
> > upstream patch?  That is always the better long-term solution, right?
> 
> Because that patch depends on the following patches merged in v5.11-rc1
> while refactoring vdpa_sim:
>   f37cbbc65178 vdpa_sim: make 'config' generic and usable for any device type
>   cf1a3b35382c vdpa_sim: store parsed MAC address in a buffer
>   a13b5918fdd0 vdpa_sim: add work_fn in vdpasim_dev_attr
>   011c35bac5ef vdpa_sim: add supported_features field in vdpasim_dev_attr
>   2f8f46188805 vdpa_sim: add device id field in vdpasim_dev_attr
>   6c6e28fe4579 vdpa_sim: add struct vdpasim_dev_attr for device attributes
>   36a9c3063025 vdpa_sim: rename vdpasim_config_ops variables
>   423248d60d2b vdpa_sim: remove hard-coded virtq count
> 
> Maybe we can skip some of them, but IMHO should be less risky to apply only
> this change.
> 
> If you want I can try to figure out the minimum sub-set of patches needed
> for 65b709586e22 ("vdpa_sim: add get_config callback in vdpasim_dev_attr").

The minimum is always nice :)

If it's just too much churn for no good reason, then yes, the one-line
change above will be ok, but you need to document the heck out of why
this is not upstream and that it is a one-off thing.

thanks,

greg k-h

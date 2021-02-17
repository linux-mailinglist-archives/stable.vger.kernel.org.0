Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730AC31D7C6
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 12:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhBQK7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 05:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230417AbhBQK7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 05:59:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1CE564DEC;
        Wed, 17 Feb 2021 10:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613559536;
        bh=b1b/aNaoVehd5YPjG+c6xbLEqKnKrrXS6HoGjYZe5Ck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uky563pW9e8RQtoRpAWXFlqKR3UhAjzIZfuIc5knaxuGTv9lgeRCupHmMGaRo4kHa
         mtrhDvR/MPMJCK1BQwjxPzV1HktYglF39bX1G5SC4qpe/h8Bj2b5vHaJSv54WE427M
         oBSysl+d5SMV8U0cL9oQpJhFEiSrfQlZnwm13C5I=
Date:   Wed, 17 Feb 2021 11:58:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 5.10 v2 0/5] vdpa_sim: fix param validation in
 vdpasim_get_config()
Message-ID: <YCz27cywSabiGgDz@kroah.com>
References: <20210216142439.258713-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216142439.258713-1-sgarzare@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 16, 2021 at 03:24:34PM +0100, Stefano Garzarella wrote:
> v1: https://lore.kernel.org/stable/20210211162519.215418-1-sgarzare@redhat.com/
> 
> v2:
> - backport the upstream patch and related patches needed
> 
> Commit 65b709586e22 ("vdpa_sim: add get_config callback in
> vdpasim_dev_attr") unintentionally solved an issue in vdpasim_get_config()
> upstream while refactoring vdpa_sim.c to support multiple devices.
> 
> Before that patch, if 'offset + len' was equal to
> sizeof(struct virtio_net_config), the entire buffer wasn't filled,
> returning incorrect values to the caller.
> 
> Since 'vdpasim->config' type is 'struct virtio_net_config', we can
> safely copy its content under this condition.
> 
> The minimum set of patches to backport the patch that fixes the issue, is the
> following:
> 
>    423248d60d2b vdpa_sim: remove hard-coded virtq count
>    6c6e28fe4579 vdpa_sim: add struct vdpasim_dev_attr for device attributes
>    cf1a3b35382c vdpa_sim: store parsed MAC address in a buffer
>    f37cbbc65178 vdpa_sim: make 'config' generic and usable for any device type
>    65b709586e22 vdpa_sim: add get_config callback in vdpasim_dev_attr
> 
> The patches apply fairly cleanly. There are a few contextual differences
> due to the lack of the other patches:
> 
>    $ git backport-diff -u master -r linux-5.10.y..HEAD

Cool, where is 'backport-diff' from?

>    Key:
>    [----] : patches are identical
>    [####] : number of functional differences between upstream/downstream patch
>    [down] : patch is downstream-only
>    The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively
> 
>    001/5:[----] [--] 'vdpa_sim: remove hard-coded virtq count'
>    002/5:[----] [-C] 'vdpa_sim: add struct vdpasim_dev_attr for device attributes'
>    003/5:[----] [--] 'vdpa_sim: store parsed MAC address in a buffer'
>    004/5:[----] [-C] 'vdpa_sim: make 'config' generic and usable for any device type'
>    005/5:[----] [-C] 'vdpa_sim: add get_config callback in vdpasim_dev_attr'

Now all applied, thanks.

greg k-h

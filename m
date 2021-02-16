Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DAA31CB84
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 14:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhBPN4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 08:56:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44560 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230005AbhBPN4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 08:56:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613483716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0W8giq2Q1DKeMph1DuXghSpcsbMciexD+BiqrMJ7xtw=;
        b=fwt3zsp7WkvzwB/TX95r4F/QG7UDtmGFqsOPgXII+z+65sBV3nK3rSdSqf3FXFKzkK/9NQ
        iv0xrHhf9ejjAtE7yofv/uDtiJrGcjXDmLyfgY0m8lVUV0ws5oMOaLdKI19h43sHEJLTk1
        3enY3Rt9xAhrJCrx4u4NpuqvCzRk+FE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-yvd_8tJ3NomN04ifzRRm9g-1; Tue, 16 Feb 2021 08:55:14 -0500
X-MC-Unique: yvd_8tJ3NomN04ifzRRm9g-1
Received: by mail-wm1-f71.google.com with SMTP id f185so4363008wmf.8
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 05:55:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0W8giq2Q1DKeMph1DuXghSpcsbMciexD+BiqrMJ7xtw=;
        b=jlGgZBlkLVYKslR7doDJmR19zW9fmlQg4k5OSGxJDKpUvsoejJdmIjyJ9FmgPX5Dy0
         n6LPWScqxODx8MJzihO5gqxiKtsNfF3qOdm3YrP2nxQ7BJ+BgEkeZ4iS3mejvHDUZpII
         Uvvg3ZGksIIOJuBWWGUi6drD8W/zqMpbDymwYTFl/ErVltQ0eXej2RUG+sneOauLOIOK
         BYgSNaHcL4lJWRGidAbTPBQ9djaj+x7Rcg49Ps6nWd9r12//9jatFWlfnRMeV1CLFvkO
         eUS0k5OE0yfY9NjG7znO6UUZ2H4ZszBu+P70JDw32bOysgXAt9o101R3o7vGmgkSLpoS
         vtGQ==
X-Gm-Message-State: AOAM533AwEWiwrSxaIUoDdXPUXRnYUqJxomhCKW1LH647EDLrmW8AQ3/
        chTFffrg+efzhHdfdeAjuh3LAUBoy4NWXMrYcLmwI7m/DQXj6b2W39I6a94V7rsb0yvRzeHeGuL
        WIVa7HZ6l7BRquahr
X-Received: by 2002:adf:f389:: with SMTP id m9mr24534234wro.406.1613483713332;
        Tue, 16 Feb 2021 05:55:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTlzjWj7/PtXUmKJvMwpggEpwB25ri5EWofa4TwaZHgxK4n/IjY5wK5PIXju4uJwrrjZ3U4Q==
X-Received: by 2002:adf:f389:: with SMTP id m9mr24534210wro.406.1613483713029;
        Tue, 16 Feb 2021 05:55:13 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id u10sm3565308wmj.40.2021.02.16.05.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 05:55:12 -0800 (PST)
Date:   Tue, 16 Feb 2021 14:55:09 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH for 5.10] vdpa_sim: fix param validation in
 vdpasim_get_config()
Message-ID: <20210216135509.46cstmwwobizrjfo@steredhat>
References: <20210211162519.215418-1-sgarzare@redhat.com>
 <YCqF891BLn5zsUwd@kroah.com>
 <20210215150321.anwcogkifg6sefp6@steredhat>
 <YCqSCg4gugL/bX8f@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YCqSCg4gugL/bX8f@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 15, 2021 at 04:23:54PM +0100, Greg KH wrote:
>On Mon, Feb 15, 2021 at 04:03:21PM +0100, Stefano Garzarella wrote:
>> On Mon, Feb 15, 2021 at 03:32:19PM +0100, Greg KH wrote:
>> > On Thu, Feb 11, 2021 at 05:25:19PM +0100, Stefano Garzarella wrote:
>> > > Commit 65b709586e222fa6ffd4166ac7fdb5d5dad113ee upstream.
>> >
>> > No, this really is not that commit, so please do not say it is.
>>
>> Oops, sorry.
>>
>> >
>> > > Before this patch, if 'offset + len' was equal to
>> > > sizeof(struct virtio_net_config), the entire buffer wasn't filled,
>> > > returning incorrect values to the caller.
>> > >
>> > > Since 'vdpasim->config' type is 'struct virtio_net_config', we can
>> > > safely copy its content under this condition.
>> > >
>> > > Commit 65b709586e22 ("vdpa_sim: add get_config callback in
>> > > vdpasim_dev_attr") unintentionally solved it upstream while
>> > > refactoring vdpa_sim.c to support multiple devices. But we don't want
>> > > to backport it to stable branches as it contains many changes.
>> > >
>> > > Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
>> > > Cc: <stable@vger.kernel.org> # 5.10.x
>> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > > ---
>> > >  drivers/vdpa/vdpa_sim/vdpa_sim.c | 2 +-
>> > >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > >
>> > > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> > > index 6a90fdb9cbfc..8ca178d7b02f 100644
>> > > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> > > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> > > @@ -572,7 +572,7 @@ static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
>> > >  {
>> > >  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>> > >
>> > > -	if (offset + len < sizeof(struct virtio_net_config))
>> > > +	if (offset + len <= sizeof(struct virtio_net_config))
>> > >  		memcpy(buf, (u8 *)&vdpasim->config + offset, len);
>> > >  }
>> >
>> > I'll be glad to take a one-off patch, but why can't we take the real
>> > upstream patch?  That is always the better long-term solution, right?
>>
>> Because that patch depends on the following patches merged in v5.11-rc1
>> while refactoring vdpa_sim:
>>   f37cbbc65178 vdpa_sim: make 'config' generic and usable for any device type
>>   cf1a3b35382c vdpa_sim: store parsed MAC address in a buffer
>>   a13b5918fdd0 vdpa_sim: add work_fn in vdpasim_dev_attr
>>   011c35bac5ef vdpa_sim: add supported_features field in vdpasim_dev_attr
>>   2f8f46188805 vdpa_sim: add device id field in vdpasim_dev_attr
>>   6c6e28fe4579 vdpa_sim: add struct vdpasim_dev_attr for device attributes
>>   36a9c3063025 vdpa_sim: rename vdpasim_config_ops variables
>>   423248d60d2b vdpa_sim: remove hard-coded virtq count
>>
>> Maybe we can skip some of them, but IMHO should be less risky to apply only
>> this change.
>>
>> If you want I can try to figure out the minimum sub-set of patches needed
>> for 65b709586e22 ("vdpa_sim: add get_config callback in vdpasim_dev_attr").
>
>The minimum is always nice :)
>

The minimum set, including the patch that fixes the issue, is the 
following:

   65b709586e22 vdpa_sim: add get_config callback in vdpasim_dev_attr
   f37cbbc65178 vdpa_sim: make 'config' generic and usable for any device type
   cf1a3b35382c vdpa_sim: store parsed MAC address in a buffer
   6c6e28fe4579 vdpa_sim: add struct vdpasim_dev_attr for device attributes
   423248d60d2b vdpa_sim: remove hard-coded virtq count

The patches apply fairly cleanly. There are a few contextual differences 
due to the lack of the other patches:

   $ git backport-diff -u master -r linux-5.10.y..HEAD
   Key:
   [----] : patches are identical
   [####] : number of functional differences between upstream/downstream patch
   [down] : patch is downstream-only
   The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively

   001/5:[----] [--] 'vdpa_sim: remove hard-coded virtq count'
   002/5:[----] [-C] 'vdpa_sim: add struct vdpasim_dev_attr for device attributes'
   003/5:[----] [--] 'vdpa_sim: store parsed MAC address in a buffer'
   004/5:[----] [-C] 'vdpa_sim: make 'config' generic and usable for any device type'
   005/5:[----] [-C] 'vdpa_sim: add get_config callback in vdpasim_dev_attr'

>If it's just too much churn for no good reason, then yes, the one-line
>change above will be ok, but you need to document the heck out of why
>this is not upstream and that it is a one-off thing.
>

Shortly I'll send the series to stable@vger.kernel.org so you can judge 
if it's okay or better to resend this patch with a better description.

Thanks
Stefano


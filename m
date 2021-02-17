Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D79431D7FE
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 12:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhBQLL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 06:11:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231343AbhBQLLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 06:11:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613560221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gH/ZfysJ+cKK0O84K0Huj64i5TKxRldUz8hhIaqDtck=;
        b=SkVczp504gXWPosiVmYQwGkU9IynCGcVJRone9kQysAq9d1HkaJoPsCJekvFvOx4yrAfNl
        ubToN11UEi9TbSyMZdY14x8osKvlC3yj4oqqxCZgeTXsTjHZcZBcHyGpA66G8PwuqEBHHt
        loaXXcGhBoedRYIQ609/UYHI/Famm7A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-xqRaraCrOS6kxyoiz4NPMg-1; Wed, 17 Feb 2021 06:10:19 -0500
X-MC-Unique: xqRaraCrOS6kxyoiz4NPMg-1
Received: by mail-wr1-f69.google.com with SMTP id d7so17047917wri.23
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 03:10:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gH/ZfysJ+cKK0O84K0Huj64i5TKxRldUz8hhIaqDtck=;
        b=XknuEN/68uax4vqw1pnv+wYXUwa8g4s8cCo8k0WhJ3EVd/CzhLTwk9tkAIQv/5T7HR
         7qSUockVjgNY34sS/MtPFbX5vspBADZ4y4FiJdP11SvasnkRy2q0I4qgbklHBLfEDRlG
         dRMT/aY/BoS9UotDMMhGgJpXD/R2gm+n3QpYnAh7CGhNdCLpZuJC9vzQFKTTYxxOIdr9
         GWAzS0b9P2IyYodVljGgbmmpXubExdad6AfwSAk9tsCqx7XSz1hLD4V34FWdBtJO/vyt
         Ha5C4EnwvmUUMOuParjHk2zVYIGGe5F7o+ZgiAmvWfFFI6xB4isXeG78PiNrnsBVcV3T
         qBig==
X-Gm-Message-State: AOAM532OPTeeYEIrj6KFXttRWB1eosjwPwOvBME/1gzwhX2kCF9al+58
        lAkakPmyB+NUa+JSkBWGbxhKJaahRy0ILTnHGlzK3lRi8t93eq1G6zdg37arOND5hDJAGzXjUUN
        8T7PyZL6OfmOYxyKW
X-Received: by 2002:adf:d4d0:: with SMTP id w16mr28770625wrk.262.1613560217899;
        Wed, 17 Feb 2021 03:10:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8L9KQriiFtFtaFd14UEU5a9b2J9JRYjL6sr4KhAwRLuLnWVWCrBmMOV5ispESWTbSp7mKUQ==
X-Received: by 2002:adf:d4d0:: with SMTP id w16mr28770606wrk.262.1613560217719;
        Wed, 17 Feb 2021 03:10:17 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id s13sm2349146wmh.34.2021.02.17.03.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 03:10:17 -0800 (PST)
Date:   Wed, 17 Feb 2021 12:10:15 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 5.10 v2 0/5] vdpa_sim: fix param validation in
 vdpasim_get_config()
Message-ID: <20210217111015.ngetgbz5icfhyaza@steredhat>
References: <20210216142439.258713-1-sgarzare@redhat.com>
 <YCz27cywSabiGgDz@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YCz27cywSabiGgDz@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 11:58:53AM +0100, Greg KH wrote:
>On Tue, Feb 16, 2021 at 03:24:34PM +0100, Stefano Garzarella wrote:
>> v1: https://lore.kernel.org/stable/20210211162519.215418-1-sgarzare@redhat.com/
>>
>> v2:
>> - backport the upstream patch and related patches needed
>>
>> Commit 65b709586e22 ("vdpa_sim: add get_config callback in
>> vdpasim_dev_attr") unintentionally solved an issue in vdpasim_get_config()
>> upstream while refactoring vdpa_sim.c to support multiple devices.
>>
>> Before that patch, if 'offset + len' was equal to
>> sizeof(struct virtio_net_config), the entire buffer wasn't filled,
>> returning incorrect values to the caller.
>>
>> Since 'vdpasim->config' type is 'struct virtio_net_config', we can
>> safely copy its content under this condition.
>>
>> The minimum set of patches to backport the patch that fixes the issue, is the
>> following:
>>
>>    423248d60d2b vdpa_sim: remove hard-coded virtq count
>>    6c6e28fe4579 vdpa_sim: add struct vdpasim_dev_attr for device attributes
>>    cf1a3b35382c vdpa_sim: store parsed MAC address in a buffer
>>    f37cbbc65178 vdpa_sim: make 'config' generic and usable for any device type
>>    65b709586e22 vdpa_sim: add get_config callback in vdpasim_dev_attr
>>
>> The patches apply fairly cleanly. There are a few contextual differences
>> due to the lack of the other patches:
>>
>>    $ git backport-diff -u master -r linux-5.10.y..HEAD
>
>Cool, where is 'backport-diff' from?

It was developed by Jeff Cody and I find it very useful when doing or 
reviewing backports :-)

It's available here:
https://github.com/codyprime/git-scripts/blob/master/git-backport-diff

>
>>    Key:
>>    [----] : patches are identical
>>    [####] : number of functional differences between upstream/downstream patch
>>    [down] : patch is downstream-only
>>    The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively
>>
>>    001/5:[----] [--] 'vdpa_sim: remove hard-coded virtq count'
>>    002/5:[----] [-C] 'vdpa_sim: add struct vdpasim_dev_attr for device attributes'
>>    003/5:[----] [--] 'vdpa_sim: store parsed MAC address in a buffer'
>>    004/5:[----] [-C] 'vdpa_sim: make 'config' generic and usable for any device type'
>>    005/5:[----] [-C] 'vdpa_sim: add get_config callback in vdpasim_dev_attr'
>
>Now all applied, thanks.

Thanks,
Stefano


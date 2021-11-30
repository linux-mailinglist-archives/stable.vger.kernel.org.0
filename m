Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5229462FB4
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 10:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbhK3Jf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 04:35:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236090AbhK3Jfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 04:35:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638264756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=95/wbwyuxE7DzbjpYWIIgT2MISDRD/0Z2RLccr1nMBk=;
        b=RwPrBlT8uXK8jPze6JfTHBKWSWLyoXrC/2mTsTQiA31SB2/EUk2QCUJXPhTpduq6BZcOrZ
        x2hkGGcEMA7n7kTOjQ0QTzxGYKkjzrjuNLKLjSPuzqCUFiUumokqcWNgS48/tbkTcT8OZP
        vwpODXhV0WhQJwuapShLFoDAW48SJRQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510--i6L_i8TPDmDrLnROHSWng-1; Tue, 30 Nov 2021 04:32:34 -0500
X-MC-Unique: -i6L_i8TPDmDrLnROHSWng-1
Received: by mail-ed1-f70.google.com with SMTP id v10-20020aa7d9ca000000b003e7bed57968so16342726eds.23
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 01:32:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=95/wbwyuxE7DzbjpYWIIgT2MISDRD/0Z2RLccr1nMBk=;
        b=avPvM8tzdEB/ksOsgSW/y7qOo7NqyDsFmO/m1xIG1yh0nykN5X81Tb0vfQ+pEdnnPa
         lVg/T+zGr+6mQ0AZ+AGChp9Nx48diFkPZfDoocl9HIDomJxq40G92aGLtktQ1MWVjr0/
         FxCc8wGBW1hjMc7VZQjflf4NHJgtjd88nX2i/XgJlNL2L0KYCS4lsNDjhzap8AYjzoNS
         NFzzLZSe6rRYdHJHZJHVJcIncY75KoF8VHUdaG7P5G0fZD3lhcaK/hXXSA9jDVfTI9NS
         llCYXLBp2LuDPvp5kFDBwJfH/xAa3BH9mfD1EtqG2VLhSsbpdmGILz7Of6SPulAHGzVw
         hoCA==
X-Gm-Message-State: AOAM532IUqksQiVubqkh6UMxevYT3Ld0Jd5ECh/xBA4NM1jY2XMKRDu6
        CNsCT7QMZdgqIQlpz2luZRmNa4SCF3+XJvce/99vLrs4Axc5vKs3VG+eYR4esBdzxnXhVgFqc8H
        9GddaNI8+Z/8sFNjs
X-Received: by 2002:a05:6402:4413:: with SMTP id y19mr80697590eda.26.1638264753182;
        Tue, 30 Nov 2021 01:32:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDmTv7P796/A2e4IqQPa36J8ENyP8CCY9GhkFhEgsEHepB5C2PoVkKOSzCqO+t0lSL2tloFw==
X-Received: by 2002:a05:6402:4413:: with SMTP id y19mr80697562eda.26.1638264752958;
        Tue, 30 Nov 2021 01:32:32 -0800 (PST)
Received: from steredhat (host-79-46-195-175.retail.telecomitalia.it. [79.46.195.175])
        by smtp.gmail.com with ESMTPSA id gz10sm8564363ejc.38.2021.11.30.01.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 01:32:32 -0800 (PST)
Date:   Tue, 30 Nov 2021 10:32:28 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ifcvf/vDPA: fix misuse virtio-net device config size for
 blk dev
Message-ID: <20211130093228.iiz2r43e7mcgecnk@steredhat>
References: <20211129093144.8033-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211129093144.8033-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 05:31:44PM +0800, Zhu Lingshan wrote:
>This commit fixes a misuse of virtio-net device config size issue
>for virtio-block devices.
>
>A new member config_size in struct ifcvf_hw is introduced and would
>be initialized through vdpa_dev_add() to record correct device
>config size.
>
>Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>Reported-and-suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Fixes: 6ad31d162a4e ("vDPA/ifcvf: enable Intel C5000X-PL virtio-block for vDPA")
>Cc: <stable@vger.kernel.org>
>---
> drivers/vdpa/ifcvf/ifcvf_base.c | 41 +++++++++++++++++++++++++--------
> drivers/vdpa/ifcvf/ifcvf_base.h |  9 +++++---
> drivers/vdpa/ifcvf/ifcvf_main.c | 24 ++++---------------
> 3 files changed, 41 insertions(+), 33 deletions(-)

The patch LGTM. Maybe we could add in the description that we rename 
some fields and functions in a more generic way.

In both cases:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano


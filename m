Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3349244492
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 07:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgHNFdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 01:33:19 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726064AbgHNFdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 01:33:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597383193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VUlN7/muTmNJU/kOc7+FQne+JPRggvMyrl0TTK+qWtY=;
        b=Yon4aoA2aaYTZliujyfdiCq8loVUHPkHNh1f7W0A5KU1+M7zkX+dPDqyX2xjVLR+jedlrl
        VUrXJesT1yOgGWLD0/8D1VGqo00e73HKccyVl/MPehJXNOM4tzyoJWvxKpceGaVT/6yQFs
        FNj34uDJlT5lHtftrxDemfr1frFWc7c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-DRCPUm6kM4C6PzjYqGed9w-1; Fri, 14 Aug 2020 01:33:12 -0400
X-MC-Unique: DRCPUm6kM4C6PzjYqGed9w-1
Received: by mail-wm1-f71.google.com with SMTP id s4so2755556wmh.1
        for <stable@vger.kernel.org>; Thu, 13 Aug 2020 22:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VUlN7/muTmNJU/kOc7+FQne+JPRggvMyrl0TTK+qWtY=;
        b=N87mD4YGu2WzuOkj/yhT1GmTRzyRf+5O9U+O+9k2ZxU65iFIR+TPh+7BTh8xdzPg89
         JeB7KFMk0ClosrdBwZ9QSR5dqUrhjr9MiwqblcgpyJLL73SiGg8KQK+nAjoeFYA+Ng6A
         XvKnuHxWEDYA4Ye4GAb+mMfo8QHJaktfdZ93LDFNd4a0NEBh1ESY8F2X/VN/RxYR4d8L
         XWvHqNXGJMsgF9/PvXFY0Z4zFyuF47cPJeqX8T9xSXcueDR8X1f7+VQS0RRJw0Dl3Vjz
         nmzBQ4pcZ9qrTTd7hgTVMBTHsb2t+4UWb9ixP6OAcMUtff9+yI1MGSzqUiCySjMUgch0
         NJcA==
X-Gm-Message-State: AOAM533ssJ5CKllA8YZEAOTsY3rPwDbkTvbIuuqRJFXKF0RoE0NqT3t1
        rUXlKSqoZZwFHSYJlzustOIKpBeD6l89V+J4k4nkA1SMGvW1obLdbGWDG32UmVwkuISUnDojntP
        xeQ/JOv8OWX/V/g1c
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr923851wmc.181.1597383190791;
        Thu, 13 Aug 2020 22:33:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJza5iAfxNa6Dqa01L8V/HgdeT1QAICg0P0xSswLvZG8jU+ViNYM+qf84nDSz7o0j7lcDNrIUw==
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr923711wmc.181.1597383188634;
        Thu, 13 Aug 2020 22:33:08 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id w10sm13227959wmk.0.2020.08.13.22.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 22:33:07 -0700 (PDT)
Date:   Fri, 14 Aug 2020 01:33:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jason Wang <jasowang@redhat.com>, Max Gurtovoy <maxg@mellanox.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] vdpasim: protect concurrent access to iommu iotlb
Message-ID: <20200814013229-mutt-send-email-mst@kernel.org>
References: <20200731073822.13326-1-jasowang@redhat.com>
 <20200813162551.78D1820658@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813162551.78D1820658@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 13, 2020 at 04:25:50PM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: .
> 
> The bot has tested the following trees: v5.8, v5.7.14, v5.4.57, v4.19.138, v4.14.193, v4.9.232, v4.4.232.
> 
> v5.8: Build OK!
> v5.7.14: Build OK!
> v5.4.57: Failed to apply! Possible dependencies:
>     2c53d0f64c06 ("vdpasim: vDPA device simulator")
>     961e9c84077f ("vDPA: introduce vDPA bus")
> 
> v4.19.138: Failed to apply! Possible dependencies:
>     2c53d0f64c06 ("vdpasim: vDPA device simulator")
>     961e9c84077f ("vDPA: introduce vDPA bus")
> 
> v4.14.193: Failed to apply! Possible dependencies:
>     2c53d0f64c06 ("vdpasim: vDPA device simulator")
>     7b95fec6d2ff ("virtio: make VIRTIO a menuconfig to ease disabling it all")
>     961e9c84077f ("vDPA: introduce vDPA bus")
> 
> v4.9.232: Failed to apply! Possible dependencies:
>     0d7f4f0594fc ("MAINTAINERS: update rmk's entries")
>     2c53d0f64c06 ("vdpasim: vDPA device simulator")
>     384fe7a4d732 ("drivers: net: xgene-v2: Add DMA descriptor")
>     3b3f9a75d931 ("drivers: net: xgene-v2: Add base driver")
>     404a5c392dcc ("MAINTAINERS: fix virtio file pattern")
>     51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
>     6bc37fac30cf ("arm64: dts: add Allwinner A64 SoC .dtsi")
>     70dbd9b258d5 ("MAINTAINERS: Add entry for APM X-Gene SoC Ethernet (v2) driver")
>     7683e9e52925 ("Properly alphabetize MAINTAINERS file")
>     81ccd0cab29b ("drivers: net: xgene-v2: Add mac configuration")
>     872d1ba47bdc ("MAINTAINERS: Add Actions Semi Owl section")
>     87c586a6a0e1 ("MAINTAINERS: Update the Allwinner sunXi entry")
>     961e9c84077f ("vDPA: introduce vDPA bus")
>     b105bcdaaa0e ("drivers: net: xgene-v2: Add transmit and receive")
>     b26bff6e52d8 ("MAINTAINERS: Add device tree bindings to mv88e6xx section")
>     c0a6a5ae6b5d ("MAINTAINERS: copy virtio on balloon_compaction.c")
>     d5d4602e0405 ("Staging: iio: fix a MAINTAINERS entry")
>     dbaf0624ffa5 ("crypto: add virtio-crypto driver")
>     fd33f3eca6bf ("MAINTAINERS: Add maintainers for the meson clock driver")
> 
> v4.4.232: Failed to apply! Possible dependencies:
>     02038fd6645a ("crypto: Added Chelsio Menu to the Kconfig file")
>     06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>     2c53d0f64c06 ("vdpasim: vDPA device simulator")
>     404a5c392dcc ("MAINTAINERS: fix virtio file pattern")
>     433cd2c617bf ("crypto: rockchip - add crypto driver for rk3288")
>     6f99612e2500 ("tpm: Proxy driver for supporting multiple emulated TPMs")
>     961e9c84077f ("vDPA: introduce vDPA bus")
>     c0a6a5ae6b5d ("MAINTAINERS: copy virtio on balloon_compaction.c")
>     dbaf0624ffa5 ("crypto: add virtio-crypto driver")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

It's a simulator so I am not sure we need it at all.
Note there's a fix for this patch also upstrean, if it is
applied we need the fix too I think.

> -- 
> Thanks
> Sasha


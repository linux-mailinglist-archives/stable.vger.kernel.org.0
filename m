Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2880C23D5D5
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 05:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732323AbgHFDlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 23:41:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58497 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732314AbgHFDll (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 23:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596685300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zoLDRmI7Vggm06qAqodgqHAbTxSYnUGfusqeBW2FcOU=;
        b=AoVZrJSWUg1m0ppKo0IKKYwx/PvVt1oyPD/J55Goee+4hcC2Jmeop3lSwwmVLtPDgO0Pdx
        lWTmlaYbKlwwslFKBvcxoSE87dMo9+7wNp65dao/8MRWkR+6NiSokq3cP8s/vwc7R3fY8R
        GJhrynIHowJmq3+PU901LbTM9+drHn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-qOyVo8r0PK6lIWvE36wnkQ-1; Wed, 05 Aug 2020 23:41:36 -0400
X-MC-Unique: qOyVo8r0PK6lIWvE36wnkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FF7A18C63D1;
        Thu,  6 Aug 2020 03:41:35 +0000 (UTC)
Received: from [10.72.13.140] (ovpn-13-140.pek2.redhat.com [10.72.13.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE15F183AB;
        Thu,  6 Aug 2020 03:41:29 +0000 (UTC)
Subject: Re: [PATCH] vdpasim: protect concurrent access to iommu iotlb
To:     Sasha Levin <sashal@kernel.org>, Max Gurtovoy <maxg@mellanox.com>,
        mst@redhat.com
Cc:     stable@vger.kernel.org
References: <20200731073822.13326-1-jasowang@redhat.com>
 <20200806012410.8C84322CF7@mail.kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3e73eddd-5c74-dbc7-a77b-05e1ed078c92@redhat.com>
Date:   Thu, 6 Aug 2020 11:41:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806012410.8C84322CF7@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/8/6 上午9:24, Sasha Levin wrote:
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: .
>
> The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135, v4.14.190, v4.9.231, v4.4.231.
>
> v5.7.11: Build OK!
> v5.4.54: Failed to apply! Possible dependencies:
>      2c53d0f64c06 ("vdpasim: vDPA device simulator")
>      961e9c84077f ("vDPA: introduce vDPA bus")
>
> v4.19.135: Failed to apply! Possible dependencies:
>      2c53d0f64c06 ("vdpasim: vDPA device simulator")
>      961e9c84077f ("vDPA: introduce vDPA bus")
>
> v4.14.190: Failed to apply! Possible dependencies:
>      2c53d0f64c06 ("vdpasim: vDPA device simulator")
>      7b95fec6d2ff ("virtio: make VIRTIO a menuconfig to ease disabling it all")
>      961e9c84077f ("vDPA: introduce vDPA bus")
>
> v4.9.231: Failed to apply! Possible dependencies:
>      0d7f4f0594fc ("MAINTAINERS: update rmk's entries")
>      2c53d0f64c06 ("vdpasim: vDPA device simulator")
>      384fe7a4d732 ("drivers: net: xgene-v2: Add DMA descriptor")
>      3b3f9a75d931 ("drivers: net: xgene-v2: Add base driver")
>      404a5c392dcc ("MAINTAINERS: fix virtio file pattern")
>      51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
>      6bc37fac30cf ("arm64: dts: add Allwinner A64 SoC .dtsi")
>      70dbd9b258d5 ("MAINTAINERS: Add entry for APM X-Gene SoC Ethernet (v2) driver")
>      7683e9e52925 ("Properly alphabetize MAINTAINERS file")
>      81ccd0cab29b ("drivers: net: xgene-v2: Add mac configuration")
>      872d1ba47bdc ("MAINTAINERS: Add Actions Semi Owl section")
>      87c586a6a0e1 ("MAINTAINERS: Update the Allwinner sunXi entry")
>      961e9c84077f ("vDPA: introduce vDPA bus")
>      b105bcdaaa0e ("drivers: net: xgene-v2: Add transmit and receive")
>      b26bff6e52d8 ("MAINTAINERS: Add device tree bindings to mv88e6xx section")
>      c0a6a5ae6b5d ("MAINTAINERS: copy virtio on balloon_compaction.c")
>      d5d4602e0405 ("Staging: iio: fix a MAINTAINERS entry")
>      dbaf0624ffa5 ("crypto: add virtio-crypto driver")
>      fd33f3eca6bf ("MAINTAINERS: Add maintainers for the meson clock driver")
>
> v4.4.231: Failed to apply! Possible dependencies:
>      02038fd6645a ("crypto: Added Chelsio Menu to the Kconfig file")
>      06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>      2c53d0f64c06 ("vdpasim: vDPA device simulator")
>      404a5c392dcc ("MAINTAINERS: fix virtio file pattern")
>      433cd2c617bf ("crypto: rockchip - add crypto driver for rk3288")
>      6f99612e2500 ("tpm: Proxy driver for supporting multiple emulated TPMs")
>      961e9c84077f ("vDPA: introduce vDPA bus")
>      c0a6a5ae6b5d ("MAINTAINERS: copy virtio on balloon_compaction.c")
>      dbaf0624ffa5 ("crypto: add virtio-crypto driver")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?


The patch tries to fix a bug which is a commit introduced in 5.4.

So I think backporting it to 5.4 stable should be sufficient.

Thanks


>


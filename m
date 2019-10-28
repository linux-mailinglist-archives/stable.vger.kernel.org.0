Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A50E6CBE
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 08:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfJ1HMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 03:12:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33307 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730856AbfJ1HMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 03:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572246753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1bJKnujWpr7YRcLrIv1lIWngHNVCjyX+UL1+wlKxJ2g=;
        b=UY8+90j8gnkK6KZAPFS4HUWzJXt63JuWzv2R46tK2Tlv8g4LyoVYCqAAiTi9CskDqHmOlO
        PMtb2wsCONBEVOBy6ZRZ1MKIGCOCisb7hvC3q47EctayD/Jpc4NqW5mE8sQu45mUnnUKh2
        EuRtCFF1r+zHCDF47L467jThUe8cPB4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-At9xNW3hOQm_R1yoPs1x2Q-1; Mon, 28 Oct 2019 03:12:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACF261005509;
        Mon, 28 Oct 2019 07:12:30 +0000 (UTC)
Received: from [10.72.12.88] (ovpn-12-88.pek2.redhat.com [10.72.12.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E2E45DA32;
        Mon, 28 Oct 2019 07:12:22 +0000 (UTC)
Subject: Re: [PATCH] virtio_ring: fix stalls for packed rings
To:     Sasha Levin <sashal@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marvin Liu <yong.liu@intel.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20191027100705.11644-1-mst@redhat.com>
 <20191028065918.8487020873@mail.kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <66297f13-4c92-ae1a-25b1-8573f12b30d7@redhat.com>
Date:   Mon, 28 Oct 2019 15:12:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191028065918.8487020873@mail.kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: At9xNW3hOQm_R1yoPs1x2Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019/10/28 =E4=B8=8B=E5=8D=882:59, Sasha Levin wrote:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.3.7, v4.19.80, v4.14.150, v4.9=
.197, v4.4.197.
>
> v5.3.7: Build OK!
> v4.19.80: Failed to apply! Possible dependencies:
>      138fd25148638 ("virtio_ring: add _split suffix for split ring functi=
ons")
>      1ce9e6055fa0a ("virtio_ring: introduce packed ring support")
>      cbeedb72b97ad ("virtio_ring: allocate desc state for split ring sepa=
rately")
>      d79dca75c7968 ("virtio_ring: extract split ring handling from ring c=
reation")
>      e593bf9751566 ("virtio_ring: put split ring fields in a sub struct")
>      e6f633e5beab6 ("virtio_ring: put split ring functions together")
>      f51f982682e2a ("virtio_ring: leverage event idx in packed ring")
>      fb3fba6b162aa ("virtio_ring: cache whether we will use DMA API")
>
> v4.14.150: Failed to apply! Possible dependencies:
>      138fd25148638 ("virtio_ring: add _split suffix for split ring functi=
ons")
>      1ce9e6055fa0a ("virtio_ring: introduce packed ring support")
>      cbeedb72b97ad ("virtio_ring: allocate desc state for split ring sepa=
rately")
>      d79dca75c7968 ("virtio_ring: extract split ring handling from ring c=
reation")
>      e593bf9751566 ("virtio_ring: put split ring fields in a sub struct")
>      e6f633e5beab6 ("virtio_ring: put split ring functions together")
>      f51f982682e2a ("virtio_ring: leverage event idx in packed ring")
>      fb3fba6b162aa ("virtio_ring: cache whether we will use DMA API")
>
> v4.9.197: Failed to apply! Possible dependencies:
>      0c7eaf5930e14 ("virtio_ring: fix description of virtqueue_get_buf")
>      138fd25148638 ("virtio_ring: add _split suffix for split ring functi=
ons")
>      1ce9e6055fa0a ("virtio_ring: introduce packed ring support")
>      44ed8089e991a ("scsi: virtio: Reduce BUG if total_sg > virtqueue siz=
e to WARN.")
>      5a08b04f63792 ("virtio: allow extra context per descriptor")
>      c60923cb9cb5e ("virtio_ring: fix complaint by sparse")
>      cbeedb72b97ad ("virtio_ring: allocate desc state for split ring sepa=
rately")
>      e593bf9751566 ("virtio_ring: put split ring fields in a sub struct")
>      e6f633e5beab6 ("virtio_ring: put split ring functions together")
>      f51f982682e2a ("virtio_ring: leverage event idx in packed ring")
>      fb3fba6b162aa ("virtio_ring: cache whether we will use DMA API")
>
> v4.4.197: Failed to apply! Possible dependencies:
>      0c7eaf5930e14 ("virtio_ring: fix description of virtqueue_get_buf")
>      138fd25148638 ("virtio_ring: add _split suffix for split ring functi=
ons")
>      1ce9e6055fa0a ("virtio_ring: introduce packed ring support")
>      44ed8089e991a ("scsi: virtio: Reduce BUG if total_sg > virtqueue siz=
e to WARN.")
>      5a08b04f63792 ("virtio: allow extra context per descriptor")
>      780bc7903a32e ("virtio_ring: Support DMA APIs")
>      c60923cb9cb5e ("virtio_ring: fix complaint by sparse")
>      d26c96c810254 ("vring: Introduce vring_use_dma_api()")
>      e6f633e5beab6 ("virtio_ring: put split ring functions together")
>      f51f982682e2a ("virtio_ring: leverage event idx in packed ring")
>      fb3fba6b162aa ("virtio_ring: cache whether we will use DMA API")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?


It is only needed for kernel > 4.20.

Thanks


>


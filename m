Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3373231C27
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 11:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgG2Jdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 05:33:55 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:22698 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727044AbgG2Jdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 05:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596015233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NcytAw49Ogv+T6nX8O+DUO/ud353HRXDgEw6dxPF2is=;
        b=ajNfOOdsE6CEXB0Jz/ZFDXvga8h71dCTgWodnqWqT+zMN5caLr+TvYcF63feFZ43RfBkuy
        uoPDtMqeko2s0ZZbpXK1XM85YSRJuk0P2puoogeksUCxcTueulk464Ya9FpjqsIy2dnuqQ
        mhXLdZNFe8XonVe/hKExf3UANJN+dlM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-IqC2wmCtN_6Xj1-G6eL3FQ-1; Wed, 29 Jul 2020 05:33:33 -0400
X-MC-Unique: IqC2wmCtN_6Xj1-G6eL3FQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5207980183C;
        Wed, 29 Jul 2020 09:33:32 +0000 (UTC)
Received: from [10.72.13.120] (ovpn-13-120.pek2.redhat.com [10.72.13.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F0F6512FE;
        Wed, 29 Jul 2020 09:33:05 +0000 (UTC)
Subject: Re: [PATCH] virtio_balloon: fix up endian-ness for free cmd id
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Liang Li <liang.z.li@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        virtualization@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
References: <20200727160310.102494-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0dceaf8c-de35-93d6-f81b-67c2fdebf5ef@redhat.com>
Date:   Wed, 29 Jul 2020 17:33:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200727160310.102494-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/7/28 上午12:03, Michael S. Tsirkin wrote:
> free cmd id is read using virtio endian, spec says all fields
> in balloon are LE. Fix it up.
>
> Fixes: 86a559787e6f ("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/virtio/virtio_balloon.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 774deb65a9bb..798ec304fe3e 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -578,10 +578,14 @@ static int init_vqs(struct virtio_balloon *vb)
>   static u32 virtio_balloon_cmd_id_received(struct virtio_balloon *vb)
>   {
>   	if (test_and_clear_bit(VIRTIO_BALLOON_CONFIG_READ_CMD_ID,
> -			       &vb->config_read_bitmap))
> +			       &vb->config_read_bitmap)) {
>   		virtio_cread(vb->vdev, struct virtio_balloon_config,
>   			     free_page_hint_cmd_id,
>   			     &vb->cmd_id_received_cache);
> +		/* Legacy balloon config space is LE, unlike all other devices. */
> +		if (!virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
> +			vb->cmd_id_received_cache = le32_to_cpu((__force __le32)vb->cmd_id_received_cache);
> +	}
>   
>   	return vb->cmd_id_received_cache;
>   }


Acked-by: Jason Wang <jasowang@redhat.com>



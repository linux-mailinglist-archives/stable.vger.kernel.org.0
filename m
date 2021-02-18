Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE5A31E680
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 07:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhBRGtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 01:49:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229765AbhBRGo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 01:44:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613630581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3/r6ZrTAwzUnNQ6cScq8XvsWgkFZQZGxH65h7veBqKs=;
        b=X4nnZ4WX+bfoPZ/tFB2SponqtzaN3V3QSvYOXkPr/aXaM+AoRWDRb5zHC+kFs1p3bvj7ce
        CsBevJXE8PtTlKDyvL17pXRkwhmoW+qO7vo2Wu3jRIxc6pvo5HnFkM3cGvhI3FZ2ykw4pX
        vEGuV3sWgyH07CttZiLV6UcaOq6tMKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-iyA5BtJkP3K3KF_hZhQTIw-1; Thu, 18 Feb 2021 01:39:23 -0500
X-MC-Unique: iyA5BtJkP3K3KF_hZhQTIw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 252F180402E;
        Thu, 18 Feb 2021 06:39:22 +0000 (UTC)
Received: from [10.72.13.28] (ovpn-13-28.pek2.redhat.com [10.72.13.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34F6D177F8;
        Thu, 18 Feb 2021 06:39:16 +0000 (UTC)
Subject: Re: [PATCH for 5.10] vdpa_sim: fix param validation in
 vdpasim_get_config()
To:     Stefano Garzarella <sgarzare@redhat.com>, stable@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20210211162519.215418-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d5f8c1b7-9506-6a84-dbba-53bf21897e5f@redhat.com>
Date:   Thu, 18 Feb 2021 14:39:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210211162519.215418-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021/2/12 上午12:25, Stefano Garzarella wrote:
> Commit 65b709586e222fa6ffd4166ac7fdb5d5dad113ee upstream.
>
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
>   drivers/vdpa/vdpa_sim/vdpa_sim.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 6a90fdb9cbfc..8ca178d7b02f 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -572,7 +572,7 @@ static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
>   {
>   	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>   
> -	if (offset + len < sizeof(struct virtio_net_config))
> +	if (offset + len <= sizeof(struct virtio_net_config))
>   		memcpy(buf, (u8 *)&vdpasim->config + offset, len);
>   }
>   


Acked-by: Jason Wang <jasowang@redhat.com>



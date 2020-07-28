Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E21A2302EE
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 08:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgG1GaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 02:30:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:10185 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgG1GaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 02:30:13 -0400
IronPort-SDR: p/HhuB93hZ7tbbPCIkNdApovHth82o8NWEypqO6wgsVdYJkW3573sGt22nE4/vJLX8mwoHcCZM
 uGRKdk1VbYLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="150330765"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="150330765"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:30:12 -0700
IronPort-SDR: DWFcw058aeNY33KCMXeApCFDsG3k6E7ZcSfHBPcNVTPWRdWaBobV5jB8SpVRTW/cLo+QKp2tl2
 6pcV2+CqE9Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="434208391"
Received: from unknown (HELO [10.239.13.4]) ([10.239.13.4])
  by orsmga004.jf.intel.com with ESMTP; 27 Jul 2020 23:30:10 -0700
Message-ID: <5F1FC796.3090105@intel.com>
Date:   Tue, 28 Jul 2020 14:37:10 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC:     stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Liang Li <liang.z.li@intel.com>,
        virtualization@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH] virtio_balloon: fix up endian-ness for free cmd id
References: <20200727160310.102494-1-mst@redhat.com>
In-Reply-To: <20200727160310.102494-1-mst@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/28/2020 12:03 AM, Michael S. Tsirkin wrote:
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
Seems it exceeds 80 character length.

Reviewed-by: Wei Wang <wei.w.wang@intel.com>

Best,
Wei

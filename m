Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B60C1307F5
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 13:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgAEMYP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 5 Jan 2020 07:24:15 -0500
Received: from mga18.intel.com ([134.134.136.126]:28843 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgAEMYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jan 2020 07:24:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jan 2020 04:24:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,398,1571727600"; 
   d="scan'208";a="216612621"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jan 2020 04:24:14 -0800
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 5 Jan 2020 04:24:14 -0800
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 5 Jan 2020 04:24:13 -0800
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.202]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.245]) with mapi id 14.03.0439.000;
 Sun, 5 Jan 2020 20:24:12 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Daniel Verkamp <dverkamp@chromium.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>
Subject: RE: [PATCH v2 1/2] virtio-balloon: initialize all vq callbacks
Thread-Topic: [PATCH v2 1/2] virtio-balloon: initialize all vq callbacks
Thread-Index: AQHVwmVar6ef2LyxI0SiR1GCSEPNVafb/HDA
Date:   Sun, 5 Jan 2020 12:24:11 +0000
Message-ID: <286AC319A985734F985F78AFA26841F73E39205A@shsmsx102.ccr.corp.intel.com>
References: <20200103184044.73568-1-dverkamp@chromium.org>
In-Reply-To: <20200103184044.73568-1-dverkamp@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Saturday, January 4, 2020 2:41 AM, Daniel Verkamp wrote:
> Subject: [PATCH v2 1/2] virtio-balloon: initialize all vq callbacks
> 
> Ensure that elements of the callbacks array that correspond to unavailable
> features are set to NULL; previously, they would be left uninitialized.
> 
> Since the corresponding names array elements were explicitly set to NULL,
> the uninitialized callback pointers would not actually be dereferenced;
> however, the uninitialized callbacks elements would still be read in 
> vp_find_vqs_msix() and used to calculate the number of MSI-X vectors
> required.

The above description doesn't seem true after your second patch gets applied.
 
> Cc: stable@vger.kernel.org
> Fixes: 86a559787e6f ("virtio-balloon:
> VIRTIO_BALLOON_F_FREE_PAGE_HINT")
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
> ---
> 
> v1:
> https://lists.linuxfoundation.org/pipermail/virtualization/2019-December/04
> 4829.html
> 
> Changes from v1:
> - Clarified "array" in commit message to "callbacks array"
> 
>  drivers/virtio/virtio_balloon.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 93f995f6cf36..8e400ece9273 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -475,7 +475,9 @@ static int init_vqs(struct virtio_balloon *vb)
>  	names[VIRTIO_BALLOON_VQ_INFLATE] = "inflate";
>  	callbacks[VIRTIO_BALLOON_VQ_DEFLATE] = balloon_ack;
>  	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
> +	callbacks[VIRTIO_BALLOON_VQ_STATS] = NULL;
>  	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
> +	callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;

Could you remove other redundant NULL initialization well?
https://lists.linuxfoundation.org/pipermail/virtualization/2019-December/044837.html

Best,
Wei

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D951307F7
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 13:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgAEM1X convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 5 Jan 2020 07:27:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:1226 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgAEM1X (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jan 2020 07:27:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jan 2020 04:27:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,398,1571727600"; 
   d="scan'208";a="420449179"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga005.fm.intel.com with ESMTP; 05 Jan 2020 04:27:22 -0800
Received: from FMSMSX110.amr.corp.intel.com (10.18.116.10) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 5 Jan 2020 04:27:22 -0800
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 fmsmsx110.amr.corp.intel.com (10.18.116.10) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 5 Jan 2020 04:27:21 -0800
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.202]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.132]) with mapi id 14.03.0439.000;
 Sun, 5 Jan 2020 20:27:20 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Daniel Verkamp <dverkamp@chromium.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>
Subject: RE: [PATCH v2 2/2] virtio-pci: check name when counting MSI-X
 vectors
Thread-Topic: [PATCH v2 2/2] virtio-pci: check name when counting MSI-X
 vectors
Thread-Index: AQHVwmWt1eYUSe070EWbJPmgPgfCyafcAanA
Date:   Sun, 5 Jan 2020 12:27:19 +0000
Message-ID: <286AC319A985734F985F78AFA26841F73E39206A@shsmsx102.ccr.corp.intel.com>
References: <20200103184044.73568-1-dverkamp@chromium.org>
 <20200103184044.73568-2-dverkamp@chromium.org>
In-Reply-To: <20200103184044.73568-2-dverkamp@chromium.org>
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
> Subject: [PATCH v2 2/2] virtio-pci: check name when counting MSI-X vectors
> 
> VQs without a name specified are not valid; they are skipped in the later loop
> that assigns MSI-X vectors to queues, but the per_vq_vectors loop above that
> counts the required number of vectors previously still counted any queue with a
> non-NULL callback as needing a vector.
> 
> Add a check to the per_vq_vectors loop so that vectors with no name are not
> counted to make the two loops consistent.  This prevents over-counting
> unnecessary vectors (e.g. for features which were not negotiated with the
> device).
> 
> Cc: stable@vger.kernel.org
> Fixes: 86a559787e6f ("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT")
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
> ---
> 
> v1:
> https://lists.linuxfoundation.org/pipermail/virtualization/2019-December/0448
> 28.html
> 
>  drivers/virtio/virtio_pci_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_pci_common.c
> b/drivers/virtio/virtio_pci_common.c
> index f2862f66c2ac..222d630c41fc 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -294,7 +294,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev,
> unsigned nvqs,
>  		/* Best option: one for change interrupt, one per vq. */
>  		nvectors = 1;
>  		for (i = 0; i < nvqs; ++i)
> -			if (callbacks[i])
> +			if (names[i] && callbacks[i])
>  				++nvectors;
>  	} else {
>  		/* Second best: one for change, shared for all vqs. */
> --
> 2.24.1.735.g03f4e72817-goog

Reviewed-by: Wang, Wei W <wei.w.wang@intel.com>

Best,
Wei

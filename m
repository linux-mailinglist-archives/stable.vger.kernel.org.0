Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1795F5AE2
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 22:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiJEUSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 16:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJEUSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 16:18:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A569814DF
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 13:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665001076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g2vLC0/2i+I0uLMhPpq2EA/KZTboH7Z2lCWoTbduUxI=;
        b=XflayfSe6uGdIa9s1TIIoXW0oZLvx8JVqBwo34VoSBe7XUGycQ3QakIIrQ6ZjPuM2xmhPh
        lu/yv6qpmKW/UxO9//t7uQnRgGDPgAAXGhgeD++BCY9zeUy5sDMXiOXCBalK0rRQ71ya3A
        VXeCoktCmuCErpTh7iKQfIRP48SUh58=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-94-95PF6x2BO_Ci8bno4cppjA-1; Wed, 05 Oct 2022 16:17:56 -0400
X-MC-Unique: 95PF6x2BO_Ci8bno4cppjA-1
Received: by mail-il1-f200.google.com with SMTP id j29-20020a056e02219d00b002f9b13c40c5so14892ila.21
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 13:17:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=g2vLC0/2i+I0uLMhPpq2EA/KZTboH7Z2lCWoTbduUxI=;
        b=hZr5+Uhl7GtqbP8W7XV0aygcuNvv2PlPrAQnDTKuZT4kjOmFVq1so1pKMinfphPmp8
         iJNMlNzmsJ5bAGq6zERZQ0YrBNqIrz873+L/uz1qOy42vcDNCawG3P6SclcIc/8YFzql
         GSikiiB7cLKXnnTTdVFpPk0/ShgajGL8oOzp6ZAGRizSR2wlwa+2V/l1wc12hRn3HNYk
         f9w8160B18koDxfjOGRSb7Gj8l1zceFubqt+qwLsX/WKn/lQSoPJC0UNanCBrenH2CH6
         tqGbCvhge4y8VMyP/ETA7eMyxcB3J/j84gHlJvfuL4HpoCkLeSiflJoUPcgWiA2X4kp6
         AowQ==
X-Gm-Message-State: ACrzQf0c0ZfCVz7IEr1B8UQ2OOde3vwCv014IZZU8p89soQRfOFRvpbb
        JOJ/OblF/ePu+XxUEtfMp20BLgNOxy3Z2XeCNdwMmMEhi3TEgquiAHItDgeTqKIGDxYpPQxvXoG
        IVLksGJrF1jy70rcy
X-Received: by 2002:a05:6e02:c67:b0:2f9:9117:a581 with SMTP id f7-20020a056e020c6700b002f99117a581mr669154ilj.107.1665001075224;
        Wed, 05 Oct 2022 13:17:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7TZXdlHRglVXSKK9ZEsjo4JcrcXszFMsFm+6IUYbJ/RhiRJTAFh4/Dq8wK7FNTPN7X1kZaiQ==
X-Received: by 2002:a05:6e02:c67:b0:2f9:9117:a581 with SMTP id f7-20020a056e020c6700b002f99117a581mr669141ilj.107.1665001074983;
        Wed, 05 Oct 2022 13:17:54 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a14-20020a056602148e00b006a4ab3268f3sm1537915iow.42.2022.10.05.13.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 13:17:32 -0700 (PDT)
Date:   Wed, 5 Oct 2022 14:17:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev()
 call
Message-ID: <20221005141717.234c215e.alex.williamson@redhat.com>
In-Reply-To: <0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com>
References: <0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Sep 2022 14:48:35 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> When converting to directly create the vfio_device the mdev driver has to
> put a vfio_register_emulated_iommu_dev() in the probe() and a pairing
> vfio_unregister_group_dev() in the remove.
> 
> This was missed for gvt, add it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 978cf586ac35 ("drm/i915/gvt: convert to use vfio_register_emulated_iommu_dev")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> Should go through Alex's tree.
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 41bba40feef8f4..9003145adb5a93 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1615,6 +1615,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
>  	if (WARN_ON_ONCE(vgpu->attached))
>  		return;
>  
> +	vfio_unregister_group_dev(&vgpu->vfio_device);
>  	vfio_put_device(&vgpu->vfio_device);
>  }
>  
> 
> base-commit: c72e0034e6d4c36322d958b997d11d2627c6056c

This is marked for stable, but I think the stable backport for
existing kernels is actually:

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index e3cd58946477..de89946c4817 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1595,6 +1595,9 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
 
 	if (WARN_ON_ONCE(vgpu->attached))
 		return;
+
+	vfio_unregister_group_dev(&vgpu->vfio_device);
+	vfio_uninit_group_dev(&vgpu->vfio_device);
 	intel_gvt_destroy_vgpu(vgpu);
 }


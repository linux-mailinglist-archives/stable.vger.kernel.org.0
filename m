Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6826C5F6D83
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 20:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiJFSba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 14:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbiJFSb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 14:31:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727E4125038
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 11:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665081085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D/EnO+t9YxsYbYukQoQ5MDLGm5W9hFbMKzmQnM2kN40=;
        b=KMh9aNe8iCq05t8fHDKPHAgH97jT4WmYN2KzB1udF10MAHVMQbeGwmBfkSBAWdU8X62bzT
        NSG85IbptJzhzVCbX3ui0haqzx9t6ST/m/mh5/qB8GZ2gYxlHSvLdQZd4BfckffdBtliCx
        fTv0/eSVT2w8Al76S4QXTLvOfwOh1is=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626-24V3aPlaM8e68zlIgAReKA-1; Thu, 06 Oct 2022 14:31:24 -0400
X-MC-Unique: 24V3aPlaM8e68zlIgAReKA-1
Received: by mail-io1-f70.google.com with SMTP id v4-20020a5ec204000000b006a32e713217so1685260iop.15
        for <stable@vger.kernel.org>; Thu, 06 Oct 2022 11:31:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D/EnO+t9YxsYbYukQoQ5MDLGm5W9hFbMKzmQnM2kN40=;
        b=H6GTtys9Ehj7kS7+NIT/tZLxw7/kajDe7PMkiQCngb2+0EdCXjx4u4YGaioTctqB+7
         07fYSlXT3peLTsR+prGQ3dgGBa6YxYEE3tQrvkbPgIG1qAjeEJvsYC9YxXUM7T+A/6o5
         reKTTUVilvHU42AICce23cLkhY+EuP28OfhyBZe4YUom7eNhJ7enz/g4sViDG9OB2IXs
         Fe6IR5umNwvchoqHPYqyBSAjM1n5PV9wtHXfrwDhgOQGFUuKgwzaPHWLtURmf6R96r3A
         lgcncbnIJRzr1hzaABTetN5HJkRKBWF+8e7qcZkLCzOhEqy+0vjHoTFLZo94ISLnPo72
         Fwhg==
X-Gm-Message-State: ACrzQf2yPHCvU+VXRwEwCv+jh1y3ICju7poA0scGMcPsv/sbD5Bu5M6D
        MHWaPXy12nPytd5YFxj31ogNzpj/v7YL2i980QcsCGOT82Q9QiCFk7KVNRybtpvcBp+dI9eStkz
        sFhua/z6rymJ0zGyC
X-Received: by 2002:a6b:c3c1:0:b0:6a8:3ca0:dabf with SMTP id t184-20020a6bc3c1000000b006a83ca0dabfmr539238iof.0.1665081083576;
        Thu, 06 Oct 2022 11:31:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7pXlhLelqt1wt/DC14P6+x2KJSzkrMLAIfpeD1/B//Vj/lBsUWd5ZxsZxZUGk5To+kMEPI+w==
X-Received: by 2002:a6b:c3c1:0:b0:6a8:3ca0:dabf with SMTP id t184-20020a6bc3c1000000b006a83ca0dabfmr539223iof.0.1665081083396;
        Thu, 06 Oct 2022 11:31:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p2-20020a056638216200b003636e5c4612sm52644jak.33.2022.10.06.11.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 11:31:22 -0700 (PDT)
Date:   Thu, 6 Oct 2022 12:31:22 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev()
 call
Message-ID: <20221006123122.524c75c9.alex.williamson@redhat.com>
In-Reply-To: <Yz695fy8hm0N9DvS@nvidia.com>
References: <0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com>
        <20221005141717.234c215e.alex.williamson@redhat.com>
        <20221005160356.52d6428c.alex.williamson@redhat.com>
        <Yz695fy8hm0N9DvS@nvidia.com>
Organization: Red Hat
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

On Thu, 6 Oct 2022 08:37:09 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Oct 05, 2022 at 04:03:56PM -0600, Alex Williamson wrote:
> > We can't have a .remove callback that does nothing, this breaks
> > removing the device while it's in use.  Once we have the
> > vfio_unregister_group_dev() fix below, we'll block until the device is
> > unused, at which point vgpu->attached becomes false.  Unless I'm
> > missing something, I think we should also follow-up with a patch to
> > remove that bogus warn-on branch, right?  Thanks,  
> 
> Yes, looks right to me.
> 
> I question all the logical arround attached, where is the locking?

Zhenyu, Zhi, Kevin,

Could someone please take a look at use of vgpu->attached in the GVT-g
driver?  It's use in intel_vgpu_remove() is bogus, the .release
callback needs to use vfio_unregister_group_dev() to wait for the
device to be unused.  The WARN_ON/return here breaks all future use of
the device.  I assume @attached has something to do with the page table
interface with KVM, but it all looks racy anyway.

Also, whatever purpose vgpu->released served looks unnecessary now.
Thanks,

Alex


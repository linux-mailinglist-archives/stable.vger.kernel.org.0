Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B946BB734
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 16:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjCOPMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 11:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjCOPMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 11:12:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02F34C33
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678893111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DK3e3VadmbNCfN+0npCh9b/W73NPmz18eg1ti6Jir7U=;
        b=QEnwi6kA8oFfjcAi7DgD6lcMWNFHX1pjWOCkbKEx2twbHIetTHwfKoUFsZc8iVj38jArQG
        NQTQxOz++9HON3Maj7EDkKhTWrmY0b9SYV0YcYTXXy6cFp+bNqtvu3bMqniLeVrlrUzqkJ
        +DhqckrqQDwHY6xL31wMP/3dauCpKLI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-foEBZKC8Okq9fti5ZNOdDg-1; Wed, 15 Mar 2023 11:11:50 -0400
X-MC-Unique: foEBZKC8Okq9fti5ZNOdDg-1
Received: by mail-wr1-f72.google.com with SMTP id g7-20020a5d6987000000b002cea7acd26fso1874964wru.5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:11:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678893108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DK3e3VadmbNCfN+0npCh9b/W73NPmz18eg1ti6Jir7U=;
        b=vxAzFwQyX3mc4Zc8a8A3/KKcVcyAZ97CNG5LIsEw5Sog00eeB+8pVkxzddlUP+6623
         82AR9EyoxuM8GyNNg/Vb0FRzUO+AgQUZ7zSQgw0q4Zk6QB3aHU2EqvD/4RNVFpCx8anP
         x7R/kSmoHvBVG+SF6Ty9UbKyefzpdsDshqcb/I0qVNUkT0VoxwZk75bGEMBUurtT+uJO
         oux+q2ZD3Vk6cSRc+X3plf+DPZAaJVGj4vDoqj9SmxylskgoL82dG6Qx0SCRKBMyPXTv
         hEP+k0bdRhUaSjqts5MOM2NgDy9Kpy4X45nnVb/8UJKi2pbZU4R5+cZXF/5Rnrh+5tpr
         y+OQ==
X-Gm-Message-State: AO0yUKUkM7x89XNRMN6Q7NNnbYN3+VaKc77VcZE25Fk9/h4/pIuecAIs
        qaOGh2fRo2I7WQHIKDO097u8vXixgV0VG51dYdZ3JtiWhiPrhFalvKYQublC0R1urajc536atK2
        FwuTchxzHKfeKYlmn
X-Received: by 2002:a05:600c:470b:b0:3ed:38e7:af59 with SMTP id v11-20020a05600c470b00b003ed38e7af59mr1340333wmo.39.1678893108597;
        Wed, 15 Mar 2023 08:11:48 -0700 (PDT)
X-Google-Smtp-Source: AK7set9ieiqa3g1hPZthzvW//9SdDnRzr0SjYKDwS0RWfuLGTPvzEI2FBmYmKYSobu9hCwEijTOYDA==
X-Received: by 2002:a05:600c:470b:b0:3ed:38e7:af59 with SMTP id v11-20020a05600c470b00b003ed38e7af59mr1340314wmo.39.1678893108284;
        Wed, 15 Mar 2023 08:11:48 -0700 (PDT)
Received: from redhat.com ([2.52.155.131])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003eafc47eb09sm2157086wmi.43.2023.03.15.08.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 08:11:47 -0700 (PDT)
Date:   Wed, 15 Mar 2023 11:11:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 132/141] PCI: Avoid FLR for SolidRun SNET DPU rev 1
Message-ID: <20230315111104-mutt-send-email-mst@kernel.org>
References: <20230315115739.932786806@linuxfoundation.org>
 <20230315115743.996651796@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315115743.996651796@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 01:13:55PM +0100, Greg Kroah-Hartman wrote:
> From: Alvaro Karsz <alvaro.karsz@solid-run.com>
> 
> [ Upstream commit d089d69cc1f824936eeaa4fa172f8fa1a0949eaa ]
> 
> This patch fixes a FLR bug on the SNET DPU rev 1 by setting the
> PCI_DEV_FLAGS_NO_FLR_RESET flag.
> 
> As there is a quirk to avoid FLR (quirk_no_flr), I added a new quirk
> to check the rev ID before calling to quirk_no_flr.
> 
> Without this patch, a SNET DPU rev 1 may hang when FLR is applied.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Message-Id: <20230110165638.123745-3-alvaro.karsz@solid-run.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This is ony needed if the SNET driver is included but
isn't it all just for 6.3?


> ---
>  drivers/pci/quirks.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 494fa46f57671..44cab813bf951 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -5366,6 +5366,14 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
>  
> +/* FLR may cause the SolidRun SNET DPU (rev 0x1) to hang */
> +static void quirk_no_flr_snet(struct pci_dev *dev)
> +{
> +	if (dev->revision == 0x1)
> +		quirk_no_flr(dev);
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLIDRUN, 0x1000, quirk_no_flr_snet);
> +
>  static void quirk_no_ext_tags(struct pci_dev *pdev)
>  {
>  	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
> -- 
> 2.39.2
> 
> 


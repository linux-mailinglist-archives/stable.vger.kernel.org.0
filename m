Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF085BB995
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 18:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiIQQso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 12:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIQQsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 12:48:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C1B326C2
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 09:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663433321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2q2fuQudziyZqHxR+TIXvjIEfB3VdruVjQwZRbadT+4=;
        b=MblSaF+AhiaK2CF6RpgYiiSoxWrDxDZ0gEGGVM6HqILyKnEX6OJK2GApprEAJt4/jkMv7a
        d98NthCQmxbRhvc3VYUlSgtWCBR99Dr5IrHDqloDu7Q5JCkJjOFIQao5EQDGGM84Dh2KU3
        togpeeYFFCVzPIdN6kjmLr3ivkg5Qk0=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-nfPI7B8HNcqDnY8LGScG-w-1; Sat, 17 Sep 2022 12:48:40 -0400
X-MC-Unique: nfPI7B8HNcqDnY8LGScG-w-1
Received: by mail-pj1-f71.google.com with SMTP id f16-20020a17090a4a9000b001f234757bbbso11857080pjh.6
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 09:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=2q2fuQudziyZqHxR+TIXvjIEfB3VdruVjQwZRbadT+4=;
        b=MIrNDEdDV2hyvVHEloORV0bkZbg2/klO4FhG+sQpZRD9NYzmm5ZRZsbVeWFw6+Niyq
         L1y/rgqf1+FfRABgaKdVhV2ZZSS6kZ/52Bwmcp9XxzQ2TZzr22vuDF4KxTorbblnnwxi
         UhMFz2tD1OaybFqcFxtXdCmjauywCKXHIf5vHSfIytFTN9WOm50Va11pc/p9HwY1y/p4
         w4EVjZPCdjYdyu1c9gsloBzpo+9fLzhOxSZ5VJqaaLkhw0UEjFrMcWEhTa+dNHwbqDuJ
         KBwNG1F8V5ZGvtI02U4YFxqS85PSQxEP9rF7As6UI5ulyxIjVjmXm+Tw5pdzuRTblldc
         TaDg==
X-Gm-Message-State: ACrzQf3vBtownppEn+31kCEPmj0FphP4kZZTjFUskJqn+1bWMTTmmZHA
        Dw7FZ6VtmcjjHzf633XDn2iN1cnPDQX1T8LPvmUjNidnVvpTGLbYrOn8MsEdk2MH3P65qvupC/T
        FAwxxhImP4I8p+Mpf
X-Received: by 2002:a63:4965:0:b0:439:7a97:383c with SMTP id y37-20020a634965000000b004397a97383cmr9122291pgk.462.1663433319493;
        Sat, 17 Sep 2022 09:48:39 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4+aqXqHbZPBWyO1JH0ykRRbMffeUC72jcvYm76UK7CXgGbRg5+MFm6kN2n3V2w0cC468ugFg==
X-Received: by 2002:a63:4965:0:b0:439:7a97:383c with SMTP id y37-20020a634965000000b004397a97383cmr9122282pgk.462.1663433319252;
        Sat, 17 Sep 2022 09:48:39 -0700 (PDT)
Received: from localhost (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id y34-20020a631822000000b0041d6d37deb5sm15453492pgl.81.2022.09.17.09.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 09:48:38 -0700 (PDT)
Date:   Sat, 17 Sep 2022 09:48:36 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     baolu.lu@linux.intel.com, kevin.tian@intel.com, baolu.lu@intel.com,
        raghunathan.srinivasan@intel.com, iommu@lists.linux.dev,
        joro@8bytes.org, will@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu/vt-d: Check correct capability for sagaw
 determination
Message-ID: <20220917164836.qjmbf44au24bum4a@cantor>
References: <20220916071212.2223869-1-yi.l.liu@intel.com>
 <20220916071212.2223869-2-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916071212.2223869-2-yi.l.liu@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 12:12:11AM -0700, Yi Liu wrote:
> Check 5-level paging capability for 57 bits address width instead of
> checking 1GB large page capability.
> 
> Fixes: 53fc7ad6edf2 ("iommu/vt-d: Correctly calculate sagaw value of IOMMU")
> Cc: stable@vger.kernel.org
> Reported-by: Raghunathan Srinivasan <raghunathan.srinivasan@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com

> ---
>  drivers/iommu/intel/iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 1f2cd43cf9bc..664499dddf0c 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -399,7 +399,7 @@ static unsigned long __iommu_calculate_sagaw(struct intel_iommu *iommu)
>  {
>  	unsigned long fl_sagaw, sl_sagaw;
>  
> -	fl_sagaw = BIT(2) | (cap_fl1gp_support(iommu->cap) ? BIT(3) : 0);
> +	fl_sagaw = BIT(2) | (cap_5lp_support(iommu->cap) ? BIT(3) : 0);
>  	sl_sagaw = cap_sagaw(iommu->cap);
>  
>  	/* Second level only. */
> -- 
> 2.34.1
> 


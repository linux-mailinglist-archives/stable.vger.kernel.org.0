Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F1B198027
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 17:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgC3Pu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 11:50:28 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42174 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728259AbgC3Pu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 11:50:28 -0400
Received: by mail-pl1-f194.google.com with SMTP id e1so6875875plt.9
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 08:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x76pUnauSVO1qflHX048YWPVn9MJPW7DpvsGEX9Zf2o=;
        b=qDqwK1Pi/cwwF1v0geWjx41NuJ6crEUNZ14yQsNLl3NrpX4Kcbytdd1urRz4l+Wo8F
         oTr7F9EnTaU0t2rZkmDAxqLNpWVXdKPHTpRsEmpEgCq1u8Hrqb7AC4yMkya4vteOsvCu
         pId5VkWzud4ZsSwAsRnFMd9TY61Ip+zd86OH32FhRVPuPEY0ELMAK1+AJN1wqF+FyMiC
         EEe0fzx4IrSSUJFSp2v2T3NCG5CdnAlnL5FrU2liOqUhbQr39nTvJoA0BSzLAH9jKkjt
         SpEKQoi9b/dNAxBegni+8pAxSKvC4J1oHuDRzXImA+93S7Dltq2dccwlTSbEcWnjjxUB
         mYiA==
X-Gm-Message-State: ANhLgQ0CgNJtouVIBAL8Xrmov+y7N19dHL7+RMF7gDKJIfbO2if7BpaV
        Mw5la2/bVLqs8ZKG4kgWU0mWeeJe
X-Google-Smtp-Source: ADFU+vui0k6Sh+qfMFgmxzN8hx82BvJeCLBa9ox3bGgiNxkkRHgOZQk4zFWiSJrajEIDNEUtKdhadw==
X-Received: by 2002:a17:902:b682:: with SMTP id c2mr13474036pls.36.1585583427412;
        Mon, 30 Mar 2020 08:50:27 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id x24sm10459387pfn.140.2020.03.30.08.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 08:50:26 -0700 (PDT)
Date:   Mon, 30 Mar 2020 08:50:23 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/i915: Disable Panel Self Refresh (PSR) by default
Message-ID: <20200330155023.GA2022@sultan-box.localdomain>
References: <20200330033057.2629052-1-sultan@kerneltoast.com>
 <20200330033057.2629052-2-sultan@kerneltoast.com>
 <20200330085104.GB239298@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330085104.GB239298@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 10:51:04AM +0200, Greg KH wrote:
> On Sun, Mar 29, 2020 at 08:30:56PM -0700, Sultan Alsawaf wrote:
> > From: Sultan Alsawaf <sultan@kerneltoast.com>
> > 
> > On all Dell laptops with panels and chipsets that support PSR (an
> > esoteric power-saving mechanism), both PSR1 and PSR2 cause flickering
> > and graphical glitches, sometimes to the point of making the laptop
> > unusable. Many laptops don't support PSR so it isn't known if PSR works
> > correctly on any consumer hardware as of 5.4. PSR was enabled by default
> > in 5.0 for capable hardware, so this patch just restores the previous
> > functionality of PSR being disabled by default.
> > 
> > More info is available on the freedesktop bug:
> > https://gitlab.freedesktop.org/drm/intel/issues/425
> > 
> > Cc: <stable@vger.kernel.org> # 5.4.x
> > Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> > ---
> >  drivers/gpu/drm/i915/i915_params.c | 3 +--
> >  drivers/gpu/drm/i915/i915_params.h | 2 +-
> >  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> What is the git commit id of this patch in Linus's tree?
> 
> thanks,
> 
> greg k-h

This isn't in Linus' tree. I know for a fact that 5.4 has broken PSR support
that'll never be fixed, but I wasn't sure if PSR was still broken in 5.6.

However, I tested 5.6 for a bit right now and PSR is still broken. And to top it
off, I managed to reproduce some PSR glitches with the drm-tip branch, so
there's currently no kernel in existence with functional PSR. :)

I will send this patch for inclusion in Linus' tree, so please disregard it for
now.

Thanks,
Sultan

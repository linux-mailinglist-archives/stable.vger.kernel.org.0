Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49404D855D
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiCNMtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237721AbiCNMtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:49:06 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5334964D1
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 05:47:54 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k24so23766513wrd.7
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 05:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UcZz3PXNAXNeLX36v/bP5PcZAjppkzTqtYj3JQZLCdA=;
        b=ig3ZPDbuCYDJsY/LgK1lpVFFGCBJvNLc/orKd5+QKvhAz74QdogXuc35H6CwRfnHa+
         hT4a6QXAcVyg2Z83vj3WOEp6qcGbrEEGflCZ39lr6oczDy0B3LoakQsSKEWHEhF25TGl
         8hqA7CALrwlBQeqlQOh45Re1Edl+ybv98yo2khw1rSBH1+PRnC5+dhq1eAaKBczXqlJZ
         ul6xk3BFYCjhk7mvf7OU/zEMtmx7O3AMM19LQu/zS7QSrk84f2LvxIg8IXuLjexhJDQk
         I8Cyu7Kd22U9CgsLcEo1AWInzQOZJKa0GgYkv0oshHsaKztu5Zrw0S35lj3UhbLW2UTT
         zQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UcZz3PXNAXNeLX36v/bP5PcZAjppkzTqtYj3JQZLCdA=;
        b=OHRwiZHOn9gzc5CZDxOz+8XsLGC8yavwDVYSJvDHIHABXRkAonExWWDFw/QyI8gLG9
         lIPxjWiAcoGHhILnBl5a/21yS/9zD9cbkCk34f8nMGm7f/qq7b0kyDFGqwmElrsXUGfX
         etiBdbqGdPKGCbgYfIX680aKIn+XdV0Gruel1HdRfNosECULXa+O+y2bnlWHZoUw1fZ7
         wft3zGnYEyc4TOvi1RTz3BvGrLjtQwfNq1DkSieiKhMgG4X/C0F51IZfO5c2e8W06M7W
         Mm9I0vrrWMX4oZAPBYG9zuGI7sfVYJ8YzFv7pc+cUZLbSDYw9m18bFJj7qQmhpNgZO0W
         VguQ==
X-Gm-Message-State: AOAM532anaPInMOqqEgooe5VAksHaw1EbEpxF4rTMAMLF5nzoG69QSp8
        4FsNj5gy7E84UWf70mmUmydJIg8ciyKMw6bT
X-Google-Smtp-Source: ABdhPJxbbfF5IE+ED+j6Qzjup3ymxmcmA/LwEtp0YD0fuDRr/NLeeKHy41JvH6RnmaYRzkrpBmXj8g==
X-Received: by 2002:a5d:6d83:0:b0:203:6a0e:8854 with SMTP id l3-20020a5d6d83000000b002036a0e8854mr16161016wrs.259.1647262072830;
        Mon, 14 Mar 2022 05:47:52 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id f8-20020adfb608000000b0020229d72a4esm12782580wre.38.2022.03.14.05.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 05:47:52 -0700 (PDT)
Date:   Mon, 14 Mar 2022 12:47:50 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <Yi85dls3CCc2i1iK@google.com>
References: <20220314084302.2933167-1-lee.jones@linaro.org>
 <20220314072137-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220314072137-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022, Michael S. Tsirkin wrote:

> On Mon, Mar 14, 2022 at 08:43:02AM +0000, Lee Jones wrote:
> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > during virtqueue clean-up and we mitigate the reported issues.
> > 
> > Also WARN() as a precautionary measure.  The purpose of this is to
> > capture possible future race conditions which may pop up over time.
> > 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Pls refer to my previous responses to this patch.  I'd like to see an
> argument for why this will make future bugs less and not more likely.

If you think the previous 'check owner' patch fixes all of the
concurrency issues, then this patch can be dropped.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

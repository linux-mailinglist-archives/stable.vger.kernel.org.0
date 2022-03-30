Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812AA4EBF8C
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240552AbiC3LHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343516AbiC3LHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:07:43 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C9A12083
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:05:56 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r204-20020a1c44d5000000b0038ccb70e239so977626wma.3
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=lNEqYnWuL/bh0f/TyM3qTArL56XSe0CjRTY86pfzC7o=;
        b=fwqW4mWPY2GgW4w+8m1f8aIvTy0LuN8za+E3svng+KOmdfdGHmJ+SWLFSUvESnaEVm
         uttMvm0MCiUIvnod3RjSEFvbC29toawUGAemLn92KVg2K6ouO1U+dBLNHO6+xYOImtKt
         POvBDq6IYV7416Zs7ZaCiBtkUfKp+Os9uMVOkshq1MiknKVCHG0Sw2MpsmZHp7SYB7Ev
         wqc+Mz7IOpupQfOE835NKvR5jFleX/0BdC78+QIZwO0X92lCo7mUomwblUtSrX+NzvGR
         9E7ufbNeWI3ldJ46KXmuCcDFLxaXUR/oEK1rfA/8+LZ0ww87TFuQ3ooCpaVY1CTqtVI4
         eBrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lNEqYnWuL/bh0f/TyM3qTArL56XSe0CjRTY86pfzC7o=;
        b=Y4thhDCs1phBBPQxBf0ITvRnCeXL4K3LjgOOJCouHf6vp578LkzZraavZSs4dRc3SG
         tBchxXw0+IfaKXiRas8dSfi2AuW20lPRAyi7XGWHyw+fsRWRzHuissKOYsVKlayUnWU/
         vBGfvyJoT/MRwbDxQINS3Y9Tps90njvom0WkVxAY+JGSIinscTHPwulgp2Q3bbuhl2JR
         HILhPEQqhs5LRxux3WFRKSzTPk22IUGSE7RWuUsHCdpYkotToRg6b6cQMXSghOQYjqtu
         cjw5VPcLg3u4NJ5sxg5sbeSU/mLB8CMLfNJo8ii9FbXdwfNbajG4N6m0wbfDI9P+sa65
         a6WQ==
X-Gm-Message-State: AOAM5333eSchyv4IIRS1OQXieZaSeYdwip2ST7LZyveXa9g5EFKPgvUr
        aBtBE+e0e7W5KTzP+0xBxSMzAQ==
X-Google-Smtp-Source: ABdhPJxvCDzHSnRlAakS7s4xE1JYAevbv1AkqBgQVuZiCcaUA2Z0w5vqkI/kM0qGEF4s142a1ahqwQ==
X-Received: by 2002:a05:600c:4408:b0:388:a042:344f with SMTP id u8-20020a05600c440800b00388a042344fmr3817849wmn.52.1648638355017;
        Wed, 30 Mar 2022 04:05:55 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id p14-20020a5d59ae000000b00203dcc87d39sm27059640wrr.54.2022.03.30.04.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:05:54 -0700 (PDT)
Date:   Wed, 30 Mar 2022 12:05:53 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] virtio-blk: Use blk_validate_block_size() to
 validate block size
Message-ID: <YkQ5kQ0Ezz91hAkr@google.com>
References: <20220330105841.464954-1-lee.jones@linaro.org>
 <20220330065954-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220330065954-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 30 Mar 2022, Michael S. Tsirkin wrote:

> On Wed, Mar 30, 2022 at 11:58:41AM +0100, Lee Jones wrote:
> 
> empty patch. Try using git send email.

Not sure what you mean - check your mailer. :)

https://lore.kernel.org/all/20220330105841.464954-1-lee.jones@linaro.org/

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

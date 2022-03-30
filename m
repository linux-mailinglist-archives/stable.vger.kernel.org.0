Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7834ECEFA
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 23:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244873AbiC3VsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 17:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243390AbiC3VsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 17:48:16 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09FE1260B
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 14:46:30 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k14so18534125pga.0
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 14:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R434Yv6zd3ncsXfASrqEmavatOXxmkfnEni9rgYPuP0=;
        b=c2N+D1p5da3hhqGSdy8ZRZ+O/iSGnkK9L540WounFTkKBh6yvqk/iuT9LO/Iv8gC8K
         aJ0d7kAfcZUuEJlvzOnpSbTTqJwahvKTK5/rQKi68xD8p3m20Jn9tz7JDaegOFlERvKy
         wzj2TawUN5w5Z8qs0ONLN5Nx3/i2ZZGLZxGkw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R434Yv6zd3ncsXfASrqEmavatOXxmkfnEni9rgYPuP0=;
        b=VeURsi2J9CrC6IINXA+fzTfFlx10g3Oe4tCeU5rdIBaNqzbvJ4J9l6iUM1XNS6fIJL
         AuCArZgLSVeP3Zfnd4oZHuFptEzW18QCVZU17zuPrR7ed+ZbzemTF6RvgpZih5aeOygr
         126nrDgSmq3GZoAjrNrBMuLcufavJGdMDIHbAUCwBdWn+6Y+8+xHX5htxveOlZfGG0no
         78+xV6snAYRMRx/dojVo8LxFEpx1YaCvIJkrXZhENCKvvZP9LWqO84zePP6oq3zLQ90v
         mXdCyLGZCqtTJcBiaXNo5GPDDlwtIfORVOElEJzqzqDNqlf451ZZ5GFuALN3GJF3usjC
         jl3Q==
X-Gm-Message-State: AOAM532Me4Z+5580zTm9KGqf7xk1xuyGh8HY7QTdviwsihUynXqkeA8U
        DPdNZWpp5MQP60S0eSX9H259PQ==
X-Google-Smtp-Source: ABdhPJxYm3ZIbr7aqxooy6PQgImfEKarL+NvhdDW+Sl/21/qxJoNap2l816lBJlWuS+Su3cSJW2z8w==
X-Received: by 2002:a05:6a00:24cd:b0:4fd:9038:8aa4 with SMTP id d13-20020a056a0024cd00b004fd90388aa4mr8548812pfv.78.1648676790317;
        Wed, 30 Mar 2022 14:46:30 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h21-20020a056a001a5500b004fb71896e49sm10580013pfv.25.2022.03.30.14.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 14:46:29 -0700 (PDT)
Date:   Wed, 30 Mar 2022 14:46:29 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] skbuff: Extract list pointers to silence compiler
 warnings
Message-ID: <202203301444.78CE208@keescook>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <20220329220256.72283-2-tadeusz.struk@linaro.org>
 <YkRtWs7ieUA/7Xg9@kroah.com>
 <7f3c25f5-33ac-b5f6-9c2e-17e2310a6377@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f3c25f5-33ac-b5f6-9c2e-17e2310a6377@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 07:59:57AM -0700, Tadeusz Struk wrote:
> On 3/30/22 07:46, Greg KH wrote:
> > On Tue, Mar 29, 2022 at 03:02:56PM -0700, Tadeusz Struk wrote:
> > > Please apply this to stable 5.10.y, and 5.15.y
> > > ---8<---
> > > 
> > > From: Kees Cook<keescook@chromium.org>
> > > 
> > > Upstream commit: 1a2fb220edca ("skbuff: Extract list pointers to silence compiler warnings")
> > > 
> > > Under both -Warray-bounds and the object_size sanitizer, the compiler is
> > > upset about accessing prev/next of sk_buff when the object it thinks it
> > > is coming from is sk_buff_head. The warning is a false positive due to
> > > the compiler taking a conservative approach, opting to warn at casting
> > > time rather than access time.
> > > 
> > > However, in support of enabling -Warray-bounds globally (which has
> > > found many real bugs), arrange things for sk_buff so that the compiler
> > > can unambiguously see that there is no intention to access anything
> > > except prev/next.  Introduce and cast to a separate struct sk_buff_list,
> > > which contains_only_  the first two fields, silencing the warnings:
> > We don't have -Warray-bounds enabled on any stable kernel tree, so why
> > is this needed?
> > 
> > Where is this showing up as a problem?
> 
> The issue shows up and hinders testing stable kernels in test automations
> like syzkaller:
> 
> https://syzkaller.appspot.com/text?tag=Error&x=12b3aac3700000
> 
> Applying it to stable would enable more test coverage.

Hi! I think a better solution may be to backport this change instead:

69d0db01e210 ("ubsan: remove CONFIG_UBSAN_OBJECT_SIZE")

i.e. remove CONFIG_UBSAN_OBJECT_SIZE entirely, which is the cause of
these syzkaller splats.

-Kees

-- 
Kees Cook

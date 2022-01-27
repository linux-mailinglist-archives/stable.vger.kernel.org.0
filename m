Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB349E277
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 13:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241188AbiA0MjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 07:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240315AbiA0MjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 07:39:22 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0591EC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 04:39:22 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so7411061pjj.4
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 04:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mVxBAkWsQpPETTTC043ddBxh6xT5/MragtmZsS3czxs=;
        b=Ev++BUaIm5pi6ngoEhGe0N3rFzGd2uTb+8FgOKtOCRisKN40hbQWQxEVjcncYyF+kY
         htly4sXh0A8K1m9mLyi6x+oq7DAXq9chUWr1pHrh02IhL0FttyLxyiycEOdaxcpepa17
         qggZESAwS4Z6FnjATKHp+UuXr6nwuasT7NYptzB+jakcQrUTSYLXe/9Q4x4OIV1iUkLw
         ktqH6X3os+muR6z7hQMwwkJEg4Xy7U8inbNUnVGW6aH4UecQOyLmL931BJX9ML2IcyZx
         WMfEqPhK75uQO5EMZNCSYCxRJgYuAldh6hHAoiNRUslmmg/eQ+S80ln9NAJyw1isgdDG
         ZXJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mVxBAkWsQpPETTTC043ddBxh6xT5/MragtmZsS3czxs=;
        b=0dCTr8J4DyO/N+Tkj7IOMDT447ETVNiwNHHMOIWxlukTn9tuDRfSVXDNNHV0QeKnN7
         eTjd3fHeD/yqq4/MQQ4iS+GL3va3KK8B9xBGA/thLLvK9knNYrbSdn9T2qG963y0Gef9
         NlP3LFjRgDWzYNG8HLf7OTzuIGeeIQjF3WNPZ0F60GGKsbvC6eQYCwfFFmjSTA4/80qP
         m6946VgG6dDBygmozjgyM6i6ZIgkzt2+xBq0xh55K0q4bYhw1pInWi2Te5kgGjxzDC7R
         02ip0ycyOWoHxwnGG4Gr6b2jbEcnRDQoKYc6rUPE1TY8A+0e/B+3jaBH+EESvdNRKiqA
         tM8A==
X-Gm-Message-State: AOAM531O/N59QSaABNS+uxVwKDkUIi6+DpULops+r7gxqxVKT/+/7MiA
        apUCNhg54DQo2+Nk+Ukh8QJMAszv479fZV6VGuXIew==
X-Google-Smtp-Source: ABdhPJyEKi/LS1EiQ+NnAQ3tB5JKwiJjm+5moS8DjS32v1HHHsrgHQUq77R9pIoG722Y1Uvby5cr5WUTtnsB/t3tOSw=
X-Received: by 2002:a17:903:41c9:: with SMTP id u9mr3036244ple.174.1643287161508;
 Thu, 27 Jan 2022 04:39:21 -0800 (PST)
MIME-Version: 1.0
References: <20220125162938.838382-1-jens.wiklander@linaro.org>
 <20220125162938.838382-8-jens.wiklander@linaro.org> <CAFA6WYOLRqU4m5RJGJac9AtcpD7pt9Owd7D+XN8GjWRMAPBNuw@mail.gmail.com>
In-Reply-To: <CAFA6WYOLRqU4m5RJGJac9AtcpD7pt9Owd7D+XN8GjWRMAPBNuw@mail.gmail.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Thu, 27 Jan 2022 13:39:10 +0100
Message-ID: <CAHUa44HdOjJCt_1yGKaWXW6rUqo0ZGHBk7Tutwk69iv-7TR+mg@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] optee: use driver internal tee_contex for some rpc
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        David Howells <dhowells@redhat.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        stable@vger.kernel.org, Lars Persson <larper@axis.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 7:32 AM Sumit Garg <sumit.garg@linaro.org> wrote:
>
> +Lars
>
> Hi Jens,
>
> On Tue, 25 Jan 2022 at 21:59, Jens Wiklander <jens.wiklander@linaro.org> wrote:
> >
> > Uses the new driver internal tee_context when allocating driver private
> > shared memory. This decouples the shared memory object from its original
> > tee_context. This is needed when the life time of such a memory
> > allocation outlives the client tee_context.
> >
> > Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> > Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> > ---
> >  drivers/tee/optee/ffa_abi.c | 17 +++++++++--------
> >  drivers/tee/optee/smc_abi.c |  7 ++++---
> >  2 files changed, 13 insertions(+), 11 deletions(-)
> >
>
> As this commit fixes multiple issues seen earlier due to pre-allocated
> SHM cache in client's context. I think it makes sense to separate this
> as a standalone fix with few bits from patch #6 to target 5.17
> release. As otherwise it will take a long path via 5.18 and then
> backport to stable trees. In the meantime there can be other side
> effects noticed similar to one from Lars.

The few bits needed from #6 is actually the entire "optee: add driver
private tee_context". I'll combine the two and send them as a separate
patch, that way it's easier to keep track of what's needed for the
stable trees.

Thanks,
Jens

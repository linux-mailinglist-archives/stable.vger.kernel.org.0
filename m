Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492972509A1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 21:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgHXTvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 15:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHXTvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 15:51:06 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2352C061573;
        Mon, 24 Aug 2020 12:51:06 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d22so5451042pfn.5;
        Mon, 24 Aug 2020 12:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pMt84YGzICTARUZR9PJn3ICYFMjPcvy8tYTWPRp5eqQ=;
        b=LZnzFdyNQHSqko5TMMWql+JMJhA4flrNBTV6I5qPn4mijQ2aj6v8+u1dmVHhSLZ7Ci
         H3F4yAD63lhfOAIL3tY+yJS08/Ds0CbyUcNWXnwdOrSxxn7J4C4dEPzHBdfcbr+d2o/1
         OOFdJgvRm4kBqytmxRHOywJscsajhZ6cJU4V72EBe0LX8khBz2MfijBFidOD0/s7bvBw
         noWDQaxUTNLOQopw/ScVW0ES0B/5mVWNfIrWfJ2fyREMvfjOHjvCchbEB9gpZcpd9PQo
         OhqpvxkbXJ3dSzwik5TifYUtnyvWfM4yal1fRdxb2RXV4O11XlkDkilvbGX53qSsjwU0
         lzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pMt84YGzICTARUZR9PJn3ICYFMjPcvy8tYTWPRp5eqQ=;
        b=l+ecS56h5lRVCgJJeNK4+ZE2lJiDDb3QRnuFVkJQAPVkBgSJIjQ+gYKt46wMSTO3mL
         jh47Qc+hq9QyOdpoSqn503GoYJp8KeyLkTC0TKNQplxtgaTgQ0kz7pgrLsx7XBR2oAz7
         dPAA6o0xN9CsDpZU/C6LtLUPWKJfXoMmhvJay3FRTqG+NjP/LbWUCGJ2NCSCCH1XXG+p
         gnTgF7uCRMDCRsVIk2BvFlGol7YZc3Dk6guIE2qxvJPpf61uwuXjEAO95PROnM+a75X3
         9SoyeuEu7qeJNlAvDDrPJm/10PlcCFSvuxeopu+BBCdB8PLJ5LxI8Q50Yn7JBgQul54k
         vuag==
X-Gm-Message-State: AOAM533ROLpbRlVh+hY6bEiRrrLGmHGlTU0I1h3xna3zrtYPzdnPURx1
        4LGf/Kpypf9Zbf2Ii5TFO4s=
X-Google-Smtp-Source: ABdhPJxPQCgnZtd8bvEz8oEO37Vr++HTJ9bYWNVt/AJP8KChWeuI146XIDBgm1CIgDflLeAsJ6EqxQ==
X-Received: by 2002:a17:902:7293:: with SMTP id d19mr4986961pll.303.1598298665991;
        Mon, 24 Aug 2020 12:51:05 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id f77sm12906118pfa.216.2020.08.24.12.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 12:51:04 -0700 (PDT)
Date:   Mon, 24 Aug 2020 12:51:02 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Input; Sanitize event code before modifying bitmaps
Message-ID: <20200824195102.GY1665100@dtor-ws>
References: <20200817112700.468743-1-maz@kernel.org>
 <20200817112700.468743-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817112700.468743-2-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On Mon, Aug 17, 2020 at 12:26:59PM +0100, Marc Zyngier wrote:
> When calling into input_set_capability(), the passed event code is
> blindly used to set a bit in a number of bitmaps, without checking
> whether this actually fits the expected size of the bitmap.
> 
> This event code can come from a variety of sources, including devices
> masquerading as input devices, only a bit more "programmable".
> 
> Instead of taking the raw event code, sanitize it to the actual bitmap
> size and output a warning to let the user know.
> 
> These checks are, at least in spirit, in keeping with cb222aed03d7
> ("Input: add safety guards to input_set_keycode()").
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/input/input.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 3cfd2c18eebd..1e77cf47aa44 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -1974,14 +1974,18 @@ EXPORT_SYMBOL(input_get_timestamp);
>   * In addition to setting up corresponding bit in appropriate capability
>   * bitmap the function also adjusts dev->evbit.
>   */
> -void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code)
> +void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int raw_code)
>  {
> +	unsigned int code = raw_code;
> +
>  	switch (type) {
>  	case EV_KEY:
> +		code &= KEY_MAX;
>  		__set_bit(code, dev->keybit);


I would much rather prefer we did not simply set some random bits in
this case, but instead complained loudly and refused to alter anything.

The function is not exported directly to userspace, so we expect callers
to give us sane inputs, and I believe WARN() splash in case of bad
inputs would be the best solution here.

Thanks.

-- 
Dmitry

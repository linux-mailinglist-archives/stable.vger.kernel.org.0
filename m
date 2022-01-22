Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4D9496D61
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 19:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiAVSlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 13:41:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229379AbiAVSlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 13:41:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642876878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nMVEuxby4Oty+HMSfbWnrVt8d9o3+tJEenWCIeRiG30=;
        b=InFfnvhsYTa2Fgh+mQCMcWSJke/M7p+Lf3Tqhu/C+3O0u3RbEbdmbgE/qiWOZX2wXOHjz+
        3vshKEGk+E8alKmgj5iN8evuG1R3UEevDFr46sQYQX080dTOIHNOERJ0DLE6xAJOi8KrOO
        qipp501Fpfp2zEfYe1/utbFQSTUWguw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-pIms8-7lMA-CRkphaHfEBA-1; Sat, 22 Jan 2022 13:41:14 -0500
X-MC-Unique: pIms8-7lMA-CRkphaHfEBA-1
Received: by mail-ej1-f72.google.com with SMTP id o4-20020a170906768400b006a981625756so1257740ejm.0
        for <stable@vger.kernel.org>; Sat, 22 Jan 2022 10:41:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nMVEuxby4Oty+HMSfbWnrVt8d9o3+tJEenWCIeRiG30=;
        b=XwdncOFop+7xFGM7Mjd0l+wEi2HIEGG0qbS5A6CeOlFZ99jUHNV17M7+/eSVRCC81I
         rGpbnsDA48w4k85Z3NOCLdA7Cd1PUk/7u4NUNlm7DoHVvq7haD9xPlgD+F8IeQVBBcJM
         O5iii72r4lwniXkNAtb8wM1KxpTtcTUEu2RyExf15NvYfHiuogCqnRfprKVfODvSRMM7
         jNmIV02MbkDrkyyXS4QIQvhQ27Dx7cZ8dMdxQVmc4mncWyKMZaAMT3m8Kfw+sKt2gIOH
         GPAJw/tIbk/cOrACY4dliCywLPWMpZx2eHoZYu26ws8eVjcrkuokAY2B2G5q1j9/THAp
         7nSw==
X-Gm-Message-State: AOAM532yMLPtiWF+dY9ZhwTdkdo26TcCCM1RbB2/1LAvqLg9gTnLfaYW
        DKl1tUk9IBwh71gjYN4XyQYBYrEBkGWZx3wVhVeUw1Z7cII1hCoxNf3odIkAXpex+w3EGQpXxdX
        XPIJZHSo51DtR+v90pXNXuqXLMVxBeC1w
X-Received: by 2002:a17:906:1145:: with SMTP id i5mr7308338eja.317.1642876873451;
        Sat, 22 Jan 2022 10:41:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsowmV6WEGPAHYuljpyxjpv0b2mFW6A0EqEebugWIgCx/2hN+bAFAkeOGA8cYHli13I+7tSDURQAZ1ItsfQVY=
X-Received: by 2002:a17:906:1145:: with SMTP id i5mr7308326eja.317.1642876873243;
 Sat, 22 Jan 2022 10:41:13 -0800 (PST)
MIME-Version: 1.0
References: <YemwBdpmBeC03JeT@bender.morinfr.org>
In-Reply-To: <YemwBdpmBeC03JeT@bender.morinfr.org>
From:   Daniel Vacek <neelx@redhat.com>
Date:   Sat, 22 Jan 2022 19:40:36 +0100
Message-ID: <CACjP9X-EndAvxDBonD=pSFDsR0esyQQA5_iLqCdGOUpSK9B7Cg@mail.gmail.com>
Subject: Re: [PATCH for stable 5.x] rcu: Tighten rcu_advance_cbs_nowake() checks
To:     Guillaume Morin <guillaume@morinfr.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, paulmck@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 8:03 PM Guillaume Morin <guillaume@morinfr.org> wrote:
>
> Paul,
>
> I believe commit 614ddad17f22a22e035e2ea37a04815f50362017 (slated for
> 5.17) should be queued for all 5.4+ stable branches as it fixes a
> serious lockup bug. FWIW I have verified it applies cleanly on all 4
> branches.

I agree here. 5.4+ suffers this bug and the mentioned commit addresses
that issue.

--nX

> Does that make sense to you?
>
> Guillaume.
>
> --
> Guillaume Morin <guillaume@morinfr.org>
>


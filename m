Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78B43B72E8
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 15:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbhF2NHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 09:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbhF2NHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 09:07:41 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D93C061766
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 06:05:13 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id q23so5354953oiw.11
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 06:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AEV/WRF0Y0ujX/WfxQA0NcsIjvbaet/AXkvfL06Fxro=;
        b=Fu7/abfpV6kGILaO1P8/3DbMiuH5lUgY6AXOOuHwB9qMXmA6bB2cxMLthLx6wCwyd8
         I8BTv7O1FzKvqYDTWbMO2hHn7ztrhhm5vjk6VSDIDR+zjwosu4eZ0+mx3sm4KLPgPj6C
         D8PlzwaEte7Tt3Y0zVmLOBdcF7jKLL9Kajy6L2MWft4T0zAbXP2gvdytbmigqkk38KE4
         i7t9t26AsiaRZTsUkznZ9O+SwA2TTX6fyBdAQI+wgDg/hqD8g1mEFCTVVMYOgrNYvq/2
         IMtZoPb0mSSe4OZGg5UjNVsMcs4uKEE5vQlmJdNKUhc/WcKEHt13MBAQXZSA6h8u/wiG
         oiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AEV/WRF0Y0ujX/WfxQA0NcsIjvbaet/AXkvfL06Fxro=;
        b=pXVtd4am001DyzgM6zJXHibysHZl5cGeqxcQmxepG15NTDu04dvidm7r4XhiQBN3Ok
         5x8kVR+nWw8Gs5AXh5WXgGq6bXYj/ZAjh3OYYRVB3zwV1Y9zXJpOiVtqhhlquqG8/wEF
         fjUKroQ8fli1IE7k5IaQKWpaWllgDcpldsXWymZJmDBeK4oARGQppQ/0eeWxR6ebzYks
         VeTCFgYSwKVdNuyHXEzijo7ePb7lap1pY6i1eEjGf6jyQdVP4EgYPDefE2Mdgn2ac/Ka
         6MGFYWle6LbPhlDGXyBONfoRX5k8d9H19B0KODgbh20AzCCMJIJi8jYe2TcTGcnXKdYU
         ynKQ==
X-Gm-Message-State: AOAM531VZTeaxP83e2pylOzHLEyCWNWihOuzB2/hPCo2kzcyOllPp03x
        frvkINaEOwVfvgBRq3VFN5J8DPlMgzDjhLxlzeRs4g==
X-Google-Smtp-Source: ABdhPJwn6TCJ6i41XF6zt8tugLcu+tQNibbvlhwV6CqK+CCWRGK+s7Fb13zbr/iDARVi/nPlFWoR/Mdn8UsLbL2H+M4=
X-Received: by 2002:a05:6808:bd5:: with SMTP id o21mr21256488oik.172.1624971912663;
 Tue, 29 Jun 2021 06:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210629130048.820142-1-glider@google.com>
In-Reply-To: <20210629130048.820142-1-glider@google.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 29 Jun 2021 15:05:00 +0200
Message-ID: <CANpmjNN35j2Sf17TMqpOVZZv2N6ELzBZOsG5-jpFoPvgfuVzFA@mail.gmail.com>
Subject: Re: [PATCH] kfence: skip DMA allocations
To:     Alexander Potapenko <glider@google.com>
Cc:     akpm@linux-foundation.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Jun 2021 at 15:00, Alexander Potapenko <glider@google.com> wrote:
[...]
> +       /*
> +        * Skip DMA allocations. These must reside in the low memory, which we
> +        * cannot guarantee.
> +        */
> +       if (flags & (__GFP_DMA | __GFP_DMA32) ||

I think we want braces around "flags & (...)", so that this becomes:

    if ((flags & (...)) ||

> +           (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
> +               return NULL;

Thanks,
-- Marco

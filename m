Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0943F307BC9
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbhA1RHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbhA1RH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 12:07:26 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD386C061573
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 09:06:45 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id l12so7219982ljc.3
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 09:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LkrJm7U7mDdQ4OKQvfjV3ukz3WJDfPA15wLuPItmbOE=;
        b=Ym/mHfhFk+OmPYHXLRGVpn540PUV51S08Uw5GDWkwaHamneo2AvmwwHRxCFuEMnahu
         mTllj1MFqapNyaFROIlS1K+xBDTzW74tQ/gCydcXXFZ3XMAtfO30doqm/t2CPRAU58lC
         CrRCRJZtp90i6NbsaVc5C3Cmo92Q4hPjhfro8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LkrJm7U7mDdQ4OKQvfjV3ukz3WJDfPA15wLuPItmbOE=;
        b=psZ1sQR3bZE9zhzQmiLs84Q1OZgnzZm7bHfy0Cte6nN6n4YDsrNYEpaUrX7Ezno3f4
         Zo7rpGvrsAKWZrKcUERHvmhIIdnS3p+KUBKz3u0nFY/E4kN3zSEbDP7byEYjnJuV0XXb
         Njkk+ox/+lwdifPiHijfJJMHpPZFhbjtLvlnwxyz84gzUQOXSBvBNDGmN8IivfzHNcif
         MafqI8x8n7WM8iHzjUqEfIy5Ig8tDxs6vNNP17EH1WjkNGejaFjKiupD0iSBmV/EamRD
         1KmO4uS6Q1ZaKZsTrHWFoU7A6AjtPvms+sedPFqBHMzFeNrnqAu/mO//aRMDV3fzioT9
         9Ygg==
X-Gm-Message-State: AOAM531JZmYGeM/79OQTbia8Q3V64mF9khmUempkKpBTxE+3K0MiAYEU
        w53VZhWd80z6I0G2anXlB5h3dFTXqyg0bg==
X-Google-Smtp-Source: ABdhPJyIkomS0ysSsoGzhbPtdupaugR95O4uDVG0BlcVQaAJG3o0EgD89CFom+t3E1pFDXfQqkStOQ==
X-Received: by 2002:a2e:9548:: with SMTP id t8mr140696ljh.284.1611853604104;
        Thu, 28 Jan 2021 09:06:44 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id j5sm1740390lfu.139.2021.01.28.09.06.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:06:42 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id e2so4920211lfj.13
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 09:06:42 -0800 (PST)
X-Received: by 2002:a19:8458:: with SMTP id g85mr9204lfd.487.1611853602335;
 Thu, 28 Jan 2021 09:06:42 -0800 (PST)
MIME-Version: 1.0
References: <20200616153100.633279950@linuxfoundation.org> <20200616153106.532769297@linuxfoundation.org>
In-Reply-To: <20200616153106.532769297@linuxfoundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 28 Jan 2021 09:06:25 -0800
X-Gmail-Original-Message-ID: <CAHk-=whCd3aED5YOagwmt3-1+tbc796kgSrqF_PZAZ4_=d1ygg@mail.gmail.com>
Message-ID: <CAHk-=whCd3aED5YOagwmt3-1+tbc796kgSrqF_PZAZ4_=d1ygg@mail.gmail.com>
Subject: Re: [PATCH 5.4 120/134] mm/slub: fix a memory leak in sysfs_slab_add()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Note: this patch is getting reverted upstream, because it causes a
double free (admittedly under very rare circumstances, but still).

I'll mark the revert for stable, since it seems to have made it into
basically all stable kernels.

The revert commit is 757fed1d0898 Revert "mm/slub: fix a memory leak
in sysfs_slab_add()".

            Linus

On Tue, Jun 16, 2020 at 8:41 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Wang Hai <wanghai38@huawei.com>
>
> commit dde3c6b72a16c2db826f54b2d49bdea26c3534a2 upstream.

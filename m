Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F38B3D6885
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 23:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhGZUh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 16:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbhGZUh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 16:37:56 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFDDC061757;
        Mon, 26 Jul 2021 14:18:24 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id a93so17217080ybi.1;
        Mon, 26 Jul 2021 14:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MPfNRfZv4QlQu0N35iNOwu7avqCa/8bSd3bKlBcFimw=;
        b=l7wseu3GRTMOWEFS1N8EN/SvCgv52Uo8XRCgGLpfFJ0KC0NtpP2MoPvKHZxva/V+KK
         80IdCIUqrNK20sgcHmTOAvDPY5hGxKZcByywGc3SIQctbmBVYnhK/YfzBA4mqJumhfnK
         c25zMSDO9rG9mlJmpCXvllpwDUbGOJN4f1vuZeduxSTSX1LRLboLnkeZUIXMC92vjluc
         /sU9WXlXNCnqReF1doE4z80gM0TMdqynkwnQNgIpOyg4ZR5nW374vU/tQ1ZYzPGw1GaW
         uu89QofHzTmZ8F9wkZ/vJ2VKibPi8YN/drUafvTnHVRk5QNwButph027BhSdNENhAcJK
         Z2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MPfNRfZv4QlQu0N35iNOwu7avqCa/8bSd3bKlBcFimw=;
        b=eRiDnThHVn+fJm6gYJHYSpoYOLsDQB9rkGT72Aecexzybc3iM4PW/yggrNUntPJYLj
         W/jbx5Szs5SWkj+i7c4L5DgQQztKDR3NGcnO79/2R8eHL5LRvYdT5G2XsqLUJ1U2JKLb
         tLmMuYj7WRvl25fgJD1lLJw6II6zQdTODAI//Ivi0ltKkUsXxukqqV2ufTn2fBbWKTDW
         VXXSPEbLebHXnkng9uOlmsveR+fUWIj6XQ9iRNQc0YusIygCuMBAaeifKC7LZjy+6aLR
         kpGNBMYGnZ5z1bxpmTIxuJmkNyUZcK2p8hkLm42b9syr51Id1Hz6OARO13JYQHgEE1MD
         G6tg==
X-Gm-Message-State: AOAM530eomJI3cEr2g/3Vo4b4jdOMt/PJOXpdoD4siPShAZzAgZAXwPA
        wyOMKwo3Q17MMZ5K21RePbB4cC78tsj7fThnb26bvLWYxQcIkQ==
X-Google-Smtp-Source: ABdhPJxnLKnyqSCPE7NdMhnF1D9rLeXKWpLtQULHt7Js+WlgNfmTzrQoWTU2u/M/vi+egUCO8fgUBEZ5RHFATbXMPFo=
X-Received: by 2002:a25:c402:: with SMTP id u2mr25127220ybf.19.1627334303666;
 Mon, 26 Jul 2021 14:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210726153832.339431936@linuxfoundation.org> <20210726153836.031515657@linuxfoundation.org>
In-Reply-To: <20210726153836.031515657@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 26 Jul 2021 22:17:47 +0100
Message-ID: <CADVatmOcg_7eQno88nu4ijX9QOoA0h2QY=hoj3TZU+tNqj0TMg@mail.gmail.com>
Subject: Re: [PATCH 4.19 111/120] KVM: do not assume PTE is writable after follow_pfn
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        David Stevens <stevensd@google.com>, 3pvd@google.com,
        Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jul 26, 2021 at 4:58 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Paolo Bonzini <pbonzini@redhat.com>
>
> commit bd2fae8da794b55bf2ac02632da3a151b10e664c upstream.

The build of mips malta_kvm_defconfig fails with the error:
In file included from arch/mips/kvm/../../../virt/kvm/kvm_main.c:21:
arch/mips/kvm/../../../virt/kvm/kvm_main.c: In function 'hva_to_pfn_remapped':
./include/linux/kvm_host.h:70:33: error: conversion from 'long long
unsigned int' to 'long unsigned int' changes value from
'9218868437227405314' to '2' [-Werror=overflow]
   70 | #define KVM_PFN_ERR_RO_FAULT    (KVM_PFN_ERR_MASK + 2)
      |                                 ^
arch/mips/kvm/../../../virt/kvm/kvm_main.c:1530:23: note: in expansion
of macro 'KVM_PFN_ERR_RO_FAULT'
 1530 |                 pfn = KVM_PFN_ERR_RO_FAULT;

It built fine after reverting this patch.
gcc version 11.1.1 20210723


-- 
Regards
Sudip

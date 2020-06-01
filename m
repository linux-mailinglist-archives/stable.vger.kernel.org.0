Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06931EB249
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 01:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgFAXh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 19:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgFAXh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 19:37:57 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614F8C05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 16:37:57 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id r11so986826vsj.5
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 16:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8sFjChvsOnugroGpTaalX2UTFDmVFNgsXBxH4Psjpo=;
        b=gy5WnoYjwVwT+AdnTnVAcMO6xsUKQ3HV+niGGFpzvpJ71eeOdaiZZSd7kfAobSbMVB
         XOrGkvuWpDYrUOFUBsilWffiTomQfNPW7uKYsoyR5y2XD36uCo2cUMgt6nHkaWzaO123
         T/6WbGm0oG6415mxA7zL7ifNyV53xlL8haCkWgNxo3DqkVlGD6vVClPWynqWqBMIFxOG
         CKMngEVfHsCMjzEGuOCRn2tiWiHx9PpwmVZzhCGVvXXb9ZRuJmjy4V3WDGb/sf8PFy6t
         YX4uEKTDgj/YpyQo0UeuDPOfsqKmCY+dYqlnG3yA7r72gF+ohPsap55WdgXcuBtl8nrm
         7LHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8sFjChvsOnugroGpTaalX2UTFDmVFNgsXBxH4Psjpo=;
        b=l+IAZMJuy224MmX97/f/oZWrigH8duY3OEq4KLxUmZCU3BcR+POmnffjgury3SeqFD
         kW1xNvU+zoPJ2ZTJ1SB68g+CKSlsVyYbcHtuZDLUgNJllWiA2KDycgPt140xGnpVgSAe
         EfjkfaWpOoFTNFs2SqcoKncZddHROmrXFVsy0R1GTfpAZ/F6l99ZJmP/KDVQSJhCOxjR
         QNhaWC5EFRKVK9g6au7B6WeLslbbtrBl4woXLXX937eA002EQM0f/Q9T/K+cVQQWpxLs
         WlRRX+vqetaqM0bTOlC5gB0K+1RAzZ+iJ+kVYEqeQWulu8nAXeF2Gm+17JJbZ2caAYPF
         sMxQ==
X-Gm-Message-State: AOAM532XC4yvjLMkvSen898cle/7FEBmOxqXVtXNaTd6cPEEDu/I/ADU
        55Mrm1KCzV0yX+lUUCrwf5heQMOJbcnEFJE193ioHA==
X-Google-Smtp-Source: ABdhPJzg702J1EkAo7ZILGUxg4+n2COylsnsv/n0Xy8wNQfF/OkYz+Zf11gC56/0p8tSEx58JooMPRVb9HRwD7H3vnE=
X-Received: by 2002:a67:ce86:: with SMTP id c6mr16538165vse.51.1591054676310;
 Mon, 01 Jun 2020 16:37:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
 <20200601231805.207441-1-ndesaulniers@google.com>
In-Reply-To: <20200601231805.207441-1-ndesaulniers@google.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Mon, 1 Jun 2020 16:37:45 -0700
Message-ID: <CAMn1gO7MrbgpEzaAYZ3vNnbWPdSsHhMkDNXq9rZajur+sqtBsw@mail.gmail.com>
Subject: Re: [PATCH] ACPICA: fix UBSAN warning using __builtin_offsetof
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Robert Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>, guohanjun@huawei.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lorenzo.pieralisi@arm.com, Mark Rutland <mark.rutland@arm.com>,
        rjw@rjwysocki.net, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org, linux-acpi@vger.kernel.org,
        devel@acpica.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 1, 2020 at 4:18 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> Will reported UBSAN warnings:
> UBSAN: null-ptr-deref in drivers/acpi/acpica/tbfadt.c:459:37
> UBSAN: null-ptr-deref in arch/arm64/kernel/smp.c:596:6
>
> Looks like the emulated offsetof macro ACPI_OFFSET is causing these. We
> can avoid this by using the compiler builtin, __builtin_offsetof.

Would it be better to s/ACPI_OFFSET/offsetof/g the existing users of
this macro and remove it? It looks like offsetof is already being used
pervasively in the kernel, and its definition comes from
<linux/stddef.h>.

Peter


Peter

> The non-kernel runtime of UBSAN would print:
> runtime error: member access within null pointer of type
> for this macro.
>
> Link: https://lore.kernel.org/lkml/20200521100952.GA5360@willie-the-truck/
> Cc: stable@vger.kernel.org
> Reported-by: Will Deacon <will@kernel.org>
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  include/acpi/actypes.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
> index 4defed58ea33..04359c70b198 100644
> --- a/include/acpi/actypes.h
> +++ b/include/acpi/actypes.h
> @@ -508,7 +508,7 @@ typedef u64 acpi_integer;
>
>  #define ACPI_TO_POINTER(i)              ACPI_CAST_PTR (void, (acpi_size) (i))
>  #define ACPI_TO_INTEGER(p)              ACPI_PTR_DIFF (p, (void *) 0)
> -#define ACPI_OFFSET(d, f)               ACPI_PTR_DIFF (&(((d *) 0)->f), (void *) 0)
> +#define ACPI_OFFSET(d, f)               __builtin_offsetof(d, f)
>  #define ACPI_PHYSADDR_TO_PTR(i)         ACPI_TO_POINTER(i)
>  #define ACPI_PTR_TO_PHYSADDR(i)         ACPI_TO_INTEGER(i)
>
> --
> 2.27.0.rc2.251.g90737beb825-goog
>

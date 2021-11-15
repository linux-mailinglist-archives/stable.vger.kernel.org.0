Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71613450D37
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238939AbhKORxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:53:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238941AbhKORuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 12:50:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636998475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YGf+XUfSwydKiiv0hT0cmfPV/U4WfCIrm4XgycOeKw8=;
        b=AZT9yyq8TRN5ZUMu2lCon8Kka3GtVHopbCe1wnLDR/Ojl2yW098fv3r+hUrGDLdAMaUCWr
        irHnr9s7wqKZxoQBqzVDEfCxmPunPl6OFPIjFHSOuWoyyvVoyHv7annWu6H7/0ODKfOHVC
        AHb1kYd71Sl09ghe5PWqKIMsERqX+Fk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-pJ-1R3D4NQ-OowetoXCCHA-1; Mon, 15 Nov 2021 12:47:54 -0500
X-MC-Unique: pJ-1R3D4NQ-OowetoXCCHA-1
Received: by mail-wr1-f71.google.com with SMTP id q5-20020a5d5745000000b00178abb72486so3837791wrw.9
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 09:47:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YGf+XUfSwydKiiv0hT0cmfPV/U4WfCIrm4XgycOeKw8=;
        b=LRmTXDpKGajmCvdy6oIn3sqqxhl72NIzcIjmpTMkDUnaGDvwLiKEX/lsn2DPRoNXrq
         gPvgneowD67lEQmPXkIyu4h9kSQnrmHU/xpJiC4dSXL0HIksomo49762xEcblfWtYWbA
         nJ2W8XgFDFOC++VEY9zU7+YOpuBVse+n6etZ0F8i2CYMMffp31ChV4GCul0km0vzX8+f
         lbJ4o4eIYQ9iWJTBDb/kXU7nb4x/gQV90ZzsBevEkmzqbbClkrX69k1g6Rhk8vquB6ev
         th/EI97H3WtPXA+BlrlmBCpCUF0lygNPeZIn+dlI+5qavHUVM2BDI/amhWzkEStXpCZw
         /Sag==
X-Gm-Message-State: AOAM530p5sCgD7Quw3mTbpT+AUMteSdm9IpaIHnxBFl1A+mUSKj8Qf+0
        J15tRfOdGnnberM/sAjOo58IT7AS9GJMwjuJ/DizDfoy1j/VO3DjqmNBAIkQfafFxeHPABVhtfI
        FtcRAjL+NMQaKl+vbjrS2uGI+v6jo6mQI
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr371675wms.74.1636998473161;
        Mon, 15 Nov 2021 09:47:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqKzOEnvwu+fh1qgttyP6hSbaWqXIBdsUkNrLY9BsgCe2smG8I38SVxWF2PmLje6pNL9tmSfjVvcdJ16iCWZI=
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr371664wms.74.1636998473021;
 Mon, 15 Nov 2021 09:47:53 -0800 (PST)
MIME-Version: 1.0
References: <20211115165313.549179499@linuxfoundation.org> <20211115165315.847107930@linuxfoundation.org>
In-Reply-To: <20211115165315.847107930@linuxfoundation.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 15 Nov 2021 18:47:41 +0100
Message-ID: <CAHc6FU7a+gTDCZMCE6gOH1EDUW5SghPbQbsbeVtdg4tV1VdGxg@mail.gmail.com>
Subject: Re: [PATCH 5.4 063/355] powerpc/kvm: Fix kvm_use_magic_page
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

On Mon, Nov 15, 2021 at 6:10 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Andreas Gruenbacher <agruenba@redhat.com>
>
> commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream.
>
> When switching from __get_user to fault_in_pages_readable, commit
> 9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
> fault_in_pages_readable returns 0 on success.

I've not heard back from the maintainers about this patch so far, so
it would probably be safer to leave it out of stable for now.

Thanks,
Andreas

> Fixes: 9f9eae5ce717 ("powerpc/kvm: Prefer fault_in_pages_readable function")
> Cc: stable@vger.kernel.org # v4.18+
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/powerpc/kernel/kvm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/arch/powerpc/kernel/kvm.c
> +++ b/arch/powerpc/kernel/kvm.c
> @@ -669,7 +669,7 @@ static void __init kvm_use_magic_page(vo
>         on_each_cpu(kvm_map_magic_page, &features, 1);
>
>         /* Quick self-test to see if the mapping works */
> -       if (!fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
> +       if (fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
>                 kvm_patching_worked = false;
>                 return;
>         }
>
>


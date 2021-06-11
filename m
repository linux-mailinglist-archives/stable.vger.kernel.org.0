Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BCB3A3972
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 03:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFKCAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 22:00:48 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:45656 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhFKCAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 22:00:47 -0400
Received: by mail-wr1-f44.google.com with SMTP id z8so4251951wrp.12
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 18:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MO2q43uwbSUi+lDsKI3ygKaJ3j77x2GGNRe2JftDmJQ=;
        b=j4xBPGv/5iSK3UOEzyfXHRxOna7zZhwRrbvFcRKq2sBrHObkwCDto37DXa3jNkGh6t
         iLtyf3S2REEEMzzXa0IG0LLAyGPEdYUczzS9YkW+3IjpJQeo1evrYeDqwQ/L6kLGe/h/
         S6QgyJSnX+dwtxs6W2yUPICKYaWUW5vxQqXlXuck5MannUej5posfR+xQW7bQ5Zx0W52
         Bdc5SKEcH/16NpH0P4nrrB48T7DUMQ7NU4Yayyif3czUYQmRUQdLV/dnhrd2F7Oomqa9
         nVUsIi7i9VtpUFTnH0KvvOjCmxv8elT0kmx9Az+18B56b4exfEhtEpjgwkzYYVjXDivI
         3Cqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MO2q43uwbSUi+lDsKI3ygKaJ3j77x2GGNRe2JftDmJQ=;
        b=QBxOjH2jne2URZGhw47L/co6cDLIQ/IoxYCJDsiDuj4zKo94xa7l9PxJrEmq9csUuV
         XmsYz/ESZofOW5TLHL5AnwgiCnxt5PqvA0VHemuj2p5SkPjMlt1USu3u95jfj+pCMhNa
         w7n+cLNIRcTWU6ANF6h8YSQ5QhGYLkJjUPHaCRcQorR8TRAnu+9PzCk7GRlnnm3g77de
         2vfN9TttVE75c8dpNi6xwUd0RYpwNvnMShR0Dec4wkjjir66U7RPIUYZixU+xlAR+/VV
         QkHF7o3KGcR/hgO4u5BhapcL15nr0w7j1bqsn/xI2Ay7lOAf/dgQNs3oUlgFwCnH6+ZG
         9mkQ==
X-Gm-Message-State: AOAM5337yKmiZh7Xlnqp8+/ORt8MWjYhAl3SRHrHiPz06C7fSZ+wtaHK
        p3W30YIFPtdwy+7YDrDphRr9HOVsQJZSSBUDXbJ7vQ==
X-Google-Smtp-Source: ABdhPJzFKfsFTr8EXP8C9pIOuxmYbJd17F9kNgfM9YSAwxMpNmKom5+j3Es7thNFcdlF3ubAJOIx9ScYG9IetV1duj4=
X-Received: by 2002:adf:cf02:: with SMTP id o2mr1141198wrj.365.1623376655221;
 Thu, 10 Jun 2021 18:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210610174604.2554090-1-alpergun@google.com>
In-Reply-To: <20210610174604.2554090-1-alpergun@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 10 Jun 2021 18:57:24 -0700
Message-ID: <CAA03e5Gho1J03gVLB1E-i2Trd3p=a-k6Gim1icD1hD+QHW9_CA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Call SEV Guest Decommission if ASID binding fails
To:     Alper Gun <alpergun@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 10:46 AM Alper Gun <alpergun@google.com> wrote:
>
> Send SEV_CMD_DECOMMISSION command to PSP firmware if ASID binding
> fails. If a failure happens after  a successful LAUNCH_START command,
> a decommission command should be executed. Otherwise, guest context
> will be unfreed inside the AMD SP. After the firmware will not have
> memory to allocate more SEV guest context, LAUNCH_START command will
> begin to fail with SEV_RET_RESOURCE_LIMIT error.
>
> The existing code calls decommission inside sev_unbind_asid, but it is
> not called if a failure happens before guest activation succeeds. If
> sev_bind_asid fails, decommission is never called. PSP firmware has a
> limit for the number of guests. If sev_asid_binding fails many times,
> PSP firmware will not have resources to create another guest context.
>
> Cc: stable@vger.kernel.org
> Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START command")
> Reported-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Alper Gun <alpergun@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e0ce5da97fc2..8d36f0c73071 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -199,9 +199,19 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>         sev->misc_cg = NULL;
>  }
>
> -static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
> +static void sev_decommission(unsigned int handle)
>  {
>         struct sev_data_decommission decommission;
> +
> +       if (!handle)
> +               return;
> +
> +       decommission.handle = handle;
> +       sev_guest_decommission(&decommission, NULL);
> +}
> +
> +static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
> +{
>         struct sev_data_deactivate deactivate;
>
>         if (!handle)
> @@ -214,9 +224,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>         sev_guest_deactivate(&deactivate, NULL);
>         up_read(&sev_deactivate_lock);
>
> -       /* decommission handle */
> -       decommission.handle = handle;
> -       sev_guest_decommission(&decommission, NULL);
> +       sev_decommission(handle);
>  }
>
>  static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> @@ -341,8 +349,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>
>         /* Bind ASID to this guest */
>         ret = sev_bind_asid(kvm, start.handle, error);
> -       if (ret)
> +       if (ret) {
> +               sev_decommission(start.handle);
>                 goto e_free_session;
> +       }
>
>         /* return handle to userspace */
>         params.handle = start.handle;
> --
> 2.32.0.272.g935e593368-goog
>

Reviewed-by: Marc Orr <marcorr@google.com>

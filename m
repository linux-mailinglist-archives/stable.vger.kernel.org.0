Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11450573D0C
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 21:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbiGMTPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 15:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiGMTPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 15:15:44 -0400
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306E71F2D8;
        Wed, 13 Jul 2022 12:15:43 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id 64so20901012ybt.12;
        Wed, 13 Jul 2022 12:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WadcFO2ofb7EmxBEnBo4nXzeB9hmmz1tEajKg3FY4pw=;
        b=wQ1Ej2xwmFxM1BV1Bj/sR7phdL/sKceGh4e7NJ4a0k+gkDLXfiTi4+jCrn3Np0bx2I
         MXC4TrhHRMlJw9OgALVMMWQcTePLzJdeXKvGcvhaCyrNtVXd7wHtIDT6nWQaUXgo0nTi
         g8oVYj03EtQLBL982TlZMQUI+ORKX08tbcojwHReOuZesL/VMp6czRx52Z+lZG5WZ2m0
         qPeX21J+1k/lmZN8nsTomkFfmDyWGr4GG3cHhx2C3F7Zdews3qweEzppJGI7P/GULrEb
         CX5rpsJYZujTPpp3tOLR84i9cD0J3sq2NBrxiE2yvrUyP40WU7fBjWIsQMNsJcZQXgMb
         ysvg==
X-Gm-Message-State: AJIora9z3uI4ec9paqeQo0hymSgGypBPUieGcf6/bwWTr4U3uQvz0oHz
        wRlHO+eLaQEsP7roSWhbrw+M3Ens7GhMRD6lWLw=
X-Google-Smtp-Source: AGRyM1uhuP1kfMx0XnXYPp6aAIlao66vkvbDAB8FNec0u0hroyZAwmVi1g5v8ayI2pw1PKnj2S6J+zmCVyzAzoqiwWA=
X-Received: by 2002:a25:a2ca:0:b0:66e:719e:279 with SMTP id
 c10-20020a25a2ca000000b0066e719e0279mr4946716ybn.622.1657739742431; Wed, 13
 Jul 2022 12:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220713175346.630-1-mario.limonciello@amd.com>
In-Reply-To: <20220713175346.630-1-mario.limonciello@amd.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 13 Jul 2022 21:15:31 +0200
Message-ID: <CAJZ5v0h4m+efJGQT6uKpPLdqLgHOpp1mXw5pLO_TBY+NimhMog@mail.gmail.com>
Subject: Re: [PATCH] ACPI: CPPC: Fix enabling CPPC on AMD systems with shared memory
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Pierre Gondois <pierre.gondois@arm.com>,
        "Yuan, Perry" <perry.yuan@amd.com>, Huang Rui <ray.huang@amd.com>,
        Stable <stable@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 7:54 PM Mario Limonciello
<mario.limonciello@amd.com> wrote:
>
> When commit 72f2ecb7ece7 ("ACPI: bus: Set CPPC _OSC bits for all
> and when CPPC_LIB is supported") was introduced, we found collateral
> damage that a number of AMD systems that supported CPPC but
> didn't advertise support in _OSC stopped having a functional
> amd-pstate driver. The _OSC was only enforced on Intel systems at that
> time.
>
> This was fixed for the MSR based designs by commit 8b356e536e69f
> ("ACPI: CPPC: Don't require _OSC if X86_FEATURE_CPPC is supported")
> but some shared memory based designs also support CPPC but haven't
> advertised support in the _OSC.  Add support for those designs as well by
> hardcoding the list of systems.
>
> Fixes: 72f2ecb7ece7 ("ACPI: bus: Set CPPC _OSC bits for all and when CPPC_LIB is supported")
> Fixes: 8b356e536e69f ("ACPI: CPPC: Don't require _OSC if X86_FEATURE_CPPC is supported")
> Link: https://lore.kernel.org/all/3559249.JlDtxWtqDm@natalenko.name/
> Cc: stable@vger.kernel.org # 5.18
> Reported-and-tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  arch/x86/kernel/acpi/cppc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kernel/acpi/cppc.c b/arch/x86/kernel/acpi/cppc.c
> index 734b96454896..8d8752b44f11 100644
> --- a/arch/x86/kernel/acpi/cppc.c
> +++ b/arch/x86/kernel/acpi/cppc.c
> @@ -16,6 +16,12 @@ bool cpc_supported_by_cpu(void)
>         switch (boot_cpu_data.x86_vendor) {
>         case X86_VENDOR_AMD:
>         case X86_VENDOR_HYGON:
> +               if (boot_cpu_data.x86 == 0x19 && ((boot_cpu_data.x86_model <= 0x0f) ||
> +                   (boot_cpu_data.x86_model >= 0x20 && boot_cpu_data.x86_model <= 0x2f)))
> +                       return true;
> +               else if (boot_cpu_data.x86 == 0x17 &&
> +                        boot_cpu_data.x86_model >= 0x70 && boot_cpu_data.x86_model <= 0x7f)
> +                       return true;
>                 return boot_cpu_has(X86_FEATURE_CPPC);
>         }
>         return false;
> --

Applied as 5.19-rc material, thanks!

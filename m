Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03FF3F67E4
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 08:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfKJHeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 02:34:03 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54739 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfKJHeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 02:34:03 -0500
Received: by mail-wm1-f67.google.com with SMTP id z26so10153738wmi.4
        for <stable@vger.kernel.org>; Sat, 09 Nov 2019 23:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qyAeemgL7xhJSlWUlM1fmeVInAEJkwPviCWCGC8D1Bg=;
        b=SMLdkpHH91y2wkQ9HTwsxrZ86VQkFNK7V+UajklDG6Qambpevqsy5/j3tmlVQP5oHG
         OMu6+9WpRLK/tzJLWnYMOT+dhVK8eD8D1wc6ahQSt9BYEnDd22PS+ECYe94T6Hjhsj6u
         cYyobA3aTeI8MdFPycK+knx2FmX8fWcVu7NKXEekOtjnLR7uO+aDDFRIFlp8+tIU79AS
         WQyH2Oxs73ZXib/KCrpRwsDyR4PKIYs4crRvp48jyZ3T8dcKnaFiOmPS4mExRg9fqeP6
         9T16Xrycfj1e8em4AqcKuvDOmDEsSbkNmjcuhJiVCkTKavh+CI0aoB59V/SrE5/GTcbb
         zBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qyAeemgL7xhJSlWUlM1fmeVInAEJkwPviCWCGC8D1Bg=;
        b=imBAk6U7NAy2o+ePhyJLkwpQoiVI44N2/CmrNY8+ZcYp7HhIkyTGqc2w35wlxdpKXL
         5qf6hIxzyQJzLIdSFprtBpLONoc26npR8z1vXfywO/R12TAUslITw3ZrneVmYUqIr+Mj
         cdWVrpv2DdcgNuY6NPz3jnILgl5ljqx/KHa1M+YNfBYhdbOYkezA3Wh5ihlGrgEeByCo
         +BgXay3ITPNyCOnZlKCFB2ayHwoG73/1wm9+DJYd2Jnbw5RvFOzXfKzDem3yiFHCXDTA
         HlhY5vQ5gIvASqtHKxnAOcs1CnvASitAiCsADz/AHX8/yW92nf8Pw3RSGmgbJXseuEJC
         n7XA==
X-Gm-Message-State: APjAAAU/X2oH7RMlmWQgJwNly85bow95v1is2IkrvaGGTwtrN5sWX9qa
        lf46C6ejuco2FBvCzn+n0YT/mVnuvXskhCQYVd7LpT/s4z4=
X-Google-Smtp-Source: APXvYqyvlV7oOMeMDxvuHMNh1BX+01oTY5O12crUgF3Indk14wltUe4Dq/d01efAY6X/dC4Y38tH0Tstds5bVX9IRPI=
X-Received: by 2002:a7b:c392:: with SMTP id s18mr13871503wmj.61.1573371238725;
 Sat, 09 Nov 2019 23:33:58 -0800 (PST)
MIME-Version: 1.0
References: <20191110024013.29782-1-sashal@kernel.org> <20191110024013.29782-133-sashal@kernel.org>
In-Reply-To: <20191110024013.29782-133-sashal@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 10 Nov 2019 08:33:47 +0100
Message-ID: <CAKv+Gu-PawCS_Wq3Hm+gm_f=6-ihXarkQqP9prkj4CLt=pAnvg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 133/191] efi: honour memory reservations
 passed via a linux specific config table
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        linux-efi <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 10 Nov 2019 at 03:44, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> [ Upstream commit 71e0940d52e107748b270213a01d3b1546657d74 ]
>
> In order to allow the OS to reserve memory persistently across a
> kexec, introduce a Linux-specific UEFI configuration table that
> points to the head of a linked list in memory, allowing each kernel
> to add list items describing memory regions that the next kernel
> should treat as reserved.
>
> This is useful, e.g., for GICv3 based ARM systems that cannot disable
> DMA access to the LPI tables, forcing them to reuse the same memory
> region again after a kexec reboot.
>
> Tested-by: Jeremy Linton <jeremy.linton@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

NAK

This doesn't belong in -stable, and I'd be interested in understanding
how this got autoselected, and how I can prevent this from happening
again in the future.


> ---
>  drivers/firmware/efi/efi.c | 27 ++++++++++++++++++++++++++-
>  include/linux/efi.h        |  8 ++++++++
>  2 files changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index d54fca902e64f..f265309859781 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -52,7 +52,8 @@ struct efi __read_mostly efi = {
>         .properties_table       = EFI_INVALID_TABLE_ADDR,
>         .mem_attr_table         = EFI_INVALID_TABLE_ADDR,
>         .rng_seed               = EFI_INVALID_TABLE_ADDR,
> -       .tpm_log                = EFI_INVALID_TABLE_ADDR
> +       .tpm_log                = EFI_INVALID_TABLE_ADDR,
> +       .mem_reserve            = EFI_INVALID_TABLE_ADDR,
>  };
>  EXPORT_SYMBOL(efi);
>
> @@ -487,6 +488,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
>         {EFI_MEMORY_ATTRIBUTES_TABLE_GUID, "MEMATTR", &efi.mem_attr_table},
>         {LINUX_EFI_RANDOM_SEED_TABLE_GUID, "RNG", &efi.rng_seed},
>         {LINUX_EFI_TPM_EVENT_LOG_GUID, "TPMEventLog", &efi.tpm_log},
> +       {LINUX_EFI_MEMRESERVE_TABLE_GUID, "MEMRESERVE", &efi.mem_reserve},
>         {NULL_GUID, NULL, NULL},
>  };
>
> @@ -594,6 +596,29 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
>                 early_memunmap(tbl, sizeof(*tbl));
>         }
>
> +       if (efi.mem_reserve != EFI_INVALID_TABLE_ADDR) {
> +               unsigned long prsv = efi.mem_reserve;
> +
> +               while (prsv) {
> +                       struct linux_efi_memreserve *rsv;
> +
> +                       /* reserve the entry itself */
> +                       memblock_reserve(prsv, sizeof(*rsv));
> +
> +                       rsv = early_memremap(prsv, sizeof(*rsv));
> +                       if (rsv == NULL) {
> +                               pr_err("Could not map UEFI memreserve entry!\n");
> +                               return -ENOMEM;
> +                       }
> +
> +                       if (rsv->size)
> +                               memblock_reserve(rsv->base, rsv->size);
> +
> +                       prsv = rsv->next;
> +                       early_memunmap(rsv, sizeof(*rsv));
> +               }
> +       }
> +
>         return 0;
>  }
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index cc3391796c0b8..f43fc61fbe2c9 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -672,6 +672,7 @@ void efi_native_runtime_setup(void);
>  #define LINUX_EFI_LOADER_ENTRY_GUID            EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,  0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
>  #define LINUX_EFI_RANDOM_SEED_TABLE_GUID       EFI_GUID(0x1ce1e5bc, 0x7ceb, 0x42f2,  0x81, 0xe5, 0x8a, 0xad, 0xf1, 0x80, 0xf5, 0x7b)
>  #define LINUX_EFI_TPM_EVENT_LOG_GUID           EFI_GUID(0xb7799cb0, 0xeca2, 0x4943,  0x96, 0x67, 0x1f, 0xae, 0x07, 0xb7, 0x47, 0xfa)
> +#define LINUX_EFI_MEMRESERVE_TABLE_GUID                EFI_GUID(0x888eb0c6, 0x8ede, 0x4ff5,  0xa8, 0xf0, 0x9a, 0xee, 0x5c, 0xb9, 0x77, 0xc2)
>
>  typedef struct {
>         efi_guid_t guid;
> @@ -957,6 +958,7 @@ extern struct efi {
>         unsigned long mem_attr_table;   /* memory attributes table */
>         unsigned long rng_seed;         /* UEFI firmware random seed */
>         unsigned long tpm_log;          /* TPM2 Event Log table */
> +       unsigned long mem_reserve;      /* Linux EFI memreserve table */
>         efi_get_time_t *get_time;
>         efi_set_time_t *set_time;
>         efi_get_wakeup_time_t *get_wakeup_time;
> @@ -1667,4 +1669,10 @@ extern int efi_tpm_eventlog_init(void);
>  /* Workqueue to queue EFI Runtime Services */
>  extern struct workqueue_struct *efi_rts_wq;
>
> +struct linux_efi_memreserve {
> +       phys_addr_t     next;
> +       phys_addr_t     base;
> +       phys_addr_t     size;
> +};
> +
>  #endif /* _LINUX_EFI_H */
> --
> 2.20.1
>

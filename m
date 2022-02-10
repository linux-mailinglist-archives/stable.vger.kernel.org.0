Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817664B0B4A
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 11:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240105AbiBJKrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 05:47:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240153AbiBJKrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 05:47:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6731013;
        Thu, 10 Feb 2022 02:47:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBC0FB8243C;
        Thu, 10 Feb 2022 10:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B128C340F1;
        Thu, 10 Feb 2022 10:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644490062;
        bh=9wxC2ohwSsmxyDPagb62w902qK6d55OxtY0vmSam7j0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tRWgrSV6WZxbdD9PioGgHF+AT89TpZJnkw5Pc7sbO2VIOkt2lh21eVMQ50gVR3qaA
         traACGQG7ATmTZwWrAmTtKWC4FpKgqJUm7c7Hn+pAwlC6WVK0271hDotJRTGMksxsb
         GNJvmDE+D5uZg3pGiuS5Y+4oLkhsrpE5jjpYUA5dYs1yVmm8OEvqGFjx8xVHXOPTmG
         oXP64J6ECuE/SZJ7pVz/t6ssGhKEeGPmWpII/GRG7ngRYit32ikXqt6X41L9pWJreh
         JYJEDOIloSe9DnD4C6Dnvyd9FtOvcJBxk4cXb5ohogRs/B5QDFI1Jw92g7w/S+XSo6
         9gbvg9IDCxelA==
Received: by mail-wr1-f44.google.com with SMTP id q7so8673918wrc.13;
        Thu, 10 Feb 2022 02:47:42 -0800 (PST)
X-Gm-Message-State: AOAM532DWKAZyznh9tYrBgYnbLxO0dPaTcAD30SgILLj1/TA18mGDBMR
        eHvPsNWuyhc232WL3ooavL1Sc7jpeRX3Gs8gSJs=
X-Google-Smtp-Source: ABdhPJzQUjs7BxoWJcRm1HjlvVFqrwf0ZBI2C9GRDqkM5lZAUSddNkkZ6PCOvFq9jZnm5l5laSR+g/93w+Wp0DGvwzc=
X-Received: by 2002:a05:6000:15ca:: with SMTP id y10mr5852990wry.417.1644490060790;
 Thu, 10 Feb 2022 02:47:40 -0800 (PST)
MIME-Version: 1.0
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <755cffe1dfaf43ea87cfeea124160fe0@AcuMS.aculab.com> <B6D697AB-2AC5-4925-8300-26BBB4AC3D99@live.com>
 <20103919-A276-4CA6-B1AD-6E45DB58500B@live.com>
In-Reply-To: <20103919-A276-4CA6-B1AD-6E45DB58500B@live.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 10 Feb 2022 11:47:29 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFCibuLxbv2VxVsS0mWJ=6Lv8Q8sNq2GfPQDJ9qi5XB8w@mail.gmail.com>
Message-ID: <CAMj1kXFCibuLxbv2VxVsS0mWJ=6Lv8Q8sNq2GfPQDJ9qi5XB8w@mail.gmail.com>
Subject: Re: [PATCH v2] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
To:     Aditya Garg <gargaditya08@live.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@hansenpartnership.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "mic@digikod.net" <mic@digikod.net>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Feb 2022 at 11:45, Aditya Garg <gargaditya08@live.com> wrote:
>
> From: Aditya Garg <gargaditya08@live.com>
>
> On T2 Macs, the secure boot is handled by the T2 Chip. If enabled, only
> macOS and Windows are allowed to boot on these machines. Thus we need to
> disable secure boot for Linux. If we boot into Linux after disabling
> secure boot, if CONFIG_LOAD_UEFI_KEYS is enabled, EFI Runtime services
> fail to start, with the following logs in dmesg
>
> Call Trace:
>  <TASK>
>  page_fault_oops+0x4f/0x2c0
>  ? search_bpf_extables+0x6b/0x80
>  ? search_module_extables+0x50/0x80
>  ? search_exception_tables+0x5b/0x60
>  kernelmode_fixup_or_oops+0x9e/0x110
>  __bad_area_nosemaphore+0x155/0x190
>  bad_area_nosemaphore+0x16/0x20
>  do_kern_addr_fault+0x8c/0xa0
>  exc_page_fault+0xd8/0x180
>  asm_exc_page_fault+0x1e/0x30
> (Removed some logs from here)
>  ? __efi_call+0x28/0x30
>  ? switch_mm+0x20/0x30
>  ? efi_call_rts+0x19a/0x8e0
>  ? process_one_work+0x222/0x3f0
>  ? worker_thread+0x4a/0x3d0
>  ? kthread+0x17a/0x1a0
>  ? process_one_work+0x3f0/0x3f0
>  ? set_kthread_struct+0x40/0x40
>  ? ret_from_fork+0x22/0x30
>  </TASK>
> ---[ end trace 1f82023595a5927f ]---
> efi: Froze efi_rts_wq and disabled EFI Runtime Services
> integrity: Couldn't get size: 0x8000000000000015
> integrity: MODSIGN: Couldn't get UEFI db list
> efi: EFI Runtime Services are disabled!
> integrity: Couldn't get size: 0x8000000000000015
> integrity: Couldn't get UEFI dbx list
> integrity: Couldn't get size: 0x8000000000000015
> integrity: Couldn't get mokx list
> integrity: Couldn't get size: 0x80000000
>
> This patch prevents querying of these UEFI variables, since these Macs
> seem to use a non-standard EFI hardware
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> ---
> v2 :- Reduce code size of the table.

NAK. As Matthew pointed out, other reads of the same variables may
still trigger the same issue.


>  .../platform_certs/keyring_handler.h          |  8 ++++
>  security/integrity/platform_certs/load_uefi.c | 48 +++++++++++++++++++
>  2 files changed, 56 insertions(+)
>
> diff --git a/security/integrity/platform_certs/keyring_handler.h b/security/integrity/platform_certs/keyring_handler.h
> index 2462bfa08..cd06bd607 100644
> --- a/security/integrity/platform_certs/keyring_handler.h
> +++ b/security/integrity/platform_certs/keyring_handler.h
> @@ -30,3 +30,11 @@ efi_element_handler_t get_handler_for_db(const efi_guid_t *sig_type);
>  efi_element_handler_t get_handler_for_dbx(const efi_guid_t *sig_type);
>
>  #endif
> +
> +#ifndef UEFI_QUIRK_SKIP_CERT
> +#define UEFI_QUIRK_SKIP_CERT(vendor, product) \
> +                .matches = { \
> +                       DMI_MATCH(DMI_BOARD_VENDOR, vendor), \
> +                       DMI_MATCH(DMI_PRODUCT_NAME, product), \
> +               },
> +#endif
> diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
> index 08b6d12f9..f246c8732 100644
> --- a/security/integrity/platform_certs/load_uefi.c
> +++ b/security/integrity/platform_certs/load_uefi.c
> @@ -3,6 +3,7 @@
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/cred.h>
> +#include <linux/dmi.h>
>  #include <linux/err.h>
>  #include <linux/efi.h>
>  #include <linux/slab.h>
> @@ -12,6 +13,32 @@
>  #include "../integrity.h"
>  #include "keyring_handler.h"
>
> +/* Apple Macs with T2 Security chip don't support these UEFI variables.
> + * The T2 chip manages the Secure Boot and does not allow Linux to boot
> + * if it is turned on. If turned off, an attempt to get certificates
> + * causes a crash, so we simply return 0 for them in each function.
> + */
> +
> +static const struct dmi_system_id uefi_skip_cert[] = {
> +
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,1" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,2" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,3" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,4" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,1" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,2" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,3" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,4" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1" },
> +       { UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2" },
> +       { }
> +};
> +
>  /*
>   * Look to see if a UEFI variable called MokIgnoreDB exists and return true if
>   * it does.
> @@ -21,12 +48,18 @@
>   * is set, we should ignore the db variable also and the true return indicates
>   * this.
>   */
> +
>  static __init bool uefi_check_ignore_db(void)
>  {
>         efi_status_t status;
>         unsigned int db = 0;
>         unsigned long size = sizeof(db);
>         efi_guid_t guid = EFI_SHIM_LOCK_GUID;
> +       const struct dmi_system_id *dmi_id;
> +
> +       dmi_id = dmi_first_match(uefi_skip_cert);
> +       if (dmi_id)
> +               return 0;
>
>         status = efi.get_variable(L"MokIgnoreDB", &guid, NULL, &size, &db);
>         return status == EFI_SUCCESS;
> @@ -41,6 +74,11 @@ static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
>         unsigned long lsize = 4;
>         unsigned long tmpdb[4];
>         void *db;
> +       const struct dmi_system_id *dmi_id;
> +
> +       dmi_id = dmi_first_match(uefi_skip_cert);
> +       if (dmi_id)
> +               return 0;
>
>         *status = efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
>         if (*status == EFI_NOT_FOUND)
> @@ -85,6 +123,11 @@ static int __init load_moklist_certs(void)
>         unsigned long moksize;
>         efi_status_t status;
>         int rc;
> +       const struct dmi_system_id *dmi_id;
> +
> +       dmi_id = dmi_first_match(uefi_skip_cert);
> +       if (dmi_id)
> +               return 0;
>
>         /* First try to load certs from the EFI MOKvar config table.
>          * It's not an error if the MOKvar config table doesn't exist
> @@ -138,6 +181,11 @@ static int __init load_uefi_certs(void)
>         unsigned long dbsize = 0, dbxsize = 0, mokxsize = 0;
>         efi_status_t status;
>         int rc = 0;
> +       const struct dmi_system_id *dmi_id;
> +
> +       dmi_id = dmi_first_match(uefi_skip_cert);
> +       if (dmi_id)
> +               return 0;
>
>         if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
>                 return false;
> --
> 2.25.1
>
>

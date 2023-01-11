Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C875B6664C5
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 21:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbjAKUXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 15:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjAKUXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 15:23:03 -0500
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A379E0BF;
        Wed, 11 Jan 2023 12:23:02 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id m21so24060852edc.3;
        Wed, 11 Jan 2023 12:23:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c2ew51IPhiFHUgNo3p4kdBu8zvGFD5L/jd43Yv0kTsM=;
        b=ocI5JOdGj+w7rySrGAEyMrws4teNBl/ShIxd2XVtx9fdF29iaQzBFet8w5C/Fh6fGb
         ZGTvetiDWQf1sfhdS3PkLnpBOxdmrUbRBrj2A+8s6ouNtt1tBhUHRSw77vrwUUuRZ8tR
         Xqk5W/2uzQs/+o3Ph2LFJ6J7ClI3mIN0Y2xQsE1fpkrVkj8uxgdkrWnlzhr+mKxBpIOh
         6b8CODirDW+uBM4fMD21cakX80v1YmfevHYT/uJuPezZXAoq0pVdrO2+8xmIGx2/se9B
         QrNyWaLqINgyveclc/AmJMm+L5zkSc6UGn3fnVGdnkqyii42DCbdFbRPGoXiRWr6K4DK
         aMXg==
X-Gm-Message-State: AFqh2komBGvyuij4OxD2QMaMvKuNhBdVQ8+NAMc/xI9gfBQgu5fZk6wx
        +9pgJJF2l/RlTM4J8duDAcI55DTLlt/elXN4rieaVlz1c0A=
X-Google-Smtp-Source: AMrXdXsOVhWulPRERmxtCqcVKdkHww/EqX7DF+zDJI37A8xB1Bmpx6XRsXnCoTzMaeQrNJo6Hp0lGCZeikGzbJov2to=
X-Received: by 2002:aa7:c853:0:b0:47e:4f0b:7ad9 with SMTP id
 g19-20020aa7c853000000b0047e4f0b7ad9mr5327975edt.239.1673468580768; Wed, 11
 Jan 2023 12:23:00 -0800 (PST)
MIME-Version: 1.0
References: <20230111132734.1571990-1-ardb@kernel.org>
In-Reply-To: <20230111132734.1571990-1-ardb@kernel.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 11 Jan 2023 21:22:49 +0100
Message-ID: <CAJZ5v0hZMGMBnYog1CwUfGe8WU9GHmNgdn3gJdwdpiz-V2J-Ow@mail.gmail.com>
Subject: Re: [PATCH] ACPI: PRM: Check whether EFI runtime is available
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-efi@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 11, 2023 at 2:27 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> The ACPI PRM address space handler calls efi_call_virt_pointer() to
> execute PRM firmware code, but doing so is only permitted when the EFI
> runtime environment is available. Otherwise, such calls are guaranteed
> to result in a crash, and must therefore be avoided.
>
> Cc: <stable@vger.kernel.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/acpi/prmt.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
> index 998101cf16e47145..74f924077866ae69 100644
> --- a/drivers/acpi/prmt.c
> +++ b/drivers/acpi/prmt.c
> @@ -236,6 +236,11 @@ static acpi_status acpi_platformrt_space_handler(u32 function,
>         efi_status_t status;
>         struct prm_context_buffer context;
>
> +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> +               pr_err("PRM: EFI runtime services unavailable\n");
> +               return AE_NOT_IMPLEMENTED;
> +       }
> +

Does the check need to be made in the address space handler and if so, then why?

It looks like it would be better to prevent it from being installed if
EFI runtime services are not enabled in the first place, in
init_prmt().

>         /*
>          * The returned acpi_status will always be AE_OK. Error values will be
>          * saved in the first byte of the PRM message buffer to be used by ASL.
> --
